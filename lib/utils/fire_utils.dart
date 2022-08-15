import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:liquor_inventory/firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';

enum Flag {
  FLAG_LOGGEDIN,
  FLAG_LOGGEDOUT,
  FLAG_WEAK_PASSWORD,
  FLAG_EMAIL_ALREADY_USED
}

class FirebaseUtils {
  static Flag authFlag = Flag.FLAG_LOGGEDOUT;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user = FirebaseAuth.instance.currentUser;
  static bool loggedIn = false;
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    auth = FirebaseAuth.instance;
    storage = FirebaseStorage.instance;
    authState();
  }

/*---------------------------Authentication---------------------------*/
  static bool authState() {
    auth.authStateChanges().listen((User? u) {
      loggedIn = false;
      user = u;
      if (user != null) {
        loggedIn = true;
        updateUser(fromAuth: true);
      }
    });
    return loggedIn;
  }

  static void handlePasswordReset(
      String email, StatusCallback onComplete) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .whenComplete(onComplete.onComplete());
  }

  static void handleDeleteAccount(BuildContext context) async {
    await user?.delete();
  }

  static void handleLogOut(BuildContext context, onComplete) async {
    await auth.signOut().then((value) {
      UserModel.instance.uid=Utils.NOT_AVAILABLE;
      onComplete();
    });
  }

  static void handleGoogleSignIn(onComplete) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
      // email: googleAuth?.email,
    );

    // Once signed in, return the UserCredential
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // updateUser()
    onComplete();

    // updateUser(email:cred.credential.)
    // print(cred.credential!.asMap());
  }

  static void handleCredRegistration(
      String email, String password, onSuccess) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      updateUser(email: email, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.toast("Weak Password");
      } else if (e.code == 'email-already-in-use') {}
      Utils.toast("Email already in use");
    } catch (e) {
      Utils.toast("Error: Occured");
      // print(e);
    }
  }

  static void handleGoogleRegistration(StatusCallback onComplete) {}

  static void handleCredSignIn(
      String email, String password, onComplete) async {
    try {
      Utils.toast("Verifying");
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      updateUser(email: email, password: password);
      Utils.toast("Logged In");

      onComplete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.toast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Utils.toast('Wrong password provided for that user.');
      }
    }
  }

  static void updatePassword(String newPW) async {
    await user?.updatePassword(newPW);
  }

  static void updateUser({email, password, fromAuth = false}) {
    if (!fromAuth) {
      authState();
      UserModel.instance.email = email;
      UserModel.instance.uid = user!.uid;

      UserModel.instance.password = password ?? Utils.NOT_AVAILABLE;
      UserModel.instance.save();
    } else {
      UserModel.instance.uid = user!.uid;
      UserModel.instance.fetch((v) {
        UserModel.deserialize(v);
      });
    }
  }

  /*---------------------------Data---------------------------*/

/*---------------------------Image---------------------------*/
  static uploadPhoto(String path, StatusCallback callback,
      {ofItem = true}) async {
    Utils.canSaveItem = false;
    final ref = storage.ref().child('images/IMG_${Utils.genCrpytoKey()}.png');
    try {
      await ref.putFile(File(path));
      Utils.canSaveItem = true;
      callback.onSuccess(await ref.getDownloadURL());
    } on FirebaseException catch (e) {
      // print(e);
      callback.onFailure(e.message);
    }
  }
/*------------------------------------------------------*/
}

class StatusCallback {
  final onFailure;
  final onSuccess;
  final onComplete;
  StatusCallback({this.onFailure, this.onSuccess, this.onComplete});
}
