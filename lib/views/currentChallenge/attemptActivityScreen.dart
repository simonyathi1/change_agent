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
import 'package:change_agent/views/base/base_ui.dart';
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
  Submission _submission;

  bool displayHelpOverlay = false;

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
        appBar: WidgetUtil().getAppBar(StringsResource.activityAttempt,
            icon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isSubmissionAllowed()?ColorsUtil.colorAccentGreen: Colors.transparent,
                    ),
                    onPressed: () {
                      moveToPreviousScreen(true); // todo make it check
                    })),
        body: WidgetUtil()
            .getGradientBackgroundContainer(Form(child: getDetailsScreen())),
      ),
      // ignore: missing_return
      onWillPop: () {
         moveToPreviousScreen(false);
      },
    );
  }

  Widget getDetailsScreen() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Flexible(
                flex: 7,
                fit: FlexFit.tight,
                child: getActivityDetailsWidget(activity, context)),
            Flexible(
                flex: _buttonFlex, fit: FlexFit.tight, child: getButtonRow())
          ],
        ),
        displayHelpOverlay ? getOverlay() : SizedBox.shrink()
      ],
    );
  }

  Widget getActivityDetailsWidget(Activity activity, BuildContext context) {
    return ListView(
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
                      color: Colors.black.withOpacity(0.8), fontSize: 14.0),
                ),
                Text(
                  activity.hourAllocation.toString() + " Hours",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 14.0),
                ),
                SizedBox(
                  height: 20.0,
                ),

                Text("Decription",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.8),
                        fontSize: 16.0)),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  activity.description,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 14.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Instruction",
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
                      color: Colors.black.withOpacity(0.8), fontSize: 14.0),
                ),

                SizedBox(
                  height: 20.0,
                ),

                isSubmissionAllowed()
                    ? getTextWithHelpButton()
                    : Text("Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(.8),
                            fontSize: 16.0)),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  "Submitted and pending review",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getTextWithHelpButton() {
    var textWidget = WidgetUtil().getTextFieldWidget(
        "Social Medial Post Link",
        "Enter social media post link",
        _submissionLinkController,
        _isLinkValid,
        StringsResource.linkCannotBeEmpty);

    return Stack(
      children: <Widget>[textWidget, getHelpButton()],
      alignment: Alignment.topRight,
    );
  }

  bool isSubmissionAllowed() {
//    List challengeStatusList =
//        StringsUtil.getDelimitedList(user.challengeStatus);
//    int index = int.parse(user.currentChallengeID) - 1;
    return user.currentActivityStatus == "none" &&
            user.currentChallengeID == challenge.id ||
        (user.currentActivityStatus == "started" &&
            user.currentChallengeID == challenge.id) ||
        user.currentActivityStatus == "rejected";
  }

  Widget getButtonRow() {
    return isSubmissionAllowed()
        ? Row(
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
                          margin:
                              EdgeInsets.symmetric(vertical: Dimens.baseMargin),
                          child: Text(
                            StringsResource.submit,
                            style: TextStyle(fontSize: 15.0),
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
          )
        : Row(
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
                          margin:
                              EdgeInsets.symmetric(vertical: Dimens.baseMargin),
                          child: Text(
                            StringsResource.done,
                            style: TextStyle(fontSize: 18.0),
                          )),
                      onPressed: () => moveToPreviousScreen(true)),
                ),
              ),
            ],
          );
  }

  void _onSubmit() {
    WidgetUtil().show2BtnAlertDialog(
      context,
      "Submission Confirmation",
      "Incorrect links will be rejected. Are you sure and happy about the link you are submitting?",
      "No",
      "Yes Submit",
      () => Navigator.pop(context),
      () => _save(),
    );
  }

  var title = Text(
    "How submission works\n",
    style: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
  );
  var howItWorks = Text(
    "The way it works is that once you have completed the challenge "
    "and posted on social media, you will need to copy the link"
    "to your post and submit it here. The admin will audit the submission and "
    "measure it against the requirements fot the challenge. Dead links, incorrect links,"
    " etc will all lead to a rejected submission, upon which you will have to do this again."
    " Note that submissions done withini the specified timeframe will lead to getting the bonus"
    " points as specified, if submission is made after the time has passed, you will just get the base points\n",
    style: TextStyle(color: Colors.black, fontSize: 18.0),
  );
  var copyTweetTitle = Text(
    "How to copy Tweet link\n",
    style: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
  );
  var howToCopy = Text(
    "To copy the link on Twitter, click the tweet to view it. Click the "
    "share button, one of the options provided will be copy link to tweet. Copy it, "
    "and paste it in the provided input field. You will be notified when there is a result\n\n",
    style: TextStyle(color: Colors.black, fontSize: 18.0),
  );

  var tapAnywhereToClose = Text(
    "Tap Anywhere To Close!!!\n\n",
    style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        letterSpacing: 5.0,
        fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
  );

  Widget getOverlay() {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(Dimens.sideMargin),
            child: ListView(
              children: <Widget>[
                title,
                howItWorks,
                copyTweetTitle,
                howToCopy,
                tapAnywhereToClose
              ],
            )),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65, 1],
            colors: [
              Colors.white.withOpacity(1.0),
              Colors.white.withOpacity(1.0),
              Colors.white.withOpacity(0.8),
            ],
          ),
        ),
      ),
      onTap: () => setState(() {
        displayHelpOverlay = false;
      }),
    );
  }

  Widget getHelpButton() {
    return RaisedButton(
        color: ColorsUtil.primaryColorDark,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(_buildContext).accentColor),
            borderRadius: BorderRadius.circular(40)),
        textColor: ColorsUtil.colorAccent,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
            child: Text(
              "?",
              style: TextStyle(fontSize: 22.0),
            )),
        onPressed: () {
          setState(() {
            displayHelpOverlay = true;
          });
        });
  }

  void _save() {
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

  void navigateToHomeScreen(BuildContext context, User user) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return BaseUI(user);
    }));
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
