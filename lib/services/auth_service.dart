import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_doctors/SignIn_with_phone.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/security.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/views/home.dart';

import 'notifications_old.dart';


class AuthService {
  getUserData() {
    User? user = FirebaseAuth.instance.currentUser;

    return user;
  }

  handleAuth() {

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData)
            return HomeView();
          else
            return LoginPage();
        });

//    return FirebaseAuth.instance.authStateChanges().listen((User userObj) {
//      if (userObj == null) {
//        print("handleAuth() snapshot no data");
//
//        return LoginPage();
//      } else {
//        print("handleAuth() snapshot has data");
//
//        User user = userObj;
//        //Notifications.scheduleNotification();
//        print("Redirecting to home page");
//        return HomeView();
//      }
//    });
  print("handleAuth()");
//    return StreamBuilder(
//        stream: FirebaseAuth.instance.authStateChanges,
//        builder: (BuildContext context, snapshot) {
//
//          if (snapshot.hasData) {
//            print("handleAuth() snapshot has data");
//            Responsiveness.setResponsiveProperties(context);
//            User user = snapshot.data;
//            //Notifications.scheduleNotification();
//            print("Redirecting to home page");
//            return HomeView();
//
//          } else {
//            print("handleAuth() snapshot no data");
//
//            return LoginPage();
//          }
//        });
  }

  static signOut() {

    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async {

    try {
      await FirebaseAuth.instance.signInWithCredential(authCreds);

      Security.registerSession();
      handleAuth();
    }catch(e){
      print(e.toString());
      getIt<SessionData>().loginWelcomeMessage =
      " Error: ${e.toString()}";
      AuthService.signOut();
    }
    //  UserController.registerNotificationToken();
    // send supplier to his screen with phone number as paramenter
  }

  signInWithOTP(phoneNo, smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
//    auth user will be connected to store by phone number, no need for a user record.
//    registerUserToFireStore (phoneNo);

//    Query query = GroceryDataRepository.collection.where((doc) => doc.ownerPhoneNumber ==phoneNo);
//    Stream<QuerySnapshot> querySnapshot = query.snapshots();
//    querySnapshot.firstWhere((StoreOwner doc) => doc.ownerPhoneNumber ==phoneNo).then((value) => null)
//    Future snap = querySnapshot.firstWhere((doc) => doc.ownerPhoneNumber ==phoneNo);
//    for (DocumentSnapshot document in querySnapshot.) {
//    print(document.reference);
//    }
    Global.prefs!.setString("phoneNo", phoneNo);
    signIn(authCreds);
  }

//  registerUserToFireStore(String phoneNo) async {
//    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    final uid = user.uid;
//    UserDataRepository UDR = UserDataRepository();
//    User newUser = User(phoneNumber: phoneNo);
//    UDR.collection.document(user.uid).setData(newUser.toJson());
//  }
}
//import 'package:pinkblue/database_operations/user_operations.dart';
//import 'package:pinkblue/models/user.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//
//class AuthService {
//
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//
//  // create user obj based on firebase user
//  User _userFromFirebaseUser(FirebaseUser user) {
//    return user != null ? User(id: user.uid) : null;
//  }
//
//  // auth change user stream
//  Stream<User> get user {
//    return _auth.onAuthStateChanged
//    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
//        .map(_userFromFirebaseUser);
//  }
//
  // sign in anon
//  Future signInAnon() async {
//    try {
//      AuthResult result = await _auth.signInAnonymously();
//      FirebaseUser user = result.user;
//      return _userFromFirebaseUser(user);
//    } catch (e) {
//      print(e.toString());
//      return null;
//    }
//  }
//
//  // sign in with email and password
//  Future signInWithEmailAndPassword(String email, String password) async {
//      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
//      FirebaseUser user = result.user;
//      return user;
//  }
//
//  // register with email and password
//  Future registerWithEmailAndPassword(String email, String password) async {
//
//      print("creating user $email $password");
//      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//      FirebaseUser user = result.user;
//      print(user.toString());
//      // create a new document for the user with the uid
//      await UserQueries(uid: user.uid.toString()).updateUserData('ysxsn','new crew member', password,'123',email);
//      return _userFromFirebaseUser(user);
//
//  }
//
//  // sign out
//  Future signOut() async {
//    try {
//      return await _auth.signOut();
//    } catch (error) {
//      print(error.toString());
//      return null;
//    }
//  }
//
//}
