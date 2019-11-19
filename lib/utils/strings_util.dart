class StringsUtil {
//  static String maskDeviceNumber(String deviceNumber) {
//    if (deviceNumber.length == 10) {
//      return StringsResource.deviceNumberMask + deviceNumber.substring(7);
//    }
//    return deviceNumber;
//  }

  static String toTitleCase(String text) {
    String titleCased = "";
    titleCased = text[0].toUpperCase() + text.substring(1).toLowerCase();
    return titleCased;
  }

  static String truncate(String text) {
    String truncatedText = "";
    truncatedText = text[0].toUpperCase() + text.substring(1, 20) + "...";
    return truncatedText;
  }

  static List<String> getDelimitedList(String text){
    return text.split("*");
  }
}
