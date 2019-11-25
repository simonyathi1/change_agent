import 'package:change_agent/database/i_submission_view.dart';
import 'package:change_agent/database/submission_data_presenter.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/validation_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

// ignore: must_be_immutable
class AttemptActivityScreen extends StatefulWidget {
  Challenge challenge;
  User user;
  Activity activity;

  AttemptActivityScreen(this.challenge, this.user, this.activity);

  @override
  _AttemptActivityScreenState createState() =>
      _AttemptActivityScreenState(challenge, user, activity);
}

class _AttemptActivityScreenState extends State<AttemptActivityScreen>
    implements ISubmissionView {
  final _minimumPadding = 8.0;

  BuildContext _buildContext;
  bool _isLinkValid;
  int _buttonFlex = 1;
  Challenge challenge;
  User user;
  Activity activity;
  SubmissionDataPresenter _submissionDataPresenter;

  _AttemptActivityScreenState(this.challenge, this.user, this.activity);

  var _submissionLinkController = new TextEditingController();

  @override
  void initState() {
    _isLinkValid = true;

    _submissionDataPresenter =
        SubmissionDataPresenter(this, challenge, activity, user);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        setState(() {
          visible ? _buttonFlex = 2 : _buttonFlex = 1;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtil.colorAccent,
          centerTitle: true,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            StringsResource.activityAttempt,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToPreviousScreen(true);
              }),
        ),
        body: WidgetUtil().getActivityGradientBackgroundContainer(
            Form(child: getDetailsScreen())),
      ),
      // ignore: missing_return
      onWillPop: () {
        moveToPreviousScreen(false);
      },
    );
  }

  Widget getDetailsScreen() {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: getActivityDetailsWidget(activity, context)),
        Flexible(flex: _buttonFlex, fit: FlexFit.tight, child: getButtonRow())
      ],
    );
  }

  Widget getTextWidget() {
    return Padding(
      padding: EdgeInsets.all(Dimens.sideMargin),
      child: new Text(
        StringsResource.about_us_description,
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
    );
  }

  Widget getActivityDetailsWidget(Activity activity, BuildContext context) {
    return ListView(
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
                  "Description",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                Text(
                  activity.description,
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
                user.currentActivityStatus == "none" ||
                        user.currentActivityStatus == "started" ||
                        user.currentActivityStatus == "rejected"
                    ? WidgetUtil().getTextFieldWidget(
                        "Social Medial Post Link",
                        "Enter social media post link",
                        _submissionLinkController,
                        _isLinkValid,
                        StringsResource.linkCannotBeEmpty)
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getButtonRow() {
    return user.currentActivityStatus == "none" ||
            user.currentActivityStatus == "started" ||
            user.currentActivityStatus == "rejected"
        ? Padding(
            padding: EdgeInsets.all(_minimumPadding * 0.5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(_minimumPadding),
                    child: RaisedButton(
                        color: ColorsUtil.primaryColorDark,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(_buildContext).accentColor),
                            borderRadius: BorderRadius.circular(32)),
                        textColor: ColorsUtil.colorAccent,
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimens.sideMargin),
                            child: Text(
                              StringsResource.submit,
                              textScaleFactor: 1.5,
                            )),
                        onPressed: () {
                          setState(() {
                            if (ValidationUtil.emptyTextValidation(
                                _submissionLinkController)) {
                              _onSubmit();
                            } else {
                              _isLinkValid = false;
                            }
                          });
                        }),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.all(_minimumPadding * 0.5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(_minimumPadding),
                    child: RaisedButton(
                        color: ColorsUtil.primaryColorDark,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(_buildContext).accentColor),
                            borderRadius: BorderRadius.circular(32)),
                        textColor: ColorsUtil.colorAccent,
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimens.sideMargin),
                            child: Text(
                              StringsResource.done,
                              textScaleFactor: 1.5,
                            )),
                        onPressed: () => moveToPreviousScreen(true)),
                  ),
                ),
              ],
            ),
          );
  }

  void _onSubmit() {
    WidgetUtil().show2BtnAlertDialog(
      context,
      "Submission Confirmation",
      "Please make sure that you are submitting the correct link, otherwise your submission will be automatically rejected",
      () => Navigator.pop(context),
      () => save(),
    );
  }

  void save() {
    Navigator.pop(context);
    Submission submission = Submission(
        activity.name,
        _submissionLinkController.text,
        user.id,
        activity.id,
        challenge.id,
        user.currentActivityStartTime,
        "",
        "pending",
        activity.description,
        activity.points,
        activity.timeAllocationPoints,
        activity.hourAllocation);

    _submissionDataPresenter.setSubmission(submission);
  }

  @override
  void dispose() {
    _submissionLinkController.dispose();
    super.dispose();
  }

  void moveToPreviousScreen(bool hasChanged) {
    Navigator.pop(_buildContext, hasChanged);
  }

  @override
  void showFailureMessage(String message) {
    // TODO: implement showFailureMessage
  }

  @override
  void showSuccessMessage(String message) {
    // TODO: implement showSuccessMessage
  }

  @override
  void setUser(User user) {
    setState(() {
      this.user = user;
    });
  }

}
