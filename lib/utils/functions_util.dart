import 'package:change_agent/models/submission.dart';
import 'package:flutter/cupertino.dart';

class FunctionsUtil{

  static void moveToPreviousScreen(bool hasChanged, BuildContext context) {
    Navigator.pop(context, hasChanged);
  }

  static int calculateTimeLapseInMinutes(Submission submission) {
    var start = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(submission.startTime));
    var end = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(submission.finishTime));

    var diff = end.difference(start);

    return diff.inMinutes % 60;
  }

  static String calculateTimeLapseForDisplay(Submission submission) {
    var start = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(submission.startTime));
    var end = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(submission.finishTime));

    var diff = end.difference(start);

    return "${diff.inHours} hours & ${diff.inMinutes % 60} mins";
  }
}