import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  String _id;
  String _title;
  String _activityIDs;

  Challenge(this._title, this._activityIDs);

  Challenge.withID(this._id, this._title, this._activityIDs);

  String get activityIDs => _activityIDs;

  String get title => _title;

  String get id => _id;

  set activityIDs(String value) {
    _activityIDs = value;
  }

  set title(String value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map["id"] = _id;
    }

    map["title"] = _title;
    map["activity_ids"] = _activityIDs;

    return map;
  }

  Challenge.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._activityIDs = map["activity_ids"];
  }

  Challenge.fromSnapshot(DocumentSnapshot snapShot)
      : this._id = snapShot["id"],
        this._title = snapShot["title"],
        this._activityIDs = snapShot["activity_ids"];
}
