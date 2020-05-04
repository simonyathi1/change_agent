import 'dart:io';

import 'package:change_agent/utils/functions_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:change_agent/database/i_user_view.dart';
import 'package:change_agent/models/user.dart';

import 'package:change_agent/reources/strings_resource.dart';

import 'database_helper.dart';

class UserDataPresenter {
  IUserView _iUserView;
  User _user;
  List _userList = List<User>();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final Firestore databaseReference = Firestore.instance;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  UserDataPresenter(IUserView iUserView) {
    this._iUserView = iUserView;
  }

  void setUser(User user) {
    _user = user;
    _getUserFromFireBase();
  }

  void _saveUser() async {
    int result;
    //todo change this implementation as it will save each time
    if (_user.currentActivityID == null) {
      initializeUser();
      saveUserToFireBase();
      result = await databaseHelper.insertUser(_user);
      //_saveDeviceToken();
    } else {
      return;
    }

    if (result != 0) {
      // success
      _iUserView.showSuccessMessage(_user.name + " saved");
    } else {
      //failure
      _iUserView.showSuccessMessage(_user.name + "not saved");
    }
  }

  void _saveSpecifiedUser(User user) async {
    int result;

    result = await databaseHelper.insertUser(user);

    if (result != 0) {
      // success
      _iUserView.showSuccessMessage(_user.name + " saved");
    } else {
      //failure
      _iUserView.showSuccessMessage(_user.name + "not saved");
    }
  }

  void updateUser() async {
    int result;
    if (_user.id != null) {
      //create
      updateUserInFireBase();
      result = await databaseHelper.updateUser(_user);
    }

    if (result != 0) {
      // success
      _iUserView.showSuccessMessage(_user.name + " saved");
    } else {
      //failure
      _iUserView.showSuccessMessage(_user.name + "not saved");
    }
  }

  void _retrieveUser() {
    debugPrint("=-=-=-=-=-=" + _userList.length.toString());

    if (_userList.length == 0) {
      _userList = List<User>();
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<User>> userListFuture = databaseHelper.getUserList();
        userListFuture.then((userList) {
          if (userList.isNotEmpty) {
            debugPrint("=-=-=-=-=-=" + userList[0].userEmail);
            _userList = userList;
            setDataBaseUser();
          }
        });
      });
    }
  }

  void initializeUser() {
    _user.currentActivityID = "none";
    _user.currentActivity = "none";
    _user.currentActivityStatus = "none";
    _user.currentLevel = FunctionsUtil.getCurrentRank("1");
    _user.currentChallengeID = "1";
    _user.points = 0;
    _user.activitiesDone = "-";
    _user.currentActivityStartTime = "";
    _user.currentActivitySubmissionTime = "";
    _user.challengeStatus =
    "unlocked*locked*locked*locked*locked*locked*locked*locked*locked";
  }

  void setDataBaseUser() {
    _userList.forEach((user) {
      if (user.id == _user.id) {
        _iUserView.setUser(user);
      }
    });
  }

  void saveUserToFireBase() async {
    await databaseReference.collection("users").document(_user.id).setData({
      'id': _user.id,
      'name': _user.name,
      'current_level': _user.currentLevel,
      'current_activity_id': _user.currentActivityID,
      'current_activity': _user.currentActivity,
      'current_activity_status': _user.currentActivityStatus,
      'photo_url': _user.photoUrl,
      'current_challenge_id': _user.currentChallengeID,
      'current_activity_start_time': _user.currentActivityStartTime,
      'current_activity_submission_time': _user.currentActivitySubmissionTime,
      'points': _user.points,
      'user_email': _user.userEmail,
      'activities_done': _user.activitiesDone,
      'challenge_status': _user.challengeStatus,
    });

    ///does same thing just with a randomized ID
//    DocumentReference ref = await databaseReference.collection("books")
//        .add({
//      'title': 'Flutter in Action',
//      'description': 'Complete Programming Guide to learn Flutter'
//    });
//    print(ref.documentID);
  }

  void _getUserFromFireBase() {
    databaseReference
        .collection('users')
        .document(_user.id)
        .get()
        .then((DocumentSnapshot ds) {
      _userUpdated(ds);
    });
  }

  void updateUserInFireBase() {
    try {
      databaseReference.collection('users').document(_user.id).updateData({
        'current_level': _user.currentLevel,
        'current_activity_id': _user.currentActivityID,
        'current_activity': _user.currentActivity,
        'current_activity_status': _user.currentActivityStatus,
        'current_challenge_id': _user.currentChallengeID,
        'points': _user.points,
        'user_email': _user.userEmail,
        'activities_done': _user.activitiesDone,
        'challenge_status': _user.challengeStatus,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _userUpdated(DocumentSnapshot snapShot) {
    try {
      if (snapShot != null && snapShot["id"] != null) {
        updateUserFromFireBase(User.fromSnapshot(snapShot));
      }
    } on NoSuchMethodError catch (e) {
      _saveUser();
      _iUserView.setUser(_user);
    }
  }

  void updateUserFromFireBase(User user) async {
    int result;
    if (_user.id != null) {
      result = await databaseHelper.updateUser(user);
    }

    if (result != 0) {
      // success
      _retrieveUser();
    } else {
      _saveSpecifiedUser(user);
      if (user.id == _user.id) {
        _iUserView.setUser(user);
      }
    }
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = databaseReference
          .collection('users')
          .document(_user.id)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
