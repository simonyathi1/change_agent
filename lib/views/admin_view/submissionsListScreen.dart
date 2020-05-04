import 'package:change_agent/database/i_admin_submission_view.dart';
import 'package:change_agent/database/submission_data_presenter.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:change_agent/views/sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'submissionReviewScreen.dart';

class SubmissionsListScreen extends StatefulWidget {
  final User _signedInUser;

  SubmissionsListScreen(this._signedInUser);

  @override
  _SubmissionsListScreenState createState() =>
      _SubmissionsListScreenState(_signedInUser);
}

class _SubmissionsListScreenState extends State<SubmissionsListScreen>
    implements IAdminSubmissionView {
  List<Submission> _submissions = List();
  bool _isLoading = false;
  User _signedInUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  SubmissionDataPresenter _submissionDataPresenter;

  _SubmissionsListScreenState(this._signedInUser);

  @override
  void initState() {
    _submissionDataPresenter = SubmissionDataPresenter.admin(this);
    _submissionDataPresenter.getSubmissionsFromFireBase();
    _onInitState(context);
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtil().getAdminAppBar(StringsResource.submissions,
          trailingIcon: IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () {
                _onSignOutClick();
              })),
      backgroundColor: ColorsUtil.primaryColorDark,
      body: WidgetUtil().getGradientBackgroundContainer(
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : getSubmissionsListView(),
      ),
    );
  }

  Widget getSubmissionsListView() {
    var pendingSubmissions = List();
    _submissions.forEach((submission) {
      if (submission.submissionStatus == "pending" && !pendingSubmissions.contains(submission)) {
        pendingSubmissions.add(submission);
      }
    });

    if (pendingSubmissions.isNotEmpty) {
      return ListView.builder(
          itemCount: pendingSubmissions.length,
          itemBuilder: (BuildContext context, int position) {
            return Container(
                child: Card(
                  borderOnForeground: false,
                  color: Colors.transparent,
                  elevation: 0,
                  child: WidgetUtil.getSubmissionItem(
                      position, pendingSubmissions[position], () {
                    navigateToActivityReviewScreen(pendingSubmissions[position]);
                  }),
                ));
          });
    } else {
      return Center(
        child: Text("No Pending Submissions"),
      );
    }
  }

  void navigateToActivityReviewScreen(Submission submission) async {
    bool hasChangedChannel = await Navigator.push(this.context,
        MaterialPageRoute(builder: (context) {
      return SubmissionReviewScreen(submission);
    }));

    if (hasChangedChannel) {
      _submissionDataPresenter.getSubmissionsFromFireBase();
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

  @override
  void setSubmissionList(List submissionList) {
    setState(() {
      _submissions = submissionList;
      _isLoading = false;
    });
  }

  @override
  void setSubmission(Submission submission) {
    // TODO: implement setSubmission
  }

  @override
  void setUser(User user) {
    // TODO: implement setUser
  }

  void _onSignOutClick() {
    WidgetUtil().show2BtnAlertDialog(
      context,
      "Sign Out?",
      "Are you sure you want to sign out of the app?",
      "No",
      "Yes",
      () => Navigator.pop(context),
      () => _signOut(),
    );
  }

  void _signOut() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) => new GoogleSignInScreen(signOut: true)),
    );
  }

  void _onInitState(BuildContext context) {
    _subscribeToTopicAsAdmin();
    var msg = "";
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        msg == (message['notification']['body'])? showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      _submissionDataPresenter.getSubmissionsFromFireBase();
                      Navigator.of(context).pop();},
                  ),
                ],
              ),
        ): "";
        msg = (message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        msg == (message['notification']['body'])?
        _submissionDataPresenter.getSubmissionsFromFireBase():"";
        msg = (message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        msg == (message['notification']['body'])?
        _submissionDataPresenter.getSubmissionsFromFireBase():"";
        msg = (message['notification']['body']);
      },
    );
  }

  _subscribeToTopicAsAdmin(){
    _fcm.subscribeToTopic('submissions');
  }

}
