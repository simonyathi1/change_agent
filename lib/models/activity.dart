import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String _id;
  String _name;
  String _submissionType;
  String _description;
  String _summary;
  String _submissionInstruction;
  int _points;
  int _timeAllocationPoints;
  int _hourAllocation;

  Activity(
      this._name,
      this._submissionType,
      this._description,
      this._summary,
      this._submissionInstruction,
      this._points,
      this._timeAllocationPoints,
      this._hourAllocation);

  Activity.withID(
      this._id,
      this._name,
      this._submissionType,
      this._description,
      this._summary,
      this._submissionInstruction,
      this._points,
      this._timeAllocationPoints,
      this._hourAllocation);

  String get summary => _summary;

  String get description => _description;

  String get submissionType => _submissionType;

  String get name => _name;

  String get id => _id;

  int get points => _points;

  int get timeAllocationPoints => _timeAllocationPoints;

  int get hourAllocation => _hourAllocation;

  String get activitySubmissionInstruction => _submissionInstruction;

  set summary(String value) {
    _summary = value;
  }

  set description(String value) {
    _description = value;
  }

  set submissionType(String value) {
    _submissionType = value;
  }

  set name(String value) {
    _name = value;
  }

  set hourAllocation(int value) {
    _hourAllocation = value;
  }

  set timeAllocationPoints(int value) {
    _timeAllocationPoints = value;
  }

  set points(int value) {
    _points = value;
  }

  set activitySubmissionInstruction(String value) {
    _submissionInstruction = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map["id"] = _id;
    }

    map["name"] = _name;
    map["submission_type"] = _submissionType;
    map["description"] = _description;
    map["summary"] = _summary;
    map["submission_instruction"] = _submissionInstruction;
    map["points"] = _points;
    map["time_allocation_points"] = _timeAllocationPoints;
    map["hour_allocation"] = _hourAllocation;

    return map;
  }

  Activity.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map["name"];
    this._submissionType = map["submission_type"];
    this._description = map["description"];
    this._summary = map["summary"];
    this._submissionInstruction =
        map["submission_instruction"];
    this._points = map["points"];
    this._timeAllocationPoints = map["time_allocation_points"];
    this._hourAllocation = map["hour_allocation"];
  }

  Activity.fromSnapshot(DocumentSnapshot snapShot)
      : this._id = snapShot["id"],
        this._name = snapShot["name"],
        this._submissionType = snapShot["submission_type"],
        this._description = snapShot["description"],
        this._summary = snapShot["summary"],
        this._submissionInstruction =
            snapShot["submission_instruction"],
        this._points = snapShot["points"],
        this._timeAllocationPoints = snapShot["time_allocation_points"],
        this._hourAllocation = snapShot["hour_allocation"];
}
