import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jeweller_billbook/Home/home.dart';
import 'package:jeweller_billbook/Signin/loginUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'user.dart';

//creating an instance of Firebase Authentication
class AuthMethods {
  DatabaseMethods _dbMethods = new DatabaseMethods();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentuser() async {
    return await auth.currentUser;
  }

  Future<String> signInWithgoogle(context) async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication!.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);

      User? googleUserData = result.user;

      final SharedPreferences prefs = await _prefs;

      prefs.setString('USERKEY', googleUserData!.uid);
      prefs.setString('USERNAMEKEY', googleUserData.email!.split('@').first);
      prefs.setString('USERDISPLAYNAMEKEY', googleUserData.displayName!);
      prefs.setString('USEREMAILKEY', googleUserData.email!);
      prefs.setString('USERPROFILEKEY', googleUserData.photoURL!);

      UserData.email = googleUserData.email!;
      UserData.userDisplayName = googleUserData.displayName!;
      UserData.username = googleUserData.email!.split('@').first;
      UserData.uid = googleUserData.uid;
      UserData.profileUrl = googleUserData.photoURL!;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUserData.uid)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            // UserData.userDisplayName = value.data()!['name'];
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Map<String, dynamic> userInfoMap = {
              'uid': googleUserData.uid,
              "email": googleUserData.email,
              "username": googleUserData.email!.split('@').first,
              "name": googleUserData.displayName,
              "imgUrl": googleUserData.photoURL,
            };
            await _dbMethods
                .addUserInfoToDB(googleUserData.uid, userInfoMap)
                .then((value) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            });
          }
        },
      );
      return 'success';
    } catch (e) {
      print(e);
      return 'fail';
    }
  }

  signOut(BuildContext context) async {
    print('object');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginUI()));
  }
}
