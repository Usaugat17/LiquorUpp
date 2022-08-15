import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/widgets.dart';

const hrDividerRed = Divider(
  color: Palette.primaryRed,
  thickness: 1.0,
);

const hrDividerWhite = Divider(
  color: Colors.white,
  thickness: 1.0,
);

Widget imageContainer(String imageURL, double imgWidth, double imgHeight) {
  return Container(
    constraints: BoxConstraints.expand(width: imgWidth, height: imgHeight),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageURL),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget pageHeader(BuildContext context, String headerText) {
  return Text(
    headerText,
    style: GoogleFonts.readexPro(
      fontSize: 40,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget verticalSpacing(double spacing) {
  return SizedBox(
    height: spacing,
  );
}

Widget horizontalSpacing(double spacing) {
  return SizedBox(
    width: spacing,
  );
}

Widget primaryButton(
  BuildContext context,
  Function onPress,
  String buttonName,
  double width,
) {
  return Container(
    decoration: BoxDecoration(
      color: Palette.accentedRed,
      borderRadius: BorderRadius.circular(5),
    ),
    child: SizedBox(
      width: width,
      height: 40,
      child: TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          buttonName,
          style: GoogleFonts.raleway(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

Widget mainAppBar(BuildContext context, String navbarText) {
  double sHeight = MediaQuery.of(context).size.height;
  double sWidth = MediaQuery.of(context).size.width;

  return AppBar(
    title: Text(
      navbarText,
      style: GoogleFonts.readexPro(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    ),
    flexibleSpace: Image(
      image: const AssetImage('assets/images/app-bar-banner.png'),
      fit: BoxFit.cover,
      height: sHeight * 0.09,
      width: sWidth,
    ),
    backgroundColor: Colors.transparent,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRouter.settingsRoute);
          },
          child: const Icon(
            Icons.settings,
            size: 20.0,
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}

AppBar appBarNoSettings(BuildContext context, String navbarText) {
  return AppBar(
    title: Text(
      navbarText,
      style: GoogleFonts.readexPro(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    ),
    flexibleSpace: const Image(
      image: AssetImage('assets/images/app-bar-banner.png'),
      fit: BoxFit.cover,
    ),
    backgroundColor: Colors.transparent,
  );
}

class PasswordField extends StatefulWidget {
  final TextEditingController fieldController;
  final onChange;

  const PasswordField(
      {Key? key, required this.fieldController, required this.onChange})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      }
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) => widget.onChange(v),
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscured,
      focusNode: textFieldFocusNode,
      controller: widget.fieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Palette.accentedRed),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Palette.accentedRed),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.black),
        ),
        errorStyle: const TextStyle(color: Palette.accentedRed),
        contentPadding: const EdgeInsets.fromLTRB(12, 2, 0, 2),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true, // Reduces height a bit
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
              color: Palette.accentedRed,
            ),
          ),
        ),
      ),
    );
  }
}
