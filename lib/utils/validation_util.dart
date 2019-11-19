import 'package:flutter/material.dart';

class ValidationUtil {
  static bool emptyTextValidation(TextEditingController textEditingController) {
    return textEditingController.text.length > 0;
  }

  static bool deviceNumberValidation(
      TextEditingController textEditingController) {
    return textEditingController.text.length <= 10;
  }

  static bool deviceNumberValidationOnSave(
      TextEditingController textEditingController) {
    return textEditingController.text.length == 10;
  }
}
