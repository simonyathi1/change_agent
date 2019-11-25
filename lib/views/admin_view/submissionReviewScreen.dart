import 'package:change_agent/database/i_admin_submission_view.dart';
import 'package:change_agent/database/submission_data_presenter.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/functions_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:change_agent/views/currentChallenge/attemptActivityScreen.dart';
import 'package:flutter/material.dart';

class SubmissionReviewScreen extends StatefulWidget {
  final Submission _submission;

  SubmissionReviewScreen(this._submission);

  @override
  _SubmissionReviewScreenState createState() =>
      _SubmissionReviewScreenState(_submission);
}

class _SubmissionReviewScreenState extends State<SubmissionReviewScreen>
    implements IAdminSubmissionView {
  final Submission submission;
  BuildContext _buildContext;
  SubmissionDataPresenter _submissionDataPresenter;
  bool hasDataChanged = false;
  bool hasApprovedOrRejected = false;

  _SubmissionReviewScreenState(this.submission);

  @override
  void initState() {
    super.initState();

    _submissionDataPresenter =
        SubmissionDataPresenter.adminAudit(this, submission);
    _submissionDataPresenter.getUserFromFireBase();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WidgetUtil().getGradientBackgroundContainer(getActivitiesView());
  }

  Widget getActivitiesView() {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorsUtil.colorAccent,
              centerTitle: true,
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                StringsResource.activities,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    moveToPreviousScreen(hasDataChanged);
                  }),
            ),
            backgroundColor: ColorsUtil.primaryColorDark,
            body: getDetailsScreen()),
        // ignore: missing_return
        onWillPop: () {
          FunctionsUtil.moveToPreviousScreen(hasDataChanged, context);
        });
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        WidgetUtil.getChallengeStatusBar(
          getTextAreaViewText(),
          context,
          itemsColor: Colors.black,
          barColor: getSafeAreaColor(),
        ),
        Flexible(
          flex: 7,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.baseMargin),
            child: WidgetUtil.getSubmissionDetailsWidget(submission, context),
          ),
        )
      ],
    );
  }

  Widget getDetailsScreen() {
    return Column(
      children: <Widget>[
        Flexible(flex: 7, fit: FlexFit.tight, child: getBody()),
        Flexible(flex: 1, fit: FlexFit.tight, child: getButtonRow())
      ],
    );
  }

  Widget getButtonRow() {
    return submission.submissionStatus != "pending" || hasApprovedOrRejected
        ? Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: RaisedButton(
                      color: ColorsUtil.primaryColorDark,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(_buildContext).accentColor),
                          borderRadius: BorderRadius.circular(32)),
                      textColor: ColorsUtil.colorAccent,
                      child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: Dimens.sideMargin),
                          child: Text(
                            StringsResource.done,
                          )),
                      onPressed: () {
                        _onDonePressed();
                      }),
                ),
              ),
            ],
          )
        : WidgetUtil().getButtonRow("Reject", "Approve", () {
            WidgetUtil().show2BtnAlertDialog(
                context,
                "Reject Submission",
                "You have selected the option to reject this submission. this will mark the activity rejected and prompt the user to re-attempt this. Are you sure this is what you intend?",
                () => Navigator.pop(context),
                () => _submissionDataPresenter.rejectSubmission());
          }, () {
            WidgetUtil().show2BtnAlertDialog(
                context,
                "Approve Submission",
                "You have selected the option to approve this submission. This will mark the activity complet and allow the user to move forward. Are you sure this is what you intend?",
                () => Navigator.pop(context),
                () => _submissionDataPresenter.approveSubmission());
          });
  }

  String getTextAreaViewText() {
    return submission.submissionStatus == "approved"
        ? "Challenge already complete"
        : submission.submissionStatus == "pending"
            ? "Challenge pending review"
            : submission.submissionStatus == "rejected"
                ? "Challenge rejected, try again"
                : "Attempt one activity";
  }

  Color getSafeAreaColor() {
    return submission.submissionStatus == "approved"
        ? Colors.green
        : submission.submissionStatus == "pending"
            ? Colors.yellow
            : submission.submissionStatus == "rejected"
                ? Colors.red
                : Colors.white.withOpacity(0.4);
  }

  void _onDonePressed() {
    FunctionsUtil.moveToPreviousScreen(hasDataChanged, context);
  }

  void navigateToActivityScreen(
      Challenge challenge, User user, Activity activity) async {
    bool hasChangedChannel = await Navigator.push(this.context,
        MaterialPageRoute(builder: (context) {
      return AttemptActivityScreen(challenge, user, activity);
    }));

    if (hasChangedChannel) {
      //_challengeDataPresenter.retrieveChallenges();
    }
  }

  void moveToPreviousScreen(bool hasChanged) {
    Navigator.pop(_buildContext, hasChanged);
  }

  @override
//  void setActivities(List<Activity> activities) {
//    setState(() {
//      _activityList = activities;
//      _isLoading = false;
//
//      int selectedIndex = 0;
//      _activityList.forEach((activity) {
//        if (activity.id == _signedInUser.currentActivityID) {
//          selectedIndex = _activityList.indexOf(activity);
//        }
//      });
//
//      if (_signedInUser.currentActivityStatus != "none") {
//        _activityValue = ActivityValue.values[selectedIndex];
//      }
//    });
//  }

  @override
  void showFailureMessage(String message) {
    // TODO: implement showFailureMessage
  }

  @override
  void showSuccessMessage(String message) {
    // TODO: implement showSuccessMessage
  }

  @override
  void setSubmissionList(List submissionList) {
    setState(() {
      hasApprovedOrRejected = true;
    });
  }

  @override
  void setSubmission(Submission submission) {
    setState(() {
      submission = submission;
      hasApprovedOrRejected = true;
    });
  }

  @override
  void setUser(User user) {
    // TODO: implement setUser
  }
}
