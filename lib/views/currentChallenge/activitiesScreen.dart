import 'package:change_agent/database/activity_data_presenter.dart';
import 'package:change_agent/database/i_activity_view.dart';
import 'package:change_agent/enums/Enums.dart';
import 'package:change_agent/models/activity.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/functions_util.dart';
import 'package:change_agent/utils/strings_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:change_agent/views/currentChallenge/attemptActivityScreen.dart';
import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  final Challenge _challenge;
  final User _signedInUser;

  ActivitiesScreen(this._challenge, this._signedInUser);

  @override
  _ActivitiesScreenState createState() =>
      _ActivitiesScreenState(_challenge, _signedInUser);
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    implements IActivityView {
  final Challenge challenge;
  User _signedInUser;
  bool _isLoading = false;
  BuildContext _buildContext;
  ActivityValue _activityValue = ActivityValue.activity1;
  List<Activity> _activityList = List<Activity>();
  ActivityDataPresenter _activityDataPresenter;

  _ActivitiesScreenState(this.challenge, this._signedInUser);

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _activityDataPresenter = ActivityDataPresenter(
        this, StringsUtil.getDelimitedList(challenge.activityIDs));
    _activityDataPresenter.retrieveActivities();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WidgetUtil().getGradientBackgroundContainer(_isLoading
        ? Center(child: CircularProgressIndicator())
        : getActivitiesView());
  }

  Widget getActivitiesView() {
    return WillPopScope(
        child: Scaffold(
            appBar: WidgetUtil().getAppBar(StringsResource.activities,
                icon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      moveToPreviousScreen(true); // todo make it check
                    })),
            backgroundColor: ColorsUtil.primaryColorDark.withOpacity(0.1),
            body: getDetailsScreen()),
        // ignore: missing_return
        onWillPop: () {
          FunctionsUtil.moveToPreviousScreen(true, context);
        });
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            WidgetUtil.getChallengeStatusBar(
              getTextAreaViewText(),
              context,
              itemsColor: Colors.black,
              barColor: getSafeAreaColor(),
              challenge: challenge
            ),
            getActivitiesRadioButtonsListView(_activityList),
          ],
        ),
        Flexible(
          flex: 7,
          child: WidgetUtil.getActivityDetailsWidget(
              _activityList[ActivityValue.values.indexOf(_activityValue)],
              context),
        ),
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
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: RaisedButton(
                color: ColorsUtil.primaryColorDark,
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(color: Theme.of(_buildContext).accentColor),
                    borderRadius: BorderRadius.circular(32)),
                textColor: ColorsUtil.colorAccent,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
                    child: getButtonText()),
                onPressed: () {
                  if (_signedInUser.currentActivityStatus == "none" && _signedInUser.currentChallengeID == challenge.id) {
                    WidgetUtil().show2BtnAlertDialog(
                      context,
                      "Acivity selection confirmation",
                      "Please make sure this is an activity you will be able to complete. Have you read and understood what this activity requires of you",
                      "No",
                      "Yes Continue",
                      () => Navigator.pop(context),
                      () => navigateToActivityScreen(
                          challenge,
                          _signedInUser,
                          _activityList[
                              ActivityValue.values.indexOf(_activityValue)]),
                    );
                  } else {
                    navigateToActivityScreen(
                        challenge,
                        _signedInUser,
                        _activityList[
                            ActivityValue.values.indexOf(_activityValue)]);
                  }
                }),
          ),
        ),
      ],
    );
  }

  String getTextAreaViewText() {
    List challengeStatusList =
        StringsUtil.getDelimitedList(_signedInUser.challengeStatus);
    int index = int.parse(challenge.id) - 1;
    return challengeStatusList[index] == "complete"
        ? "Challenge already complete"
        : challengeStatusList[index] == "pending"
            ? "Challenge pending"
            : challengeStatusList[index] == "rejected"
                ? "Challenge rejected, try again"
                : "Attempt one activity";
  }

  Color getSafeAreaColor() {
    List challengeStatusList =
        StringsUtil.getDelimitedList(_signedInUser.challengeStatus);
    int index = int.parse(challenge.id) - 1;
    return challengeStatusList[index] == "complete"
        ? Colors.green
        : challengeStatusList[index] == "pending"
            ? Colors.orange
            : challengeStatusList[index] == "rejected"
                ? Colors.red
                : Colors.white;
  }

  Text getButtonText() {
    List challengeStatusList =
        StringsUtil.getDelimitedList(_signedInUser.challengeStatus);
    int index = int.parse(challenge.id) - 1;
    return Text(
      _signedInUser.currentActivityStatus == "none" &&
              _signedInUser.currentChallengeID == challenge.id
          ? StringsResource.startActivity
          : (_signedInUser.currentActivityStatus == "started" &&
                  _signedInUser.currentChallengeID == challenge.id)
              ? StringsResource.continueActivity
              : _signedInUser.currentActivityStatus == "rejected"
                  ? StringsResource.retryActivity
                  : StringsResource.viewActivityDetails,
      style: TextStyle(fontSize: 15.0),
    );
  }

  modeSelectionChanged(ActivityValue value) {
    setState(() {
      _activityValue = value;
    });
  }

  Widget getActivitiesRadioButtonsListView(List<Activity> activityList) {
    int numberOfActivities =
        StringsUtil.getDelimitedList(challenge.activityIDs).length;
    return Container(
      child: new Center(
        child: _signedInUser.currentActivityStatus == "none" &&
                _signedInUser.currentChallengeID == challenge.id
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  numberOfActivities >= 1
                      ? WidgetUtil().getActivitySelectionRadioButton(
                          _activityList,
                          0,
                          ActivityValue.activity1,
                          _activityValue,
                          modeSelectionChanged, () {
                          //navigateToConfigureMode(_activityList[0]);
                        })
                      : Container(),
                  numberOfActivities >= 2
                      ? WidgetUtil().getActivitySelectionRadioButton(
                          _activityList,
                          1,
                          ActivityValue.activity2,
                          _activityValue,
                          modeSelectionChanged, () {
                          //navigateToConfigureMode(_activityList[1]);
                        })
                      : Container(),
                  numberOfActivities >= 3
                      ? WidgetUtil().getActivitySelectionRadioButton(
                          _activityList,
                          2,
                          ActivityValue.activity3,
                          _activityValue,
                          modeSelectionChanged, () {
                          //navigateToConfigureMode(_activityList[2]);
                        })
                      : Container(),
                  numberOfActivities >= 4
                      ? WidgetUtil().getActivitySelectionRadioButton(
                          _activityList,
                          3,
                          ActivityValue.activity4,
                          _activityValue,
                          modeSelectionChanged, () {
                          //navigateToConfigureMode(_activityList[3]);
                        })
                      : Container(),
                ],
              )
            : Container(),
      ),
    );
  }

  void _onBackPressed() {
    FunctionsUtil.moveToPreviousScreen(true, context);
  }

  void navigateToActivityScreen(
      Challenge challenge, User user, Activity activity) async {
    if (_signedInUser.currentActivityStatus == "none") {
      Navigator.pop(context);
    }
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
  void setActivities(List<Activity> activities) {
    setState(() {
      _activityList = activities;
      _isLoading = false;

      int selectedIndex = 0;
      _activityList.forEach((activity) {
        if (activity.id == _signedInUser.currentActivityID) {
          selectedIndex = _activityList.indexOf(activity);
        }
      });

      if (_signedInUser.currentActivityStatus != "none") {
        _activityValue = ActivityValue.values[selectedIndex];
      }
    });
  }

  @override
  void showFailureMessage(String message) {
    // TODO: implement showFailureMessage
  }

  @override
  void showSuccessMessage(String message) {
    // TODO: implement showSuccessMessage
  }
}
