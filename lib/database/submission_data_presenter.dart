import 'package:change_agent/database/i_submission_view.dart';
import 'package:change_agent/database/notifications/wfto_notification.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/utils/functions_util.dart';
import 'package:change_agent/utils/strings_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_helper.dart';
import 'i_admin_submission_view.dart';
import 'i_submission_view.dart';

class SubmissionDataPresenter {
  ISubmissionView _iSubmissionView;
  IAdminSubmissionView _iAdminSubmissionView;
  Submission _submission;
  List _submissionList = List<Submission>();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final databaseReference = Firestore.instance;
  Challenge _challenge;
  Activity _activity;
  User _user;

  SubmissionDataPresenter(ISubmissionView iSubmissionView, Challenge challenge,
      Activity activity, User user) {
    this._iSubmissionView = iSubmissionView;
    this._challenge = challenge;
    this._activity = activity;
    this._user = user;

    _updateUserSelectedActivity();
  }

  SubmissionDataPresenter.admin(this._iAdminSubmissionView);

  SubmissionDataPresenter.adminAudit(
      this._iAdminSubmissionView, this._submission);

  void _updateUserSelectedActivity() {
    if (_user.currentActivityID != _activity.id &&
        !_user.activitiesDone.contains(_activity.id)) {
      _user.currentActivityID = _activity.id;
      _user.currentActivity = _activity.name;
      _user.currentActivityStatus = "started";
      _user.challengeStatus = _setStatus("pending");
      _user.currentChallengeID = _challenge.id;
      _user.currentActivityStartTime = getCurrentTime();
      _saveSpecifiedUser(_user);
      updateUserInFireBase();
    }
  }

  String getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void setSubmission(Submission submission) {
    _submission = submission;
    _submission.finishTime = getCurrentTime();
    saveSubmissionToFireBase();

    _user.currentActivityID = _activity.id;
    _user.currentActivity = _activity.name;
    _user.currentActivityStatus = "pending";
    _user.challengeStatus = _setStatus("pending");
    _user.currentChallengeID = _challenge.id;

    _saveSpecifiedUser(_user);
    updateUserInFireBase();
    _sendNotificationToAdmin();
    _iSubmissionView.setUser(_user);
  }

  Future _sendNotificationToAdmin() async {
    final response = await WFTONotification.sendToTopic(
      title: "New Submission",
      body:
          "${_user.name} has submitted the submission for ${_activity.name} for review",
      topic: "submissions",
    );
//
//    if (response.statusCode != 200) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content:
//        Text('[${response.statusCode}] Error message: ${response.body}'),
//      ));
//    }
  }

  Future _sendNotificationToUser(String title, String message) async {
    final response = await WFTONotification.sendToTopic(
      title: title,
      body: message,
      topic: _user.id,
    );
//
//    if (response.statusCode != 200) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content:
//        Text('[${response.statusCode}] Error message: ${response.body}'),
//      ));
//    }
  }

  void rejectSubmission() {
    _submission.submissionStatus = "rejected";
    saveSubmissionToFireBase();
    _sendNotificationToUser("Submission Rejected",
        "${_user.currentActivity} submission has been Rejected");

    _user.currentActivityStatus = "rejected";
    _user.challengeStatus = _setStatus("rejected");

    updateUserInFireBase();
    _iAdminSubmissionView.setSubmission(_submission);
  }

  void approveSubmission() {
    _submission.submissionStatus = "approved";
    saveSubmissionToFireBase();
    _sendNotificationToUser("Submission Approved",
        "${_user.currentActivity} submission has been Approved");

    _user.currentActivityID = "none";
    _user.currentActivity = "none";
    _user.currentActivityStatus = "none";
    _user.challengeStatus = _setStatus("complete", isApproving: true);
    _user.currentChallengeID =
        _setChallengeIDonSuccess(_submission.challengeID);
    _user.activitiesDone = _user.activitiesDone == "-"
        ? _submission.activityID
        : _user.activitiesDone + "*" + _submission.activityID;
    _user.currentLevel = _setLevel();
    _user.currentActivityStartTime = "";
    _user.currentActivitySubmissionTime = "";
    _user.points += _calculatePoints();

    updateUserInFireBase();
    _iAdminSubmissionView.setSubmission(_submission);
  }

  int _calculatePoints() {
    int points = _submission.points;
    var start = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(_submission.startTime));
    var end = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(_submission.finishTime));

    var diff = end.difference(start);
    if (diff.inMinutes == 0) {
      points += _submission.timeAllocationPoints;
    } else if (diff.inMinutes / 60 < _submission.timeAllocation) {
      points += _submission.timeAllocationPoints;
    }

    return points;
  }

  String _setChallengeIDonSuccess(String currentID) {
    int id = int.parse(currentID);
    if (id <= 9) {
      id++;
    }
    return id.toString();
  }

  String _setLevel() {
    return FunctionsUtil.getCurrentRank(_user.currentChallengeID);
  }

  String _setStatus(String status, {bool isApproving}) {
    var statuses = StringsUtil.getDelimitedList(
      _user.challengeStatus,
    );
    int i = _getIndex();
    statuses[i] = status;

    if (isApproving != null && isApproving && i + 1 < 9) {
      statuses[i + 1] = "unlocked";
    }

    String statusList = "";
    statuses.forEach((status) {
      if (statuses.indexOf(status) != statuses.length - 1) {
        statusList = statusList + status + "*";
      } else {
        statusList = statusList + status;
      }
    });
    return statusList;
  }

  int _getIndex() {
    return int.parse(_user.currentChallengeID) - 1;
  }

  void getUserFromFireBase() {
    databaseReference
        .collection('users')
        .document(_submission.userID)
        .get()
        .then((DocumentSnapshot ds) {
      _userUpdated(ds);
    });
  }

  void _userUpdated(DocumentSnapshot snapShot) {
    try {
      if (snapShot != null && snapShot["id"] != null) {
        _user = (User.fromSnapshot(snapShot));
      }
    } on NoSuchMethodError catch (e) {}
  }

  void _saveSpecifiedUser(User user) async {
    int result;

    result = await databaseHelper.updateUser(user);

    if (result != 0) {
      // success
      _iSubmissionView.showSuccessMessage("Activity selection saved");
    } else {
      //failure
      _iSubmissionView.showSuccessMessage("Activity selection not saved");
    }
  }

  void saveSubmissionToFireBase() async {
    await databaseReference
        .collection("submissions")
        .document(_user.id)
        .setData({
      'title': _submission.title,
      'submitted_material': _submission.submittedMaterial,
      'user_id': _submission.userID,
      'activity_id': _submission.activityID,
      'challenge_id': _submission.challengeID,
      'start_time': _submission.startTime,
      'finish_time': _submission.finishTime,
      'submission_status': _submission.submissionStatus,
      'time_allocation_points': _submission.timeAllocationPoints,
      'time_allocation': _submission.timeAllocation,
      'activity_description': _submission.activityDescription,
      'points': _submission.points,
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
        "current_activity_start_time": _user.currentActivityStartTime,
        "current_activity_submission_time": _user.currentActivitySubmissionTime,
        'activities_done': _user.activitiesDone,
        'challenge_status': _user.challengeStatus,
      });
    } catch (e) {
      print(e.toString());
    }

    if (_user.currentChallengeID == "10") {
      saveUserAsChangeAgent();
    }
  }

  void saveUserAsChangeAgent() {
    try {
      databaseReference
          .collection('changeAgents')
          .document(_user.id)
          .updateData({
        'current_level': _user.currentLevel,
        'current_activity_id': _user.currentActivityID,
        'current_activity': "All Activities Done",
        'points': _user.points,
        'user_email': _user.userEmail,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void getSubmissionsFromFireBase() {
    _submissionList.clear();
    databaseReference
        .collection('submissions')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(
          (f) => _submissionList.add(Submission.fromMapObject(f.data)));
      _iAdminSubmissionView.setSubmissionList(_submissionList);
    });
  }

//  void getSubmissionFromFireBase(User user)  {
//    var submission;
//    databaseReference
//        .collection('submissions')
//        .document(user.id)
//        .get()
//        .then((DocumentSnapshot snapShot) {
//      try {
//        if (snapShot != null && snapShot["submitted_material"] != null) {
//          submission = (Submission.fromSnapshot(snapShot));
//        }
//      } on NoSuchMethodError catch (e) {}
//      _iSubmissionView.setSubmission(submission);
//    });
//  }
}
