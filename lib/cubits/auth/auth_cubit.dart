import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/auth/auth_state.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateLoginPage());

  void checkAuthState(BuildContext context) {
    if (FirebaseUtils.authState()) {
      Future.delayed(const Duration(milliseconds: 10), () {
        Navigator.popAndPushNamed(context, AppRouter.rootRoute);
      });
    }
  }

//pages
  void pageSignUp(BuildContext context) {
    emit(AuthStateSignUpPage());
  }

  void pageLogin(BuildContext context) {
    emit(AuthStateLoginPage());
  }

  void pageForgetPassword() {
    emit(AuthStateForgetPasswordPage());
  }

//singup
  void signUpGoogle(BuildContext context, widget) {}
  void signUpCred(BuildContext context, widget) {
    FirebaseUtils.handleCredRegistration(widget.email, widget.password, () {
      Navigator.popAndPushNamed(context, AppRouter.rootRoute);
    });
  }

//login
  void loginGoogle(BuildContext context, widget) {
    FirebaseUtils.handleGoogleSignIn(() {
      Navigator.popAndPushNamed(context, AppRouter.rootRoute);
    });
  }

  void loginCred(BuildContext context, widget) {
    FirebaseUtils.handleCredSignIn(widget.email, widget.password, () {
      Navigator.popAndPushNamed(context, AppRouter.rootRoute);
    });
  }

// reset password
  void forgetPassword() {}

// logout
  void logout(BuildContext context) {
    FirebaseUtils.handleLogOut(context, () {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.loginRoute, (route) => false);
    });
  }
}
