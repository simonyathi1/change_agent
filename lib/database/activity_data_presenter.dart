import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:change_agent/database/i_activity_view.dart';
import 'package:change_agent/models/activity.dart';

import 'database_helper.dart';

class ActivityDataPresenter {
  IActivityView _iActivityView;
  Activity _activity;
  List<Activity> _activityList = List<Activity>();
  List<String> _challengeActivityIDs = List<String>();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final databaseReference = Firestore.instance;

  ActivityDataPresenter(this._iActivityView, this._challengeActivityIDs);

  void saveActivities(List<Activity> activities) async {
    int result;
    for (int i = 0; i < activities.length; i++) {
      //create
      debugPrint("=-=-=-=-=-=888888888888 " + activities[i].name);
      result = await databaseHelper.insertActivity(activities[i]);

      if (result == 0) {
        //failure
        _iActivityView.showFailureMessage("not saved");
      }
    }
    setViewActivitiesList();
  }

  void updateActivity(Activity activity) async {
    int result;
    if (activity.id != null) {
      //update
      result = await databaseHelper.updateActivity(activity);
    }

    if (result != 0) {
      // success
      _iActivityView.showSuccessMessage("Activity saved");
    } else {
      //failure
      _iActivityView.showFailureMessage("Activity not saved");
    }
  }

  void retrieveActivities() {
    debugPrint("=-=-=-=-=-=************ sqflite "+_challengeActivityIDs[0]);
    debugPrint("=-=-=-=-=-=************ sqflite "+_challengeActivityIDs.length.toString());
    if (_activityList.length == 0) {
      _activityList = List<Activity>();
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<Activity>> activityListFuture =
            databaseHelper.getActivityList();
        activityListFuture.then((activityList) {
          if (activityList.isNotEmpty) {
            _activityList = activityList;
            setViewActivitiesList();
            debugPrint("=-=-=-=-=8888 sqflite "+activityList.length.toString());
          } else {
            getActivitiesFromFireBase();
            debugPrint("=-=-=-=-888 firebase");
          }
        });
      });
    }
  }

  void setViewActivitiesList() {
    List<String> ids = List();
    List<Activity> challengeActivities = List();
    _activityList.forEach((activity) {
      ids.add(activity.id);
    });

    _challengeActivityIDs.forEach((challengeActivityID){
      challengeActivities.add(_activityList[ids.indexOf(challengeActivityID)]);
    });

    _iActivityView.setActivities(challengeActivities);
  }

  void getActivitiesFromFireBase() {
    databaseReference
        .collection('activities')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((f) => _activityList.add(Activity.fromMapObject(f.data)));
      saveActivities(_activityList);
      setViewActivitiesList();
    });
  }

  void updateActivitiesFromFireBase(Activity activity) async {
    int result;
    if (activity.id != null) {
      result = await databaseHelper.updateActivity(activity);
    }

    if (result != 0) {
      // success
      retrieveActivities();
    }
  }
}
