import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:change_agent/views/drawer/principles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/utils/widget_util.dart';
import 'package:change_agent/views/currentChallenge/challengesScreen.dart';
import 'package:change_agent/views/drawer/about_us.dart';
import 'package:change_agent/views/drawer/privacy.dart';
import 'package:change_agent/views/sign_in/google_sign_in.dart';
import 'package:change_agent/views/user/userDashboard.dart';
//import 'package:sqflite/sqlite_api.dart';

class BaseUI extends StatefulWidget {
  final User signedInUser;

  BaseUI(this.signedInUser);

  @override
  BaseUIState createState() {
    return BaseUIState(signedInUser);
  }
}

class BaseUIState extends State<BaseUI> {
  int currentPageIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  final User signedInUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var _pages;
  BaseUIState(this.signedInUser);

  @override
  void initState() {
    super.initState();
    _onInitState(context);
  }

  @override
  Widget build(BuildContext context) {
    scaffoldKey = new GlobalKey<ScaffoldState>();
     _pages = [
      UserDashBoard(signedInUser),
      ChallengesScreen(signedInUser),
    ];
    return Scaffold(
      key: scaffoldKey,
      body: WidgetUtil().getBaseGradientContainer(_pages[currentPageIndex]),
      backgroundColor: ColorsUtil.colorAccent,
      appBar: WidgetUtil().getAppBar(StringsResource.appTitle),
      drawer: WidgetUtil()
          .getDrawer(_onPrivacyPolicyClick, _onAboutUsClick, _onPrinciplesClick, _onSignOutClick, signedInUser),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        backgroundColor: ColorsUtil.primaryColorDark.withOpacity(.6),
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        //fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true,
        //new
        hasInk: false,
        //new, gives a cute ink effect
        inkColor: Colors.black12,
        //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: ColorsUtil.colorAccent,
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: ColorsUtil.colorAccent,
              ),
              title: Text(StringsResource.user)),
          BubbleBottomBarItem(
              backgroundColor: ColorsUtil.colorAccent,
              icon: Icon(
                Icons.local_activity,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.local_activity,
                color: ColorsUtil.colorAccent,
              ),
              title: Text(StringsResource.challenges)),
        ],
      ),
    );
  }

//
  void _onAboutUsClick() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => AboutUs()));
  }
  void _onPrinciplesClick() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => PrinciplesScreen()));
  }

  void _onPrivacyPolicyClick() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PrivacyPolicy()));
  }

  void _onSignOutClick() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) => new GoogleSignInScreen(signOut: true)),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  void _onInitState(BuildContext context) {
    _subscribeToTopicAsUser();
    var msg = "";
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
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
                    onPressed:
                      navigateHome
                      ,
                  ),
                ],
              ),
        ):"";
        msg = (message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        navigateHome();
      },
    );
  }

  _subscribeToTopicAsUser(){
    _fcm.subscribeToTopic(signedInUser.id);
  }

  void navigateHome() {
    Navigator.of(context).pop();
    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
              GoogleSignInScreen()));
    });

  }
}
