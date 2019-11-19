import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = "user_table";
  String challengeTable = "challenge_table";
  String activityTable = "activity_table";
  String submissionTable = "submission_table";

  ///all tables
  String colId = "id";

  ///user table
  String name = "name";
  String currentLevel = "current_level";
  String currentActivityID = "current_activity_id";
  String currentActivity = "current_activity";
  String currentChallengeID = "current_challenge_id";
  String currentActivityStatus = "current_activity_status";
  String photoUrl = "photo_url";
  String totalPoints = "points";
  String userEmail = "user_email";
  String activitiesDone = "activities_done";
  String challengeStatus = "challenge_status";
  String currentActivityStartTime = "current_activity_start_time";
  String currentActivitySubmissionTime = "current_activity_submission_time";

  ///device number table
  String title = "title";
  String activityIDs = "activity_ids";

  ///activity table
  String activityName = "name";
  String submissionType = "submission_type";
  String description = "description";
  String summary = "summary";
  String activitySubmissionInstruction = "submission_instruction";
  String points = "points";
  String timeAllocationPoints = "time_allocation_points";
  String hourAllocation = "hour_allocation";

  ///submissions table
  String submissionTitle = "title";
  String submittedMaterial = "submitted_material";
  String userID = "user_id";
  String activityID = "activity_id";
  String challengeID = "challenge_id";
  String startTime = "start_time";
  String finishTime = "finish_time";
  String submissionStatus = "submission_status";
  String submissionTimeAllocationPoints = "time_allocation_points";
  String submissionTimeAllocation = "time_allocation";
  String activityDescription = "activity_description";
  String submissionPoints = "points";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get directory path to the Android and IOS databases
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'app.db');

    //Open/ create database at given path
    var appDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return appDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $userTable($colId TEXT, $name TEXT,"
        "$currentLevel TEXT,$currentActivityID,$currentActivity TEXT,$currentChallengeID TEXT,$currentActivityStatus TEXT,$photoUrl TEXT, $totalPoints INTEGER,$userEmail TEXT,$activitiesDone TEXT,$currentActivityStartTime TEXT,$currentActivitySubmissionTime TEXT,$challengeStatus TEXT)");

    await db.execute(
        "CREATE TABLE $challengeTable($colId TEXT, $title TEXT, $activityIDs TEXT)");

    await db.execute(
        "CREATE TABLE $activityTable($colId TEXT, $activityName TEXT, $submissionType TEXT,"
        "$description TEXT, $summary TEXT, $activitySubmissionInstruction TEXT,"
        "$points INTEGER, $timeAllocationPoints INTEGER, $hourAllocation INTEGER)");

    await db.execute(
        "CREATE TABLE $submissionTable($colId TEXT, $submissionTitle TEXT, $submittedMaterial TEXT,"
            "$userID TEXT, $activityID TEXT, $challengeID TEXT,$startTime TEXT, $finishTime TEXT,$submissionStatus TEXT,$activityDescription TEXT,"
            "$points INTEGER, $submissionTimeAllocation INTEGER, $submissionTimeAllocationPoints INTEGER)");
  }

  ///*************************************Number table

  //fetch userTable
  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database database = await this.database;
    return await database.query(userTable, orderBy: "$colId ASC");
  }

  //delete user from db
  Future<int> deleteUser(String id) async {
    Database database = await this.database;
    return database.rawDelete("DELETE FROM $userTable WHERE $colId = $id");
  }

  //Insert User to db
  Future<int> insertUser(User user) async {
    Database database = await this.database;
    return await database.insert(userTable, user.toMap());
  }

  //Update User in db
  Future<int> updateUser(User user) async {
    Database database = await this.database;
    return await database.update(userTable, user.toMap(),
        where: "$colId = ?", whereArgs: [user.id]);
  }

  Future<List<User>> getUserList() async {
    var userMapList = await getUserMapList();
    int count = userMapList.length;

    List<User> userList = List<User>();
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMapObject(userMapList[i]));
    }
    return userList;
  }

  ///*************************************Challenge table
//fetch All challenges
  Future<List<Map<String, dynamic>>> getChallengesMapList() async {
    Database database = await this.database;
    return await database.query(challengeTable, orderBy: "$colId ASC");
  }

  //Insert challenge to db
  Future<int> insertChallenge(Challenge challenge) async {
    Database database = await this.database;
    return await database.insert(challengeTable, challenge.toMap());
  }

  //Update challenge in db
  Future<int> updateChallenge(Challenge challenge) async {
    Database database = await this.database;
    return await database.update(challengeTable, challenge.toMap(),
        where: "$colId = ? ", whereArgs: [challenge.id]);
  }

  //delete challenge from db
  Future<int> deleteChallenge(int id, String device) async {
    Database database = await this.database;
    return database.rawDelete(
        "DELETE FROM $challengeTable WHERE $colId = $id AND $device = $device");
  }

//get number of challenge in db
  Future<int> getChallengeCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> challenges =
        await database.rawQuery("SELECT COUNT (*) from $challengeTable");
    return Sqflite.firstIntValue(challenges);
  }

  Future<List<Challenge>> getChallengeList() async {
    var challengeMapList = await getChallengesMapList();
    int count = challengeMapList.length;

    List<Challenge> challengeList = List<Challenge>();
    for (int i = 0; i < count; i++) {
      challengeList.add(Challenge.fromMapObject(challengeMapList[i]));
    }
    return challengeList;
  }

  ///************************************* Activity table
  //fetch All Activities
  Future<List<Map<String, dynamic>>> getActivityMapList() async {
    Database database = await this.database;
    return await database.query(activityTable, orderBy: "$colId ASC");
  }

  //Insert activity to db
  Future<int> insertActivity(Activity activity) async {
    Database database = await this.database;
    return await database.insert(activityTable, activity.toMap());
  }

  //Update activity in db
  Future<int> updateActivity(Activity activity) async {
    Database database = await this.database;
    return await database.update(activityTable, activity.toMap(),
        where: "$colId = ? ", whereArgs: [activity.id]);
  }

//get number of activities in db
  Future<int> getActivityCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> activities =
        await database.rawQuery("SELECT COUNT (*) from $activityTable");
    return Sqflite.firstIntValue(activities);
  }

  Future<List<Activity>> getActivityList() async {
    var activityMapList = await getActivityMapList();
    int count = activityMapList.length;

    List<Activity> activityList = List<Activity>();
    for (int i = 0; i < count; i++) {
      activityList.add(Activity.fromMapObject(activityMapList[i]));
    }
    return activityList;
  }

  ///************************************* Activity table
  //fetch All Submissions
  Future<List<Map<String, dynamic>>> getSubmissionMapList() async {
    Database database = await this.database;
    return await database.query(submissionTable, orderBy: "$colId ASC");
  }

  //Insert activity to db
  Future<int> insertSubmission(Submission submission) async {
    Database database = await this.database;
    return await database.insert(submissionTable, submission.toMap());
  }

  //Update activity in db
  Future<int> updateSubmission(Submission submission) async {
    Database database = await this.database;
    return await database.update(submissionTable, submission.toMap(),
        where: "$colId = ? ", whereArgs: [submission.id]);
  }

//get number of activities in db
  Future<int> getSubmissionCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> submissions =
        await database.rawQuery("SELECT COUNT (*) from $submissionTable");
    return Sqflite.firstIntValue(submissions);
  }

  Future<List<Submission>> getSubmissionList() async {
    var submissionMapList = await getSubmissionMapList();
    int count = submissionMapList.length;

    List<Submission> submissionList = List<Submission>();
    for (int i = 0; i < count; i++) {
      submissionList.add(Submission.fromMapObject(submissionMapList[i]));
    }
    return submissionList;
  }
}
