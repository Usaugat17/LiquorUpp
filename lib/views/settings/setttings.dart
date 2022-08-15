import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/miscell/settings_cubit.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/widgets.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  String currentPW = "", newPW = "", newRTYP = "";
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController itemLowCountController = TextEditingController(
      text: UserModel.instance.settings.notifyLowThreshold.toString());
  TextEditingController notifyToggleContainer = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Widgets.backButton(context),
          actions: [const SizedBox(width: 20)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              pageHeader(context, "Settings"),
              verticalSpacing(30),
              contentHeader("Notifications"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notify when item is running low",
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  toggleNotificationSwitch(),
                ],
              ),
              setItemLowCount(),
              verticalSpacing(30),
              contentHeader("Change Password"),
              _passwordFieldWrapper(
                  "Current Password", currentPasswordController, (v) {
                widget.currentPW = v;
              }),
              _passwordFieldWrapper("New Password", newPasswordController, (v) {
                widget.newPW = v;
              }),
              _passwordFieldWrapper(
                  "Re-type New Password", confirmPasswordController, (v) {
                widget.newRTYP = v;
              }),
              verticalSpacing(10),
              primaryButton(
                context,
                () {
                  BlocProvider.of<SettingsCubit>(context).changePassword(
                      context, widget.currentPW, widget.newPW, widget.newRTYP);
                },
                "Change Password",
                double.infinity,
              ),
              verticalSpacing(30),
              contentHeader("Log Out"),
              verticalSpacing(10),
              const Text(
                "Are you sure you want to log out? You will have to re-sign in to access your data.",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
              verticalSpacing(10),
              primaryButton(
                context,
                () {
                  BlocProvider.of<SettingsCubit>(context).logOut(context);
                },
                "Log Out",
                double.infinity,
              ),
              verticalSpacing(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordFieldWrapper(
      String labelText, TextEditingController controller, onChange) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.raleway(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          verticalSpacing(10),
          PasswordField(fieldController: controller, onChange: onChange),
        ],
      ),
    );
  }

  bool _formSubmission() {
    if (_formKey.currentState == null) {
      return false;
    }
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Widget contentHeader(String headerText) {
    return Text(
      headerText,
      style: GoogleFonts.readexPro(
        fontWeight: FontWeight.w500,
        color: Palette.primaryRed,
        fontSize: 20.0,
      ),
    );
  }

  Widget setItemLowCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Item low count",
          style: GoogleFonts.raleway(
            color: UserModel.instance.settings.notify
                ? Colors.black
                : Palette.lightGrey,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: TextFormField(
            onChanged: (v) {
              BlocProvider.of<SettingsCubit>(context)
                  .setNotifThreshold(context, int.parse(v));
            },
            style: const TextStyle(color: Palette.lightRed),
            decoration: const InputDecoration(
              errorStyle: TextStyle(color: Palette.primaryRed),
            ),
            controller: itemLowCountController,
            enabled: UserModel.instance.settings.notify,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget toggleNotificationSwitch() {
    return Switch(
      value: UserModel.instance.settings.notify,
      onChanged: (value) => setState(() {
        BlocProvider.of<SettingsCubit>(context)
            .toggleNotfication(context, value);
      }),
      activeColor: Palette.primaryRed,
    );
  }
}
