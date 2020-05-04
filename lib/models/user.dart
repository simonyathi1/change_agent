import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String _name;
  String _currentLevel;
  String _currentActivity;
  String _currentActivityID;
  String _currentChallengeID;
  String _currentActivityStatus;
  String _photoUrl;
  int _points;
  String _userEmail;
  String _activitiesDone;
  String _challengeStatus;
  String _currentActivityStartTime;
  String _currentActivitySubmissionTime;

  User(
      this._name,
      this._currentLevel,
      this._currentActivityID,
      this._currentChallengeID,
      this._currentActivityStatus,
      this._points,
      this._photoUrl);

  User.withID(
      this._id,
      this._name,
      this._currentLevel,
      this._currentActivityID,
      this._currentChallengeID,
      this._currentActivityStatus,
      this._points,
      this._photoUrl);

  User.onSignIn(this._id, this._name, this._userEmail, this._photoUrl);

  String get currentActivity => _currentActivity;

  String get currentLevel => _currentLevel;

  String get name => _name;

  String get id => _id;

  String get currentChallengeID => _currentChallengeID;

  String get currentActivityStatus => _currentActivityStatus;

  String get photoUrl => _photoUrl;

  String get currentActivityID => _currentActivityID;

  String get userEmail => _userEmail;

  int get points => _points;

  String get activitiesDone => _activitiesDone;

  String get challengeStatus => _challengeStatus;

  String get currentActivityStartTime => _currentActivityStartTime;

  String get currentActivitySubmissionTime => _currentActivitySubmissionTime;

  set currentActivitySubmissionTime(String value) {
    _currentActivitySubmissionTime = value;
  }

  set currentActivityStartTime(String value) {
    _currentActivityStartTime = value;
  }

  set currentActivity(String value) {
    _currentActivity = value;
  }

  set currentLevel(String value) {
    _currentLevel = value;
  }

  set name(String value) {
    _name = value;
  }

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set currentActivityStatus(String value) {
    _currentActivityStatus = value;
  }

  set currentChallengeID(String value) {
    _currentChallengeID = value;
  }

  set currentActivityID(String value) {
    _currentActivityID = value;
  }

  set points(int value) {
    _points = value;
  }

  set userEmail(String value) {
    _userEmail = value;
  }

  set activitiesDone(String value) {
    _activitiesDone = value;
  }

  set challengeStatus(String value) {
    _challengeStatus = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map["id"] = _id;
    }

    map["name"] = _name;
    map["current_level"] = _currentLevel;
    map["current_activity_id"] = _currentActivityID;
    map["current_activity"] = _currentActivity;
    map["current_challenge_id"] = _currentChallengeID;
    map["current_activity_status"] = _currentActivityStatus;
    map["photo_url"] = _photoUrl;
    map["points"] = _points;
    map["user_email"] = _userEmail;
    map["activities_done"] = _activitiesDone;
    map["challenge_status"] = _challengeStatus;
    map["current_activity_start_time"] = _currentActivityStartTime;
    map["current_activity_submission_time"] = _currentActivitySubmissionTime;

    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map["name"];
    this._currentLevel = map["current_level"];
    this._currentActivityID = map["current_activity_id"];
    this._currentActivity = map["current_activity"];
    this._currentChallengeID = map["current_challenge_id"];
    this._currentActivityStatus = map["current_activity_status"];
    this._photoUrl = map["photo_url"];
    this._points = map["points"];
    this._userEmail = map["user_email"];
    this._activitiesDone = map["activities_done"];
    this._challengeStatus = map["challenge_status"];
    this._currentActivityStartTime = map["current_activity_start_time"];
    this._currentActivitySubmissionTime =
        map["current_activity_submission_time"];
  }

  User.fromSnapshot(DocumentSnapshot snapShot)
      : this._id = snapShot["id"],
        this._name = snapShot["name"],
        this._currentLevel = snapShot["current_level"],
        this._currentActivityID = snapShot["current_activity_id"],
        this._currentActivity = snapShot["current_activity"],
        this._currentChallengeID = snapShot["current_challenge_id"],
        this._currentActivityStatus = snapShot["current_activity_status"],
        this._photoUrl = snapShot["photo_url"],
        this._points = snapShot["points"],
        this._userEmail = snapShot["user_email"],
        this._activitiesDone = snapShot["activities_done"],
        this._currentActivityStartTime =
            snapShot["current_activity_start_time"],
        this._currentActivitySubmissionTime =
            snapShot["current_activity_submission_time"],
        this._challengeStatus = snapShot["challenge_status"];
}
