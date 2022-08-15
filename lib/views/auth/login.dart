import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/auth/auth_cubit.dart';
import 'package:liquor_inventory/cubits/auth/auth_state.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';
import 'auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String id = "";
  String password = "";
  String confirmPassword = "";
  String name = "";
  String email = "";

  final _formKey = GlobalKey<FormState>();
  final bool passwordVisible = false;

  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  TextEditingController confirmPasswordFieldController =
      TextEditingController();

  // handle login submission here
  bool formSubmission() {
    if (_formKey.currentState == null) {
      return false;
    }
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoginPage) {
          return buildLogIn(context, this);
        } else if (state is AuthStateSignUpPage) {
          return buildSignUp(context, this);
        }
        return buildLogIn(context, this);
      },
      listener: (context, stae) {},
    ));
  }
}

Widget forgotPassword() {
  return TextButton(
    onPressed: () {},
    child: Text(
      "Forgot Password?",
      textAlign: TextAlign.center,
      style: GoogleFonts.raleway(
        color: Palette.primaryRed,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildLogIn(BuildContext context, widget) {
  // FirebaseUtils.handleCredSignIn("water@water.com", "ramu1234", () {});

  BlocProvider.of<AuthCubit>(context).checkAuthState(context);
  return ListView(
    children: [
      const PageHeader(pageTitle: "LOGIN"),
      verticalSpacing(30.0),
      Form(
        key: widget._formKey,
        child: Column(
          children: [
            emailFormField(widget),
            passwordFormField(widget, "Password"),
            verticalSpacing(10),
            primaryButton(context, () {
              BlocProvider.of<AuthCubit>(context).loginCred(context, widget);
            }, "Log In", MediaQuery.of(context).size.width * 0.95),
          ],
        ),
      ),
      verticalSpacing(10),
      googleAuth(context, widget),
      forgotPassword(),
      toggleAuthLink(context, () {
        BlocProvider.of<AuthCubit>(context).pageSignUp(context);
      }, "Do not have an account?", "Sign Up"),
      verticalSpacing(30.0),
    ],
  );
}

Widget buildSignUp(BuildContext context, widget) {
  return ListView(children: [
    const PageHeader(pageTitle: "SIGN UP"),
    verticalSpacing(20),
    Form(
      key: widget._formKey,
      child: Column(
        children: [
          emailFormField(widget),
          passwordFormField(widget, "Password"),
          passwordFormField(widget, "Confirm Password", confirm: true),
          verticalSpacing(10),
          primaryButton(context, () {
            BlocProvider.of<AuthCubit>(context).signUpCred(context, widget);
          }, "Sign Up", MediaQuery.of(context).size.width * 0.95),
        ],
      ),
    ),
    verticalSpacing(10),
    googleAuth(context, widget),
    toggleAuthLink(context, () {
      BlocProvider.of<AuthCubit>(context).pageLogin(context);
    }, "Already have an account?", "Log In"),
    verticalSpacing(20),
  ]);
}
