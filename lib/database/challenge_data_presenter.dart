import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:change_agent/database/i_challenge_view.dart';
import 'package:change_agent/models/challenge.dart';

import 'database_helper.dart';

class ChallengeDataPresenter {
  IChallengeView _iChallengeView;
  Challenge _challenge;
  List _challengeList = List<Challenge>();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final databaseReference = Firestore.instance;

  ChallengeDataPresenter(this._iChallengeView);

  void saveChallenges(List<Challenge> challenges) async {
    int result;
    for (int i = 0; i < challenges.length; i++) {
      //create
      debugPrint("=-=-=-=-=-=888888888888 "+ challenges[i].title);
      result = await databaseHelper.insertChallenge(challenges[i]);

      if (result == 0) {
        //failure
        _iChallengeView.showFailureMessage("not saved");
      }
    }
    setViewChallengesList();
  }

  void updateChallenge(Challenge challenge) async {
    int result;
    if (challenge.id != null) {
      //update
      result = await databaseHelper.updateChallenge(challenge);
    }

    if (result != 0) {
      // success
      _iChallengeView.showSuccessMessage("Challenge saved");
    } else {
      //failure
      _iChallengeView.showFailureMessage("Challenge not saved");
    }
  }

  void retrieveChallenges() {
    if (_challengeList.length == 0) {
      _challengeList = List<Challenge>();
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<Challenge>> challengeListFuture =
            databaseHelper.getChallengeList();
        challengeListFuture.then((challengeList) {
          if (challengeList.isNotEmpty) {
            _challengeList = challengeList;
            setViewChallengesList();
            debugPrint("=-=-=-=-=-=888888888888 sqflite");
          } else {
            getChallengesFromFireBase();
            debugPrint("=-=-=-=-=-=888888888888 firebase");
          }
        });
      });
    }
  }

  void setViewChallengesList() {
    _iChallengeView.setChallenges(_challengeList);
  }

  void getChallengesFromFireBase() {
    databaseReference
        .collection('challenges')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((f) => _challengeList.add(Challenge.fromMapObject(f.data)));
      saveChallenges(_challengeList);
      setViewChallengesList();
    });
  }

  void updateChallengesFromFireBase(Challenge challenge) async {
    int result;
    if (challenge.id != null) {
      result = await databaseHelper.updateChallenge(challenge);
    }

    if (result != 0) {
      // success
      retrieveChallenges();
    }
  }
}
