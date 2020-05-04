import 'package:change_agent/models/submission.dart';
import 'package:flutter/cupertino.dart';

class FunctionsUtil {
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

  static List<String> getCurrentRankBadges(String challengeID) {
    int currentRankID = int.parse(challengeID);
    List<String> completedRanks = List();
    var rankBadgeUris = [
      "assets/images/1_change_private.png",
      "assets/images/2_change_private_first_class.png",
      "assets/images/3_change_specialist.png",
      "assets/images/4_change_corporal.png",
      "assets/images/5_change_sergeant.png",
      "assets/images/6_change_staff_sergeant.png",
      "assets/images/7_change_master_sergeant.png",
      "assets/images/8_change_sergeant_major.png",
      "assets/images/9_change_commander.png",
      "assets/images/10_change_agent.png"
    ];

    for (int i = 0; i < currentRankID; i++) {
      completedRanks.add(rankBadgeUris[i]);
    }

    return completedRanks;
  }

  static String getCurrentRank(String challengeID) {
    int currentRankID = int.parse(challengeID) - 1;
    var ranks = [
      "Change Private Dreamer",
      "Change Private First Class",
      "Change Specialist",
      "Change Corporal",
      "Change Sergeant",
      "Change Staff Sergeant",
      "Change Master Sergeant",
      "Change Sergeant Major",
      "Change Commander",
      "Change Agent"
    ];

    return ranks[currentRankID];
  }

  static List<String> getRanks() {
    var ranks = [
      "Change Private Dreamer",
      "Change Private First Class",
      "Change Specialist",
      "Change Corporal",
      "Change Sergeant",
      "Change Staff Sergeant",
      "Change Master Sergeant",
      "Change Sergeant Major",
      "Change Commander",
      "Change Agent"
    ];

    return ranks;
  }

  static String getCurrentRankBadge(String challengeID) {
    int currentRankID = int.parse(challengeID);
    var ranks = [
      "assets/images/1_change_private.png",
      "assets/images/2_change_private_first_class.png",
      "assets/images/3_change_specialist.png",
      "assets/images/4_change_corporal.png",
      "assets/images/5_change_sergeant.png",
      "assets/images/6_change_staff_sergeant.png",
      "assets/images/7_change_master_sergeant.png",
      "assets/images/8_change_sergeant_major.png",
      "assets/images/9_change_commander.png",
      "assets/images/10_change_agent.png"
    ];

    return ranks[currentRankID];
  }

  static List<String> getRankDescriptions() {
    var ranks = [
      "Change Private Dreamer",
      "Change Private First Class",
      "Change Specialist",
      "Change Corporal",
      "Change Sergeant",
      "Change Staff Sergeant",
      "Change Master Sergeant",
      "Change Sergeant Major",
      "Change Commander",
      "Change Agent"
    ];

    return ranks;
  }

}
