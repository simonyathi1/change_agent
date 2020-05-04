import 'dart:async';

import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/views/sign_in/google_sign_in.dart';
import 'package:change_agent/views/splash/splash_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() => runApp(WFTOApp());

class WFTOApp extends StatefulWidget {
  @override
  _WFTOAppState createState() => _WFTOAppState();
}

class _WFTOAppState extends State<WFTOApp> {
  Timer _timer;
  bool hasLoaded = false;
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    super.initState();

  }

  _WFTOAppState() {
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColor =
        MaterialColor(0xFF8cc63f, ColorsUtil.primaryColorMap);
    return MaterialApp(
      title: StringsResource.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        primaryColor: ColorsUtil.primaryColor,
        fontFamily: 'Quicksand',
        textSelectionColor: primaryColor,
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        highlightColor: primaryColor,
        hintColor: Colors.black45,
        unselectedWidgetColor: Colors.black,
      ),
      home: hasLoaded ? GoogleSignInScreen() : SplashUI(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
