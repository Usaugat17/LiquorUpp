import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';

class Utils {
  static const String NOT_AVAILABLE = "NA";
  static const double ZERO_DOT_ZERO = 0.0;
  static const int ZERO = 0;
  static const String TIME_STAMP_FORMAT = 'y MMM d E h:m:s';
  static bool canSaveItem = true;
  static const String DATE_FORMAT = 'y MMM d';

  static const String NAME = "Name";
  static const String SIZE = "Size";
  static const String PRICE = "Price";
  static const String DISTILLERY = "Distillery";
  static const String LOCATION = "Location";
  static const String AGE = "Age";
  static const String QUANTITY = "Quantity";
  static dynamic addButtonState = (v) {};

  static String tempText = "";

  static const String PLACEHOLDER_LIQOUR = 'assets/images/yarsa.png';
  static const String PLACEHOLDER_ADDIMAGE = 'assets/images/add-picture.png';
  static const String ASSETS_SPLASH = 'assets/images/splash.png';
  static const String ASSETS_APP_ICON = 'assets/images/app-logo.png';
  static final Random _random = Random.secure();

  static dynamic gtCurrenDate(
      {format = TIME_STAMP_FORMAT,
      Duration plus = const Duration(),
      string = true}) {
    final date = DateTime.now().add(plus);
    return string ? DateFormat(format).format(date) : date;
  }

  static DateTime toDate(String date, {format = DATE_FORMAT}) =>
      DateFormat(format).parse(date);

  static int compareDate(String date1, String date2, {format = DATE_FORMAT}) =>
      toDate(date1, format: format).compareTo(toDate(date2, format: format));

  static String extractDate(String timeStamp, {format = TIME_STAMP_FORMAT}) {
    return DateFormat(DATE_FORMAT).format(DateFormat(format).parse(timeStamp));
  }

  static bool same(
      {required date, required int year, int? month, format = DATE_FORMAT}) {
    final d = DateFormat(format).parse(date);
    month = month ?? d.month;

    return d.year == year && d.month == month;
  }

  static bool sameDay(date1, date2, {format = TIME_STAMP_FORMAT}) {
    return toDate(date1, format: format).day ==
        toDate(date2, format: format).day;
  }

  static bool ofToday(date, {format = TIME_STAMP_FORMAT}) {
    return sameDay(gtCurrenDate(), date, format: format);
  }

  static String genCrpytoKey({int length = 32}) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values).toUpperCase();
  }

  static Duration gtTimeDiff(String date, {format = TIME_STAMP_FORMAT}) {
    return DateFormat(format)
        .parse(Utils.gtCurrenDate())
        .difference(DateFormat(format).parse(date));
  }

  static void 
  imagePicker(context, onComplete) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        imageFromGallery(context, onComplete);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imageFromCamera(context, onComplete);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static imageFromCamera(context, onComplete) async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 50);
    onComplete(image!.path);
  }

  static imageFromGallery(context, onComplete) async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 50);
    onComplete(image!.path);
  }

  static toast(String msg) {
    Fluttertoast.showToast(
      msg: msg, // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM, // location
    );
  }

  static ImageProvider gtImageOr(String image, String or) {
    try {
      return Image.network(
        image,
        errorBuilder: (c, e, st) {
          return Image.asset(or);
        },
      ).image;
    } catch (e) {
      return AssetImage(or);
    }
  }

  static Widget gtImage(String image, String placeholder,
      {double? width, double height = 100, fit = BoxFit.fitWidth, fitOr}) {
    return FadeInImage(
      width: width,
      height: height,
      image: NetworkImage(image),
      fit: fit,
      placeholder: AssetImage(placeholder),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(placeholder, fit: fitOr ?? fit);
      },
    );
  }

  static onTextEvent(dynamic Function(Item) value) =>
      (BuildContext context, a1, a2) {
        final items = UserModel.instance.inventory.items;
        // print("Here $a1");
        BlocProvider.of<InventoryCubit>(context).itemUpdated(context,
            items.where((e) => (value(e) as String).contains(a1)).toList());
      };
  static onNumberEvent(dynamic Function(Item) value) =>
      (BuildContext context, a1, a2) {
        final items = UserModel.instance.inventory.items;
        // print("Here $a1 $a2");
        BlocProvider.of<InventoryCubit>(context).itemUpdated(
            context,
            items.where((e) {
              num val = value(e);
              return a1 <= val && val <= a2;
            }).toList());
      };
  static sortBy(BuildContext context, String by, {ascending = false}) {
    final items = UserModel.instance.inventory.items;
    // print(ascending);
    final getter = _by[by];
    final compare = ascending
        ? (a, b) => getter(a).compareTo(getter(b))
        : (a, b) => getter(b).compareTo(getter(a));

    items.sort((a, b) => compare(a, b));

    BlocProvider.of<InventoryCubit>(context).itemUpdated(context, items);
  }

  static get _by => {
        NAME: (Item e) => e.itemName,
        SIZE: (Item e) => e.size,
        PRICE: (Item e) => e.price,
        DISTILLERY: (Item e) => e.distillery,
        LOCATION: (Item e) => e.location,
        AGE: (Item e) => e.age,
        QUANTITY: (Item e) => e.quantity,
      };

  static searchBy(String by) {
    final onSearchEvents = {
      NAME: onTextEvent,
      SIZE: onNumberEvent,
      PRICE: onNumberEvent,
      DISTILLERY: onTextEvent,
      LOCATION: onTextEvent,
      AGE: onNumberEvent,
      QUANTITY: onNumberEvent
    };
    return onSearchEvents[by]!(_by[by] ?? (Item i) => i.itemName);
  }
}
