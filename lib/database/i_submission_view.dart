import 'package:change_agent/models/user.dart';

abstract class ISubmissionView {
  void showSuccessMessage(String message);

  void showFailureMessage(String message);

  void setUser(User user);
}
