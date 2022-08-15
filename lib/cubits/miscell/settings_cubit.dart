import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';
import 'package:liquor_inventory/utils/notificaion_uitls.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:liquor_inventory/utils/widgets.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  // notfication
  void toggleNotfication(BuildContext context, bool value) {
    UserModel.instance.settings.notify = value;
    value ? NotificationUitls.init(context) : "";
    UserModel.instance.save(feedback: false);
    emit(SettingStateNotificToggled());
  }

  void setNotifThreshold(BuildContext context, int value) {
    UserModel.instance.settings.notifyLowThreshold = value;
    UserModel.instance.save(feedback: false);
    emit(SettingStateNotifThresholdChanged());
  }

  // password change

  void changePassword(
      BuildContext context, String current, String newPassword, String newPWR) {
    if (newPassword.trim() != newPWR.trim()) {
      Utils.toast("New Passwords Does't Match!");
      return;
    } else if (current != UserModel.instance.password) {
      Utils.toast("Current Passwords Do Not Match!");
    } else {}
  }

  // logout
  void logOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Widgets.confimationDialog(
                context, "Logout", "Do you really want to logout?",
                (BuildContext context) {
              FirebaseUtils.handleLogOut(context, () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.loginRoute, (route) => false);
              });
            }));
  }
}
