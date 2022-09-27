import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jeweller_stockbook/Home/home.dart';
import 'package:jeweller_stockbook/Signin/welcomeUI.dart';
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

  //--------------------------------------->
  ///  SIGN UP USER

  Future<String> registerWithEmailandPassword(
    BuildContext context,
    String email,
    String password,
    String name,
  ) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        ///  REGISTER THE USER
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final username = email.split('@').first;

        Map<String, dynamic> userInfoMap = {
          'uid': cred.user!.uid,
          'email': email,
          'imgUrl': '',
          'name': name,
          'username': username,
        };

        final SharedPreferences prefs = await _prefs;

        prefs.setString('USERKEY', cred.user!.uid);
        prefs.setString('USERDISPLAYNAMEKEY', name);
        prefs.setString('USERNAMEKEY', username);
        prefs.setString('USEREMAILKEY', email);
        prefs.setString('USERPROFILEKEY', '');

        // print('UID from preference -----> ' +
        //     prefs.getString('USERKEY').toString());

        UserData.uid = cred.user!.uid;
        UserData.email = email;
        UserData.userDisplayName = name;
        UserData.username = username;
        UserData.profileUrl = '';

        ///   ADD USER TO DATABASE
        await _dbMethods
            .addUserInfoToDB(cred.user!.uid, userInfoMap)
            .then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });

        res = 'success';

        ///////////////////////////////////////////////////
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted';
      }
      if (e.code == 'email-already-in-use') {
        res = 'This email is already in use';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //  LOGGING IN USER
  Future<String> emailLogInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        final cred = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .get()
            .then((value) async {
          UserData.uid = cred.user!.uid;
          UserData.email = value.data()!['email'];
          UserData.userDisplayName = value.data()!['name'];
          UserData.username = value.data()!['username'];
          UserData.profileUrl = '';

          final SharedPreferences prefs = await _prefs;

          prefs.setString('USERKEY', cred.user!.uid);
          prefs.setString('USERDISPLAYNAMEKEY', value.data()!['name']);
          prefs.setString('USERNAMEKEY', value.data()!['username']);
          prefs.setString('USEREMAILKEY', value.data()!['email']);
          prefs.setString('USERPROFILEKEY', '');
        });

        res = 'Success';

        //----------------------------->
      } else {
        res = 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (err) {
      print(err);
      if (err.code == 'invalid-email') {
        res = 'Invalid Email Format';
      } else if (err.code == 'user-not-found') {
        res = 'User not found';
      } else if (err.code == 'wrong-password') {
        res = 'Invalid Password';
      } else if (err.code == 'user-disabled') {
        res = 'User Disabled';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //------------------------------------------>
  signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginUI()));
  }
}
