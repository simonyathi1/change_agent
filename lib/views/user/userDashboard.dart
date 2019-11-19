import 'package:flutter/material.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';

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


//  Challenge _sermon = Challenge(
//      "Transcendental Faith",
//      "06-01-2018",
//      "Ps. Majali",
//      StringsUtil.truncate(
//          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"),
//      "");

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
      children: <Widget>[
        Flexible(
          flex: 3,
          child: WidgetUtil.getUserImage(signedInUser),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
            child: WidgetUtil.getUserDetailsWidget(signedInUser),
          ),
        )
      ],
    );
  }
}
