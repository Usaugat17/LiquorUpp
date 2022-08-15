import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/string_extension.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class NotificationUitls {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init(BuildContext context) async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );
    await _notification.initialize(initializationSettings,
        onSelectNotification: (v) => onClickedNotification(context, v));

// send notification
    if (UserModel.instance.settings.notify) {
      final lowItem = UserModel.instance.inventory.items.where((element) =>
          element.quantity < UserModel.instance.settings.notifyLowThreshold);
      int i = 5;
      lowItem.forEach((e) {
        Future.delayed(Duration(seconds: i), () {
          showNotif(
            title: e.itemName.capitalize(),
            body: 'Inventory on item ${e.itemName} is running low.',
            payload: e.itemCode,
          );
        });
        i += 2;
      });
    }
  }

  static onClickedNotification(BuildContext context, String? item) async {
    // print(item ?? "Water");
    await Navigator.of(context).pushNamed(AppRouter.itemRoute, arguments: [
      UserModel.instance.inventory.items
          .firstWhere((element) => element.itemCode == item),
      context
    ]);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channel id',
      'd',
      channelDescription: 'd',
      importance: Importance.max,
      ticker: 'killer',
    ));
  }

  static void showNotif({int? id, title, body, payload}) async {
    return _notification.show(
      id ?? Random().nextInt(10000),
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }
}
