import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:change_agent/appState/app_state_container.dart';
class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final container = AppStateContainer.of(context);

    return new Container(
      width: width,
      color: Colors.white,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            onPressed: () => container.signIn(),
            color: Colors.white,
            child: new Container(
              width: 230.0,
              height: 50.0,
              alignment: Alignment.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xffCE107C),
                    ),
                  ),
                  new Text(
                    'Sign in With Google',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}