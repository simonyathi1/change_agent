import 'package:change_agent/reources/dimens.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrinciplesScreen extends StatelessWidget {
  final _minimumPadding = 8.0;
  BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return WillPopScope(
      child: Scaffold(
        appBar: WidgetUtil().getAppBar(
          StringsResource.principles,
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
        Flexible(flex: 7, fit: FlexFit.tight, child: getPrinciplesListView()),
        Flexible(flex: 1, fit: FlexFit.tight, child: getButtonRow())
      ],
    );
  }

  Widget getTextWidget() {
    return Padding(
      padding: EdgeInsets.all(Dimens.sideMargin),
      child: new Text(
        StringsResource.privacyPolicyPlaceHolder,
        style: TextStyle(color: Colors.black, fontSize: 18.0),
      ),
    );
  }

  Widget getPrinciplesListView() {
    List<String> principles = [
      StringsResource.aboutWFTO,
      "",
      StringsResource.principle1,
      StringsResource.principle2,
      StringsResource.principle3,
      StringsResource.principle4,
      StringsResource.principle5,
      StringsResource.principle6,
      StringsResource.principle7,
      StringsResource.principle8,
      StringsResource.principle9,
      StringsResource.principle10,
    ];

    List<String> headings = [
      "\n"+StringsResource.aboutWFTOHeading+"\n",
      "\n"+"The 10 Principles explained",
      "\n"+StringsResource.principle1heading+"\n",
      "\n"+StringsResource.principle2heading+"\n",
      "\n"+StringsResource.principle3heading+"\n",
      "\n"+StringsResource.principle4heading+"\n",
      "\n"+StringsResource.principle5heading+"\n",
      "\n"+StringsResource.principle6heading+"\n",
      "\n"+StringsResource.principle7heading+"\n",
      "\n"+StringsResource.principle8heading+"\n",
      "\n"+StringsResource.principle9heading+"\n",
      "\n"+StringsResource.principle10heading+"\n",
    ];

    return ListView.builder(
        itemCount: principles.length,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            margin: EdgeInsets.only(left:16.0,right: 16.0),
              child: Card(
            borderOnForeground: false,
            color: Colors.transparent,
            elevation: 0,
            child: Column(
              children: <Widget>[
                Text(headings[position],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.center),
                Text(
                  principles[position],style: TextStyle( fontSize: 14.0),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ));
        });
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
