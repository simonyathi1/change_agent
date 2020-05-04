import 'package:change_agent/utils/colors_util.dart';
import 'package:flutter/material.dart';

class SplashUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashUIState();
  }
}

class SplashUIState extends State<SplashUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/change_splash.png",
              width: 200,
              height: 200,
              fit:BoxFit.fill,
            ),
            SizedBox(height: 16.0),
            Text("Change Agent")
          ],
        ),
      ),
    );
  }
}
