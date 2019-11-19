import 'package:change_agent/models/challenge.dart';

abstract class IChallengeView{
  void setChallenges(List<Challenge> challenges);
  void showSuccessMessage(String message);
  void showFailureMessage(String message);
}