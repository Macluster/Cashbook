import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;

  final ref = FirebaseDatabase.instance.ref().child("Users");

  Future SignUp(String username, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: username, password: password);
      sleep(Duration(seconds: 2));
      ref.child(auth.currentUser!.email.toString().replaceAll('.', '!')).set({
        "Balance": {"Credit": "0", "Debit": "0"},
        "userImage": ""
      });

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("Colab", auth.currentUser!.email.toString());

      return null;
    } on FirebaseException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future Login(String username, String password) async {
    try {
      auth.signInWithEmailAndPassword(email: username, password: password);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("Colab", auth.currentUser!.email.toString());

      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future Signout() async {
    await auth.signOut();
  }

  User? userg;
  googleSignUp() async {
    final GoogleSignIn googlesignin = GoogleSignIn();
    final GoogleSignInAccount? account = await googlesignin.signIn();

    if (account != null) {
      final GoogleSignInAuthentication googlesigninAuthemntication =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googlesigninAuthemntication.accessToken,
          idToken: googlesigninAuthemntication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        userg = userCredential.user;

        DataSnapshot snap = await ref
            .child(auth.currentUser!.email.toString().replaceAll('.', '!'))
            .get();
        //Works only if the user dont have existing account. inorder to avoid ovverwrite
        if (snap.value == null) {
          ref
              .child(auth.currentUser!.email.toString().replaceAll('.', '!'))
              .set({
            "Balance": {"Credit": "0", "Debit": "0"},
            "LinkedAccounts": {
              "me": {
                "email": auth.currentUser!.email.toString(),
                "Image": auth.currentUser!.photoURL.toString()
              }
            },
          });
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("Colab", auth.currentUser!.email.toString());
      } on FirebaseAuthException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    }
  }
}
