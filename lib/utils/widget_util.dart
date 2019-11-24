import 'package:change_agent/enums/Enums.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/functions_util.dart';
import 'package:change_agent/utils/strings_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors_util.dart';

class WidgetUtil {
//  static SMSResultListener smsResultListener;
  final _minimumPadding = 8.0;
  static const platform = MethodChannel('sendSMS');

//
//  Future<Null> _sendSms(String text, Device device) async {
//    try {
//      final String result = await platform.invokeMethod('sendNow',
//          <String, dynamic>{"phone": device.deviceNumber, "msg": text});
//      print(result);
//      smsResultListener.success();
//    } on PlatformException catch (e) {
//      print(e.toString());
//      smsResultListener.failure();
//    } on MissingPluginException catch (e) {
//      print(e.toString());
//      smsResultListener.failure();
//    }
//  }

//  void sendSMS(String text, Device device) async {
//    await _sendSms(text, device);
//  }

  Widget getUserImageFromLink(User user) {
    return Container(
      child: userImageWidget(user.photoUrl),
    );
  }

  Widget getEventImage(Activity sermon) {
    return Container(
//      child: speakerImage(sermon.graphicLink),
        );
  }

  static Widget getChallengeItem(
      Challenge challenge, String challengeStatus, Function onClick) {
//    Widget speakerImage = WidgetUtil().getSpeakerImage(sermon);
    Widget detailsView =
        WidgetUtil().challengeTileDetail(challenge, challengeStatus);

    return GestureDetector(
      child: Container(
        child: detailsView,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(20.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
            ],
          ),
        ),
      ),
      onTap: onClick,
    );
  }

  static Widget getSubmissionItem(Submission submission, Function onClick) {
//    Widget speakerImage = WidgetUtil().getSpeakerImage(sermon);
    Widget detailsView = WidgetUtil().submissionTileDetail(submission);

    return GestureDetector(
      child: Container(
        child: detailsView,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(20.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
            ],
          ),
        ),
      ),
      onTap: onClick,
    );
  }

  static Widget getEventItem(Activity sermon, Function onClick) {
    Widget detailsView = WidgetUtil().eventTileDetail(sermon);

    return GestureDetector(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            detailsView,
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(20.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
            ],
          ),
        ),
      ),
      onTap: onClick,
    );
  }

//  void show2BtnAlertDialog(BuildContext context, String title, String message, Function negativeAction, Function positiveAction) {
//    AlertDialog alertDialog = AlertDialog(
//      title: Text(title),
//      content: Text(message),
//      actions: <Widget>[],
//    );
//    showDialog(context: context, builder: (_) => alertDialog);
//  }

  void show2BtnAlertDialog(BuildContext context, String title, String message, Function negativeAction, Function positiveAction) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Alert'),
        content: Text('Some content'),
        actions: <Widget>[
          _platformDialogAction("Cancel",negativeAction),
          _platformDialogAction("OK",positiveAction),
        ],
      ),
    );
  }

  PlatformDialogAction _platformDialogAction(String btnText, Function action) {
    return PlatformDialogAction(
      child: PlatformText(btnText),
      onPressed: action,
    );
  }

  Widget drawerText() {
    var appName = Text(
      "App by ",
      style: TextStyle(color: Colors.black.withOpacity(0.5)),
    );
    var fideli = Text(
      "Fideli",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
    );
    var tech = Text(
      "Tech  ",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.green.withOpacity(0.5)),
    );

    var image = Container(
      height: 20.0,
      width: 20.0,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white70.withOpacity(0.5),
          image: DecorationImage(
            image: AssetImage("assets/images/fidelitech_logo-cutout.png"),
          )),
    );

    return Row(
      children: <Widget>[appName, fideli, tech, image],
    );
  }

  Widget getOnCircle() {
    return CircleAvatar(
      radius: 110.0,
      backgroundColor: Colors.lightBlueAccent,
      child: CircleAvatar(
        radius: 90.0,
        backgroundColor: Colors.black45,
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(
            Icons.flash_on,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget userImageWidget(String imageLink) {
    if (imageLink.isEmpty) {
      return Container(
          child: CircleAvatar(
        radius: 75.0,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          radius: 74.0,
          backgroundColor: Colors.black45,
          child: CircleAvatar(
            radius: 73.0,
            backgroundColor: Colors.lightBlueAccent,
            child: CircleAvatar(
              radius: 72.0,
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.account_circle,
                color: Colors.deepOrange.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ));
    } else {
      return Stack(children: <Widget>[
        CircleAvatar(
          radius: 85.0,
          backgroundImage: NetworkImage(imageLink),
        )
      ]);
    }
  }

  Widget challengeTileDetail(Challenge challenge, String challengeStatus) {
    var title = Text(
      challenge.title,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
    );

    var activities = Text(
      StringsUtil.getDelimitedList(challenge.activityIDs.toString())
              .length
              .toString() +
          " Activities",
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.white54, fontSize: 12.0),
    );

    var status = ListTile(
      trailing: challengeStatus == "complete"
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : challengeStatus == "pending"
              ? Icon(
                  Icons.remove_circle,
                  color: Colors.yellow,
                )
              : challengeStatus == "rejected"
                  ? Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )
                  : challengeStatus == "locked"
                      ? Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
    );
    return Padding(
        padding:
            EdgeInsets.only(left: Dimens.baseMargin, bottom: Dimens.baseMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[status, title, activities],
        ));
  }

  Widget submissionTileDetail(Submission submission) {
    var title = Text(
      submission.title,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
    );

    var submittedMaterial = Text(
      submission.submittedMaterial,
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.white54, fontSize: 12.0),
    );

    var status = ListTile(
      trailing: submission.submissionStatus == "approved"
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : submission.submissionStatus == "pending"
              ? Icon(
                  Icons.remove_circle,
                  color: Colors.yellow,
                )
              : submission.submissionStatus == "rejected"
                  ? Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )
                  : submission.submissionStatus == "locked"
                      ? Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
    );
    return Padding(
        padding:
            EdgeInsets.only(left: Dimens.baseMargin, bottom: Dimens.baseMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[status, title, submittedMaterial],
        ));
  }

  Widget eventTileDetail(Activity sermon) {
//    var title = Text(
//      sermon.eventName,
//      textAlign: TextAlign.left,
//      style: TextStyle(
//          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
//    );
//    var date = Text(
//      sermon.date,
//      textAlign: TextAlign.left,
//      style: TextStyle(color: Colors.white54, fontSize: 12.0),
//    );
//    var speaker = Text(
//      sermon.speaker,
//      textAlign: TextAlign.start,
//      style: TextStyle(color: Colors.white70, fontSize: 16.0),
//    );
//    var summary = Text(
//      sermon.location,
//      textAlign: TextAlign.start,
//      style: TextStyle(color: Colors.white54, fontSize: 12.0),
//    );

    return Padding(
        padding: EdgeInsets.all(Dimens.baseMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[title, speaker, date, summary],
        ));
  }

  Widget getGradientContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(5.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.7, 1],
          colors: [
            Colors.black45,
            Colors.black45,
            Colors.black45,
          ],
        ),
      ),
      child: child,
    );
  }

  Widget getImageGradientOverlay(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(5.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.7, 1],
          colors: [
            Colors.black45,
            Colors.black45,
            Colors.black45,
          ],
        ),
      ),
      child: child,
    );
  }

  Widget getGradientBackgroundContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.8, 1.0],
          colors: [
            ColorsUtil.colorAccent,
            ColorsUtil.primaryColorDark.withOpacity(0.8),
            ColorsUtil.primaryColorDark,
          ],
        ),
      ),
//          image: DecorationImage(
//              image: AssetImage("assets/images/.......png"),
//              fit: BoxFit.cover)),

      child: child,
    );
  }

  Widget getActivityGradientBackgroundContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0, 0.9, 1.0],
          colors: [
            ColorsUtil.colorAccent,
            ColorsUtil.primaryColorDark,
            ColorsUtil.primaryColorDark,
          ],
        ),
      ),
//          image: DecorationImage(
//              image: AssetImage("assets/images/.......png"),
//              fit: BoxFit.cover)),

      child: child,
    );
  }

  Widget getBaseGradientContainer(Widget child) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.8, 1.0],
              colors: [
                ColorsUtil.colorAccent,
                ColorsUtil.primaryColorDark.withOpacity(0.8),
                ColorsUtil.primaryColorDark,
              ],
            ),
          ),
          child: child,
        ),
      ],
    );
  }

//  GestureDetector getAnimatedSwitchWidget(
//          String label, bool isActive, Function _toggle) =>
//      GestureDetector(
//        onTap: _toggle,
//        behavior: HitTestBehavior.translucent,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Padding(
//              padding:
//                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
//              child: Text(label,
//                  textScaleFactor: 1.2,
//                  style: new TextStyle(color: Colors.white70)),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
//              child: AnimatedSwitch(checked: isActive),
//            )
//          ],
//        ),
//      );

  Widget getTextFieldWidget(String label, String hint,
      TextEditingController controller, bool isTextValid, String errorText,
      [bool isNumber = false]) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Form(
        child: new TextFormField(
          //style: appliedTextStyle,
          controller: controller,
          style: TextStyle(color: Colors.white70),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: label,
              //labelStyle: appliedTextStyle,
              errorStyle: TextStyle(fontSize: 15),
              hintText: hint,
              errorText: isTextValid ? null : errorText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ),
      ),
    );
  }

  Widget getButtonRow(String negativeButtonText, String primaryButtonText,
      Function onNegativeButtonClick, Function onPrimaryButtonClick) {
    return Padding(
      padding: EdgeInsets.all(_minimumPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: _minimumPadding, right: _minimumPadding),
              child: RaisedButton(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: ColorsUtil.primaryColor),
                      borderRadius: BorderRadius.circular(20)),
                  textColor: Colors.white70,
                  child: Text(
                    negativeButtonText,
                    textScaleFactor: 1.5,
                  ),
                  onPressed: onNegativeButtonClick),
            ),
          ),
          getPrimaryButton(primaryButtonText, onPrimaryButtonClick),
        ],
      ),
    );
  }

  Widget getPrimaryButton(
      String primaryButtonText, Function onPrimaryButtonClick) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: _minimumPadding, right: _minimumPadding),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ColorsUtil.primaryColor,
          textColor: Colors.black,
          child: Text(
            primaryButtonText,
            textScaleFactor: 1.5,
          ),
          onPressed: onPrimaryButtonClick),
    ));
  }

  static Widget getConnectHeaderImage() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage("assets/images/ocj_logo_color.png"),
              fit: BoxFit.contain)),
    );
  }

//
//  Widget connectTileDetail(ConnectMethod connectMethod) {
//    var methodName = Text(
//      connectMethod.methodName,
//      textAlign: TextAlign.left,
//      style: TextStyle(
//          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
//    );
//
//    return Padding(
//        padding: EdgeInsets.all(Dimens.baseMargin),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            methodName,
//          ],
//        ));
//  }
//
//  Widget getConnectImage(ConnectMethod connectMethod) {
//    return Stack(children: <Widget>[
//      CircleAvatar(
//        radius: 35.0,
//        backgroundColor: ColorsUtil.primaryColorDark,
//      ),
//      CircleAvatar(
//        radius: 34.0,
//        backgroundImage: AssetImage(connectMethod.graphicLink),
//      )
//    ]);
//  }
//
//  static Widget getConnectButton(ConnectMethod connectMethod) {
//    Widget methodImage = WidgetUtil().getConnectImage(connectMethod);
//    Widget detailsView = WidgetUtil().connectTileDetail(connectMethod);
//
//    return GestureDetector(
//      child: Container(
//        margin: EdgeInsets.only(top: Dimens.sideMargin),
//        child: Padding(
//          padding: EdgeInsets.all(Dimens.sideMargin),
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              methodImage,
//              detailsView,
//            ],
//          ),
//        ),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(const Radius.circular(20.0)),
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            stops: [0.1, 0.65, 1],
//            colors: [
//              ColorsUtil.primaryColorDark.withOpacity(0.2),
//              ColorsUtil.primaryColorDark.withOpacity(0.2),
//              ColorsUtil.primaryColorDark.withOpacity(0.2),
//            ],
//          ),
//        ),
//      ),
//      onTap: () => _launchURL(connectMethod.urlLink),
//    );
//  }

  static _launchURL(String url) async {
    if (url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      //todo Navigate to connect screen
    }
  }

  Widget getPaddedWidget(Widget widget) {
    return Padding(
      padding: EdgeInsets.all(_minimumPadding),
      child: Row(
        children: <Widget>[
          widget,
        ],
      ),
    );
  }

  Widget getDrawer(Function privacy, Function about, Function settings) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
//            currentAccountPicture: new GestureDetector(
//              child: CircleAvatar(),
//            ),
            decoration: BoxDecoration(
              color: ColorsUtil.colorAccent,
//              image: DecorationImage(
//                  image: AssetImage("assets/images/ocj_logo_colored_bg.png"),
//                  fit: BoxFit.contain),
            ),
          ),
          ListTile(
            title: Text(StringsResource.privacyPolicy),
            leading: Icon(
              Icons.security,
              color: ColorsUtil.primaryColorDark,
            ),
            onTap: privacy,
          ),
          ListTile(
            title: Text(StringsResource.aboutAppTitle),
            leading: Icon(
              Icons.info,
              color: ColorsUtil.primaryColorDark,
            ),
            onTap: about,
          ),
          ListTile(
            title: Text(StringsResource.logout),
            leading: Icon(
              Icons.exit_to_app,
              color: ColorsUtil.primaryColorDark,
            ),
            onTap: settings,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: Align(
                alignment: Alignment.bottomRight,
                child: WidgetUtil().drawerText(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getActivitySelectionRadioButton(
      List<Activity> activityList,
      int index,
      ActivityValue activityValue,
      ActivityValue groupValue,
      Function onChangeMade,
      Function onEditTap) {
    Activity activity = activityList.length > 0 ? activityList[index] : null;
    return ListTile(
        title: Text(
            activityList.length > 0
                ? activity.name
                : "Activity " + (index + 1).toString(),
            style: TextStyle(
              color: Colors.white70,
            )),
        leading: Radio(
          activeColor: ColorsUtil.colorAccent,
          value: activityValue,
          groupValue: groupValue,
          onChanged: onChangeMade,
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.edit,
            color: Colors.white70,
          ),
          onTap: onEditTap,
        ));
  }

  FloatingActionButton getFAB(Function onFABClick) {
    return FloatingActionButton(
      child: Icon(
        Icons.send,
        color: Colors.black,
      ),
      onPressed: onFABClick,
    );
  }

  static getBigEmptySpeaker() {
    return Center(
      child: CircleAvatar(
        radius: 120.0,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          radius: 115.0,
          backgroundColor: Colors.black45,
          child: CircleAvatar(
            radius: 108.0,
            backgroundColor: Colors.lightBlueAccent,
            child: CircleAvatar(
              radius: 106.0,
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.settings_voice,
                color: Colors.deepOrange.withOpacity(0.7),
                size: 50.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static getChallengeStatusBar(
    String title,
    BuildContext context, {
    Color barColor,
    IconData leftIcon,
    IconData rightIcon,
    String subTitle,
    Color itemsColor,
    Function onLeftIconClick,
    Function onRightIconClick,
  }) {
    itemsColor == null ? itemsColor = Colors.white : itemsColor = itemsColor;

    if (subTitle == null) {
      subTitle = "";
    }

    return Container(
      color: barColor,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: itemsColor.withOpacity(0.8),
              fontSize: subTitle == "" ? 20.0 : 14.0,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  static Widget getUserImage(User user) {
    Widget speakerImage = WidgetUtil().getUserImageFromLink(user);
    return Container(
      margin: EdgeInsets.all(Dimens.smallMargin),
      child: Center(
        child: speakerImage,
      ),
    );
  }

  static Widget getUserDetailsWidget(User user) {
    return Center(
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 230.0,
              child: Stack(
                children: <Widget>[
                  Container(),
                  Center(
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 52.0),

                        Spacer(),
                        Text(user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0)),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          user.currentLevel,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18.0),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Activity",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              " : ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              user.currentActivity,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Status",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              " : ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              user.currentActivityStatus,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Points",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              " : ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18.0),
                            ),
                            Text(
                              user.points.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(32.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.6),
              ColorsUtil.primaryColorDark.withOpacity(0.4),
              ColorsUtil.primaryColorDark.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getActivityDetailsWidget(
      Activity activity, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 52.0),
                  Text(activity.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    activity.points.toString() + " Points",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  Text(
                    activity.hourAllocation.toString() + " Hours",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    "Summary",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  Text(
                    activity.summary,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Submission type",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  Text(
                    activity.submissionType == "social_post"
                        ? "Social media post"
                        : activity.submissionType,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Submission instruction",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  Text(
                    activity.activitySubmissionInstruction,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(32.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.65, 1],
          colors: [
            ColorsUtil.primaryColorDark.withOpacity(0.6),
            ColorsUtil.primaryColorDark.withOpacity(0.4),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  static Widget getSubmissionDetailsWidget(
      Submission submission, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 52.0),
                  Text(submission.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    submission.points.toString() + " Points",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    "Descrption",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  Text(
                    submission.activityDescription,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Duration",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),

                  Text(
                    FunctionsUtil.calculateTimeLapseForDisplay(submission),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 18.0),
                  ),

                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Review",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          child: RaisedButton(
                            color: ColorsUtil.primaryColorDark,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(32)),
                            textColor: ColorsUtil.colorAccent,
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Dimens.sideMargin),
                                child: Text(
                                  "View Social Media Post",
                                )),
                            onPressed: () {
                              _launchURL(submission.submittedMaterial);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(32.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.65, 1],
          colors: [
            ColorsUtil.primaryColorDark.withOpacity(0.6),
            ColorsUtil.primaryColorDark.withOpacity(0.4),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  getOCJAppBar(String appTitle) {
    return AppBar(
      elevation: 0.5,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        appTitle,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: ColorsUtil.colorAccent,
    );
  }
}
