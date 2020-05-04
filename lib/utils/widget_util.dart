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

  static Widget getChallengeItem(int position, Challenge challenge,
      String challengeStatus, Function onClick) {
    Widget detailsView =
        WidgetUtil().challengeTileDetail(challenge, challengeStatus, position);

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0, right: 16.0, left: 16.0),
        child: detailsView,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.3),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.1),
            ],
          ),
        ),
      ),
      onTap: onClick,
    );
  }

  static Widget getAboutUsItem(int position) {
    Widget image =
        Image.asset(FunctionsUtil.getCurrentRankBadge(position.toString()));
    Widget title = Text(
      FunctionsUtil.getRanks()[position],
      style: TextStyle(color: Colors.black.withOpacity(.8), fontSize: 18.0),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: image,
        title: title,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.01, 0.01, 1],
          colors: [
            ColorsUtil.primaryColorDark.withOpacity(0.5),
            ColorsUtil.primaryColorDark.withOpacity(0.1),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  static Widget getSubmissionItem(
      int position, Submission submission, Function onClick) {
//    Widget speakerImage = WidgetUtil().getSpeakerImage(sermon);
    Widget detailsView = WidgetUtil().submissionTileDetail(submission);

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
        child: detailsView,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              ColorsUtil.primaryColorDark.withOpacity(0.3),
              ColorsUtil.primaryColorDark.withOpacity(0.2),
              ColorsUtil.primaryColorDark.withOpacity(0.1),
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

  void show2BtnAlertDialog(
      BuildContext context,
      String title,
      String message,
      String negativeButtonText,
      String positiveButtonText,
      Function negativeAction,
      Function positiveAction) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          _platformDialogAction(negativeButtonText, negativeAction),
          _platformDialogAction(positiveButtonText, positiveAction),
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
    if (imageLink == null || imageLink.isEmpty) {
      return Container(
        child: Icon(
          Icons.account_circle,
          color: ColorsUtil.primaryColorDark.withOpacity(.6),
          size: 200.0,
        ),
      );
    } else {
      return Stack(children: <Widget>[
        CircleAvatar(
          radius: 85.0,
          backgroundImage: NetworkImage(imageLink),
        )
      ]);
    }
  }

  Widget challengeTileDetail(
      Challenge challenge, String challengeStatus, int position) {
    List rankBadgeUris = [
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

    var title = Text(
      challenge.title,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0),
    );

    var activities = Text(
      StringsUtil.getDelimitedList(challenge.activityIDs.toString())
              .length
              .toString() +
          " Activities",
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.black45, fontSize: 12.0),
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
                    color: Colors.orange,
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
        title: Text(
          FunctionsUtil.getCurrentRank((position + 2).toString()),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 15.0),
        ),
        subtitle: challengeStatus == "complete"
            ? Text(
                "Complete",
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 8.0,
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              )
            : challengeStatus == "pending"
                ? Text(
                    "Pending",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 8.0,
                        color: Colors.black.withOpacity(.2),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                : challengeStatus == "rejected"
                    ? Text(
                        "Rejected",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 8.0,
                            color: Colors.black.withOpacity(.2),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      )
                    : challengeStatus == "locked"
                        ? Text(
                            "Locked",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 8.0,
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        : Text(
                            "Unlocked",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 8.0,
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          ),
        leading: Hero(
          tag: challenge,
          child: Container(
            child: Image.asset(
              rankBadgeUris[position + 1],
              height: 25.0,
            ),
          ),
        ));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        status,
        Padding(
          padding: EdgeInsets.only(
              left: Dimens.baseMargin, bottom: Dimens.baseMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[title, activities],
          ),
        ),
      ],
    );
  }

  Widget submissionTileDetail(Submission submission) {
    var title = Text(
      "    ${submission.title}",
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0),
    );

    var titleLabel = Text(
      "Submitted activity: ",
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12.0),
    );

    var submittedMaterial = Text(
      "    ${submission.submittedMaterial}",
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0),
    );

    var submissionLabel = Text(
      "Submission link: ",
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12.0),
    );

    var status = submission.submissionStatus == "approved"
        ? Text(
            "Complete",
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: 8.0,
                color: Colors.black.withOpacity(.6),
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          )
        : submission.submissionStatus == "pending"
            ? Text(
                "Pending",
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 8.0,
                    color: Colors.black.withOpacity(.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              )
            : Text(
                "Rejected",
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 8.0,
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              );

    var statusIcon = Container(
      child: submission.submissionStatus == "approved"
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : submission.submissionStatus == "pending"
              ? Icon(
                  Icons.remove_circle,
                  color: Colors.orange,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
    );

    return Padding(
        padding:
            EdgeInsets.only(left: Dimens.baseMargin, bottom: Dimens.baseMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[status, statusIcon],
            ),
            SizedBox(
              height: 8.0,
            ),
            titleLabel,
            title,
            submissionLabel,
            submittedMaterial,
          ],
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
            Colors.white,
            Colors.white,
            Colors.white,
//            ColorsUtil.primaryColorDark.withOpacity(0.8),
//            ColorsUtil.primaryColorDark,
          ],
        ),

        image: DecorationImage(
            image: AssetImage("assets/images/military_bg.jpg"),
            fit: BoxFit.cover),
      ),
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
            ColorsUtil.primaryColorDark.withOpacity(.1),
            ColorsUtil.primaryColorDark.withOpacity(.1),
            ColorsUtil.primaryColorDark.withOpacity(.1),
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
          style: TextStyle(
            color: Colors.black,
          ),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
              errorStyle: TextStyle(fontSize: 15),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
              errorText: isTextValid ? null : errorText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ),
      ),
    );
  }

  Widget getButtonRow(String negativeButtonText, String primaryButtonText,
      Function onNegativeButtonClick, Function onPrimaryButtonClick) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin:
                EdgeInsets.only(left: _minimumPadding, right: _minimumPadding),
            child: RaisedButton(
                color: ColorsUtil.primaryColorDark,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorsUtil.primaryColor),
                    borderRadius: BorderRadius.circular(32)),
                textColor: Colors.white70,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
                    child: Text(
                      negativeButtonText,
                      style: TextStyle(fontSize: 15.0),
                    )),
                onPressed: onNegativeButtonClick),
          ),
        ),
        getPrimaryButton(primaryButtonText, onPrimaryButtonClick),
      ],
    );
  }

  Widget getPrimaryButton(
      String primaryButtonText, Function onPrimaryButtonClick) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: _minimumPadding, right: _minimumPadding),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          color: ColorsUtil.primaryColor,
          textColor: Colors.black,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
              child: Text(
                primaryButtonText,
                style: TextStyle(fontSize: 15.0),
              )),
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

  static _launchURL(String url) async {
    if (url.isNotEmpty) {
      if (url.contains("facebook.com")) {
        _launchFBURL(url);
      } else {
        _launchAnyURL(url);
      }
    } else {
      //todo Navigate to connect screen
    }
  }

  static _launchFBURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  static _launchAnyURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
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

  Widget getDrawer(Function privacy, Function about, Function principles,
      Function settings, User user) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user.name,
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              user.currentLevel,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: new GestureDetector(
              child: user.photoUrl != null && user.photoUrl != ""
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    )
                  : Container(
                      child: Icon(
                        Icons.account_circle,
                        color: ColorsUtil.primaryColorDark.withOpacity(.6),
                        size: 80.0,
                      ),
                    ),
            ),
            decoration: BoxDecoration(
              color: ColorsUtil.colorAccent,
              image: DecorationImage(
                  image: AssetImage("assets/images/wtfo_drawer.png"),
                  fit: BoxFit.cover),
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
            title: Text(StringsResource.principles),
            leading: Icon(
              Icons.description,
              color: ColorsUtil.primaryColorDark,
            ),
            onTap: principles,
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
    return Container(
      child: Row(children: <Widget>[
        Radio(
          activeColor: ColorsUtil.colorAccentGreen,
          value: activityValue,
          groupValue: groupValue,
          onChanged: onChangeMade,
        ),
        Text(
            activityList.length > 0
                ? activity.name
                : "Activity " + (index + 1).toString(),
            style: TextStyle(
              color: Colors.black,
            )),
      ],),
    );
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
    Challenge challenge,
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

//    Widget leading;
//    if (challenge != null) {
//      var url = FunctionsUtil.getCurrentRankBadge(challenge.id);
//      leading = Hero(
//        tag: challenge,
//        child: Container(
//          child: Image.asset(
//            url,
//            height: 45.0,
//          ),
//        ),
//      );
//    } else {
//      leading = Icon(
//        Icons.add,
//        color: Colors.transparent,
//      );
//    }
    return Container(
      color: barColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: itemsColor.withOpacity(0.8),
              fontSize: subTitle == "" ? 16.0 : 14.0,
              fontWeight: FontWeight.w400),
        ),
    );
  }

  static Widget getUserCompletedBadges(List<String> completedRanks) {
    List<Widget> completedBadges = List();
    completedRanks.forEach((url) {
      var icon = Expanded(
        child: Container(
            child: Image.asset(
          url,
          height: 35.0,
        )),
      );
      completedBadges.add(icon);
    });

    return ListTile(
      title: Row(children: completedBadges),
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
    List completedBadgeUrls =
        FunctionsUtil.getCurrentRankBadges(user.currentChallengeID);
    var changeAgentBadge = FunctionsUtil.getCurrentRankBadges("10")[9];
    return user.currentChallengeID != "10"
        ? Center(
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
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              WidgetUtil.getUserCompletedBadges(
                                  completedBadgeUrls),
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.65, 1],
                  colors: [
                    ColorsUtil.primaryColorDark.withOpacity(.6),
                    ColorsUtil.primaryColorDark.withOpacity(.6),
                    ColorsUtil.primaryColorDark.withOpacity(.6),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 320.0,
                    child: Stack(
                      children: <Widget>[
                        Container(),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              WidgetUtil.getUserCompletedBadges(
                                  completedBadgeUrls),
                              Spacer(),
                              Text(
                                "Congratulations!!!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32.0),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                user.name,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 22.0),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "You have sucessfully completed all the challenges. \nYou are a",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "WFTO Change Agent!!!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26.0),
                              ),
                              Image.asset(
                                changeAgentBadge,
                                height: 55.0,
                                width: 65.0,
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.65, 1],
                  colors: [
                    ColorsUtil.primaryColorDark.withOpacity(.6),
                    ColorsUtil.primaryColorDark.withOpacity(.6),
                    ColorsUtil.primaryColorDark.withOpacity(.6),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(height: 52.0),
                  Text(activity.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    activity.points.toString() + " Points",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  Text(
                    activity.hourAllocation.toString() + " Hours",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(height: 20.0),

                  Text(
                    "Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    activity.summary,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Submission type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    activity.submissionType == "social_post"
                        ? "Social media post"
                        : activity.submissionType,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Instruction",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    activity.activitySubmissionInstruction,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
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
            ColorsUtil.primaryColorDark.withOpacity(0.0),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    submission.points.toString() + " Points",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Descrption",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    submission.activityDescription,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Duration",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    FunctionsUtil.calculateTimeLapseForDisplay(submission),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Review Post👇🏽",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16.0)),
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
                                    vertical: Dimens.baseMargin),
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
            ColorsUtil.primaryColorDark.withOpacity(0.0),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
            ColorsUtil.primaryColorDark.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  getAppBar(String appTitle, {IconButton icon}) {
    return AppBar(
      elevation: 0.5,
      iconTheme: IconThemeData(color: ColorsUtil.colorAccentGreen),
      title: Text(
        appTitle,
        style: TextStyle(
            color: ColorsUtil.colorAccentGreen, fontWeight: FontWeight.w700, fontSize: 18.0),
      ),
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
    );
  }

  getAdminAppBar(String appTitle, {IconButton icon, IconButton trailingIcon}) {
    return AppBar(
      elevation: 0.5,
      iconTheme: IconThemeData(color: ColorsUtil.colorAccentGreen),
      title: Text(
        appTitle,
        style: TextStyle(
            color: ColorsUtil.colorAccentGreen, fontWeight: FontWeight.w700, fontSize: 18.0),
      ),
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      actions: <Widget>[trailingIcon],
    );
  }
}
