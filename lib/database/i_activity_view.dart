import 'package:change_agent/models/activity.dart';

abstract class IActivityView {
  void setActivities(List<Activity> activities);

  void showSuccessMessage(String message);

  void showFailureMessage(String message);
}
