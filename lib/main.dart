import 'dart:async';

import 'package:flutter/material.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/utils/colors_util.dart';
import 'package:change_agent/views/sign_in/google_sign_in.dart';
import 'package:change_agent/views/splash/splash_ui.dart';

void main() => runApp(WFTOApp());

class WFTOApp extends StatefulWidget {
  @override
  _WFTOAppState createState() => _WFTOAppState();
}

class _WFTOAppState extends State<WFTOApp> {
  Timer _timer;
  bool hasLoaded = false;

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
        hintColor: Colors.white70,
        unselectedWidgetColor: Colors.white70,
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
