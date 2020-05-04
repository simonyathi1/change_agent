import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AboutUs extends StatelessWidget {
  final _minimumPadding = 8.0;
  BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WillPopScope(
      child: Scaffold(
//        backgroundColor: Colors.white,
        appBar: WidgetUtil().getAppBar(
          StringsResource.aboutAppTitle,
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
        child: Column(
          children: <Widget>[
            Text(
              StringsResource.aboutUsDescriptionWelcome,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              StringsResource.aboutUsDescriptionTop,
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.sideMargin),
              child: Text(
                StringsResource.aboutUsDescriptionBeginnerRanks,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            WidgetUtil.getAboutUsItem(0),
            WidgetUtil.getAboutUsItem(1),
            WidgetUtil.getAboutUsItem(2),
            WidgetUtil.getAboutUsItem(3),
            WidgetUtil.getAboutUsItem(4),
            Padding(
              padding: EdgeInsets.all(Dimens.sideMargin),
              child: Text(
                StringsResource.aboutUsDescriptionIntermediateRanks,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            WidgetUtil.getAboutUsItem(5),
            WidgetUtil.getAboutUsItem(6),
            WidgetUtil.getAboutUsItem(7),
            WidgetUtil.getAboutUsItem(8),
            Padding(
              padding: EdgeInsets.all(Dimens.sideMargin),
              child: Text(
                StringsResource.aboutUsDescriptionTopRanks,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            WidgetUtil.getAboutUsItem(9),
            Text(
              StringsResource.aboutUsDescriptionBottom,
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ],
        ));
  }

  Widget getButtonRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(_minimumPadding),
            child: RaisedButton(
                color: ColorsUtil.primaryColorDark,
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(color: Theme.of(_buildContext).accentColor),
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
