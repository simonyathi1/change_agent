import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  String _id;
  String _title;
  String _submittedMaterial;
  String _userID;
  String _activityID;
  String _activityDescription;
  String _challengeID;
  String _startTime;
  String _finishTime;
  String _submissionStatus;
  int _points;
  int _timeAllocationPoints;
  int _timeAllocation;

  Submission(
      this._title,
      this._submittedMaterial,
      this._userID,
      this._activityID,
      this._challengeID,
      this._startTime,
      this._finishTime,
      this._submissionStatus,
      this._activityDescription,
      this._points,
      this._timeAllocationPoints,
      this._timeAllocation);

  Submission.withID(
      this._id,
      this._title,
      this._submittedMaterial,
      this._userID,
      this._activityID,
      this._challengeID,
      this._startTime,
      this._finishTime,
      this._submissionStatus,
      this._activityDescription,
      this._points,
      this._timeAllocationPoints,
      this._timeAllocation);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map["id"] = _id;
    }

    map["title"] = _title;
    map["submitted_material"] = _submittedMaterial;
    map["user_id"] = _userID;
    map["activity_id"] = _activityID;
    map["challenge_id"] = _challengeID;
    map["start_time"] = _startTime;
    map["finish_time"] = _finishTime;
    map["submission_status"] = _submissionStatus;
    map["activity_description"] = _activityDescription;
    map["points"] = _points;
    map["time_allocation_points"] = _timeAllocationPoints;
    map["time_allocation"] = _timeAllocation;

    return map;
  }

  Submission.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._submittedMaterial = map["submitted_material"];
    this._userID = map["user_id"];
    this._activityID = map["activity_id"];
    this._challengeID = map["challenge_id"];
    this._startTime = map["start_time"];
    this._finishTime = map["finish_time"];
    this._submissionStatus = map["submission_status"];
    this._activityDescription = map["activity_description"];
    this._points = map["points"];
    this._timeAllocationPoints = map["time_allocation_points"];
    this._timeAllocation = map["time_allocation"];
  }

  Submission.fromSnapshot(DocumentSnapshot snapShot)
      : this._id = snapShot["id"],
        this._title = snapShot["title"],
        this._submittedMaterial = snapShot["submitted_material"],
        this._userID = snapShot["user_id"],
        this._activityID = snapShot["activity_id"],
        this._challengeID = snapShot["challenge_id"],
        this._startTime = snapShot["start_time"],
        this._finishTime = snapShot["finish_time"],
        this._submissionStatus = snapShot["submission_status"],
        this._activityDescription = snapShot["activity_description"],
        this._timeAllocationPoints = snapShot["time_allocation_points"],
        this._timeAllocation = snapShot["time_allocation"],
        this._points = snapShot["points"];

  String get id => _id;

  String get title => _title;

  String get submittedMaterial => _submittedMaterial;

  String get userID => _userID;

  String get activityID => _activityID;

  String get challengeID => _challengeID;

  String get startTime => _startTime;

  String get finishTime => _finishTime;

  int get points => _points;

  int get timeAllocationPoints => _timeAllocationPoints;

  String get submissionStatus => _submissionStatus;

  String get activityDescription => _activityDescription;

  int get timeAllocation => _timeAllocation;

  set timeAllocation(int value) {
    _timeAllocation = value;
  }

  set activityDescription(String value) {
    _activityDescription = value;
  }

  set points(int value) {
    _points = value;
  }

  set finishTime(String value) {
    _finishTime = value;
  }

  set startTime(String value) {
    _startTime = value;
  }

  set challengeID(String value) {
    _challengeID = value;
  }

  set activityID(String value) {
    _activityID = value;
  }

  set userID(String value) {
    _userID = value;
  }

  set submittedMaterial(String value) {
    _submittedMaterial = value;
  }

  set title(String value) {
    _title = value;
  }

  set timeAllocationPoints(int value) {
    _timeAllocationPoints = value;
  }

  set submissionStatus(String value) {
    _submissionStatus = value;
  }
}
