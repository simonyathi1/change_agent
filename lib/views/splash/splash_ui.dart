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
            Container(
              child: Text(
                'Change Agent',
                style: TextStyle(
                    fontSize: 24.0, color: ColorsUtil.primaryColorDark),
              ),
              decoration: BoxDecoration(
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            Stack(
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 8,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
