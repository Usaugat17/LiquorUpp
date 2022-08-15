import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/auth/auth_cubit.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';
import 'package:liquor_inventory/views/auth/login.dart';

Widget emailFormField(widget) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: TextFormField(
      onChanged: (value) {
        widget.email = value;
      },
      style: const TextStyle(color: Palette.lightRed),
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Palette.primaryRed),
        hintText: "Email",
        icon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: widget.emailFieldController,
      validator: (String? value) {
        if (value != null) {
          return 'Email is required';
        }
        return '';
      },
    ),
  );
}

Widget passwordFormField(widget, String hintText, {confirm: false}) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: TextFormField(
      onChanged: (value) {
        if (confirm) {
          widget.confirmPassword = value;
        } else {
          widget.password = value;
        }
      },
      style: const TextStyle(color: Palette.lightRed),
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Palette.primaryRed),
        hintText: hintText,
        icon: const Icon(Icons.key),
      ),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      controller: confirm
          ? widget.confirmPasswordFieldController
          : widget.passwordFieldController,
      validator: (String? value) {
        if (value != null) {
          return 'Password is required';
        }
        return '';
      },
    ),
  );
}

Widget toggleAuthLink(
    BuildContext context, onPressed, String helpText, String linkText) {
  return Column(
    children: [
      Text(
        helpText,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      const SizedBox(
        height: 5.0,
      ),
      TextButton(
        onPressed: () {
          onPressed();
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          linkText,
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            color: Palette.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ],
  );
}

class PageHeader extends StatelessWidget {
  final String pageTitle;

  const PageHeader({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Stack(
        children: [
          backgroundImage(sHeight * 0.35),
          Container(
            alignment: Alignment.center,
            height: sHeight * 0.25,
            child: Text(
              pageTitle,
              style: GoogleFonts.readexPro(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget backgroundImage(double imgHeight) {
  return Container(
    alignment: Alignment.center,
    height: imgHeight,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/login-background.png'),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget googleAuth(BuildContext context, widget) => IconButton(
      onPressed: () {
        BlocProvider.of<AuthCubit>(context).loginGoogle(context, widget);
        FirebaseUtils.handleGoogleSignIn(StatusCallback());
      },
      iconSize: 40.0,
      icon: Image.asset('assets/images/google-logo.png'),
    );
