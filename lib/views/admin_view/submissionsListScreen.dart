import 'package:flutter/material.dart';
import 'package:change_agent/database/i_admin_submission_view.dart';
import 'package:change_agent/database/submission_data_presenter.dart';
import 'package:change_agent/models/submission.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';

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
  SubmissionDataPresenter _submissionDataPresenter;

  _SubmissionsListScreenState(this._signedInUser);

  @override
  void initState() {
    _submissionDataPresenter = SubmissionDataPresenter.admin(this);
    _submissionDataPresenter.getSubmissionsFromFireBase();
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.colorAccent,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          StringsResource.submissions,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: ColorsUtil.primaryColorDark,
      body: WidgetUtil().getGradientBackgroundContainer(
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : getSubmissionsListView(),
      ),
    );
  }

  Widget getSubmissionsListView() {
    return ListView.builder(
        itemCount: _submissions.length,
        itemBuilder: (BuildContext context, int position) {
          if (_submissions.isNotEmpty) {
            return Container(
                child: Card(
              borderOnForeground: false,
              color: Colors.transparent,
              elevation: 0,
              child: WidgetUtil.getSubmissionItem(_submissions[position], () {
                navigateToActivityReviewScreen(_submissions[position]);
              }),
            ));
          } else {
            return Center(
              child: Text("No Submissions"),
            );
          }
        });
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
}
