import 'package:change_agent/models/user.dart';

abstract class IUserView{
  void setUser(User user);
  void showSuccessMessage(String message);
  void showFailureMessage(String message);
}