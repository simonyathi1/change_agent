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
                    moveToPreviousScreen(true);
                  }),
            ),
            backgroundColor: ColorsUtil.primaryColorDark,
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
            ),
            getActivitiesRadioButtonsListView(_activityList),
          ],
        ),
        Flexible(
          flex: 7,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.baseMargin),
            child: WidgetUtil.getActivityDetailsWidget(
                _activityList[ActivityValue.values.indexOf(_activityValue)],
                context),
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
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
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
                      margin: EdgeInsets.symmetric(vertical: Dimens.sideMargin),
                      child: Text(
                        _signedInUser.currentActivityStatus == "none"
                            ? StringsResource.startActivity
                            : _signedInUser.currentActivityStatus == "started"
                                ? StringsResource.continueActivity
                                : _signedInUser.currentActivityStatus ==
                                        "rejected"
                                    ? StringsResource.retryActivity
                                    : StringsResource.viewActivityDetails,
                      )),
                  onPressed: () {
                    if (_signedInUser.currentActivityStatus == "none") {
                      WidgetUtil().show2BtnAlertDialog(
                          context,
                          "Are you sure",
                          "Selected Activity cannot be changed, please make sure you are selecting one you will be able to complete",
                              () => Navigator.pop(context),
                              () => navigateToActivityScreen(
                              challenge,
                              _signedInUser,
                              _activityList[
                              ActivityValue.values.indexOf(_activityValue)]));
                    }
                    else{
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
      ),
    );
  }

  String getTextAreaViewText() {
    List challengeStatusList =
        StringsUtil.getDelimitedList(_signedInUser.challengeStatus);
    int index = int.parse(challenge.id) - 1;
    return challengeStatusList[index] == "complete"
        ? "Challenge already complete"
        : challengeStatusList[index] == "pending"
            ? "Challenge pending review"
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
            ? Colors.yellow
            : challengeStatusList[index] == "rejected"
                ? Colors.red
                : Colors.white;
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
        child: _signedInUser.currentActivityStatus == "none"
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
