import 'package:change_agent/models/user.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/functions_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:flutter/material.dart';

class UserDashBoard extends StatefulWidget {
  final User signedInUser;

  UserDashBoard(this.signedInUser);

  @override
  _UserDashBoardState createState() => _UserDashBoardState(signedInUser);
}

class _UserDashBoardState extends State<UserDashBoard> {
  bool _fetchingData = false;

  final User signedInUser;

  _UserDashBoardState(this.signedInUser);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsUtil.colorAccent,
      child: WidgetUtil().getGradientBackgroundContainer(_fetchingData
          ? Center(child: CircularProgressIndicator())
          : getBody()),
    );
  }

  Widget getBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: WidgetUtil.getUserImage(signedInUser),
        ),
        Flexible(
          flex: 4,
          child: WidgetUtil.getUserDetailsWidget(signedInUser),
        )
      ],
    );
  }
}
