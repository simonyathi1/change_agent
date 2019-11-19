import 'package:flutter/material.dart';
import 'package:change_agent/database/challenge_data_presenter.dart';
import 'package:change_agent/database/i_challenge_view.dart';
import 'package:change_agent/models/challenge.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/utils/strings_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:change_agent/views/currentChallenge/activitiesScreen.dart';

class ChallengesScreen extends StatefulWidget {
  final User _signedInUser;

  ChallengesScreen(this._signedInUser);

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState(_signedInUser);
}

class _ChallengesScreenState extends State<ChallengesScreen>
    implements IChallengeView {
  List<Challenge> _challenges = List();
  bool _isLoading = false;
  User _signedInUser;
  ChallengeDataPresenter _challengeDataPresenter;

  _ChallengesScreenState(this._signedInUser);

  @override
  void initState() {
    _challengeDataPresenter = ChallengeDataPresenter(this);
    _challengeDataPresenter.retrieveChallenges();
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtil().getGradientBackgroundContainer(_isLoading
        ? Center(child: CircularProgressIndicator())
        : getChallengesListView());
  }

  Widget getChallengesListView() {
    List <String> challengeStatusList =
    StringsUtil.getDelimitedList(_signedInUser.challengeStatus);

    return ListView.builder(
        itemCount: _challenges.length,
        itemBuilder: (BuildContext context, int position) {
          if (_challenges.isNotEmpty) {
            return Container(
                child: Card(
              borderOnForeground: false,
              color: Colors.transparent,
              elevation: 0,
              child: WidgetUtil.getChallengeItem(
                  _challenges[position], challengeStatusList[position], () {
                if (_challenges[position].id !=
                        _signedInUser.currentChallengeID &&
                    int.parse(_signedInUser.currentChallengeID) <
                        int.parse(_challenges[position].id)) {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text('Challenge still locked'),
                  ));
                } else {
                  navigateToActivityScreen(
                      _challenges[position], _signedInUser);
                }
              }),
            ));
          } else {
            return Center(
              child: Text("No Challenges"),
            );
          }
        });
  }

  @override
  void setChallenges(List<Challenge> challenges) {
    setState(() {
      _challenges = challenges;
      _isLoading = false;
    });
  }

  void navigateToActivityScreen(Challenge challenge, User user) async {
    bool hasChangedChannel = await Navigator.push(this.context,
        MaterialPageRoute(builder: (context) {
      return ActivitiesScreen(challenge, user);
    }));

    if (hasChangedChannel) {
      _challengeDataPresenter.retrieveChallenges();
    }
  }

  @override
  void showFailureMessage(String message) {
    // TODO: implement showFailureMessage
  }

  @override
  void showSuccessMessage(String message) {
    // TODO: implement showSuccessMessage
  }
//  void _navigateToPlaySermon(Challenge sermon) {
//    Navigator.of(context).push(MaterialPageRoute(
//        builder: (BuildContext context) => SermonPlayback(sermon)));
//  }
}
