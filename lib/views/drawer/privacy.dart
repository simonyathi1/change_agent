import 'package:change_agent/reources/dimens.dart';
import 'package:flutter/material.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';

// ignore: must_be_immutable
class PrivacyPolicy extends StatelessWidget {
  final _minimumPadding = 8.0;
  BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WillPopScope(
      child: Scaffold(
        appBar: WidgetUtil().getAppBar(
          StringsResource.privacyPolicy,
          icon: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToPreviousScreen(true);
            },
          ),
        ),
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
    return Column(
      children: <Widget>[
        Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: ListView(children: <Widget>[getTextWidget()])),
        Flexible(flex: 1, fit: FlexFit.tight, child: getButtonRow())
      ],
    );
  }

  Widget getTextWidget() {
    return Padding(
      padding: EdgeInsets.all(Dimens.sideMargin),
      child: new Text(
        StringsResource.about_us_description,
        style: TextStyle(color: Colors.black, fontSize: 18.0),
      ),
    );
  }

  Widget getButtonRow() {
    return  Row(
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
                    margin: EdgeInsets.symmetric(vertical: Dimens.baseMargin),
                    child: Text(
                      StringsResource.done,
                      style: TextStyle(fontSize: 18.0),
                    )),
                onPressed: () {
                  moveToPreviousScreen(false);
                }),
          ),
        ),
      ],
    );
  }

  void moveToPreviousScreen(bool hasChanged) {
    Navigator.pop(_buildContext, hasChanged);
  }
}
