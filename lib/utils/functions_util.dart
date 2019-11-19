import 'package:flutter/cupertino.dart';

class FunctionsUtil{

  static void moveToPreviousScreen(bool hasChanged, BuildContext context) {
    Navigator.pop(context, hasChanged);
  }
}