import 'package:change_agent/utils/colors_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:change_agent/database/i_user_view.dart';
import 'package:change_agent/database/user_data_presenter.dart';
import 'package:change_agent/models/provider.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/reources/strings_resource.dart';
import 'package:change_agent/views/admin_view/submissionsListScreen.dart';
import 'package:change_agent/views/base/base_ui.dart';

class GoogleSignInScreen extends StatefulWidget {
  final bool signOut;

  GoogleSignInScreen({this.signOut = false});

  @override
  GoogleSignInScreenState createState() => GoogleSignInScreenState(signOut);
}

class GoogleSignInScreenState extends State<GoogleSignInScreen>
    implements IUserView {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  bool hasLoaded;
  GoogleSignInAccount googleUser;
  UserDataPresenter _userDataPresenter;
  bool signOut = false;

  GoogleSignInScreenState(this.signOut);

  @override
  void initState() {
    if (signOut) {
      signOutGoogle();
      hasLoaded = true;
    } else {
      initUser();
      hasLoaded = false;
      _userDataPresenter = UserDataPresenter(this);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
//            Container(
//              width: MediaQuery.of(context).size.width,
//              height: MediaQuery.of(context).size.height,
//              child: Image.network(
//                  'https://images.unsplash.com/photo-1518050947974-4be8c7469f0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
//                  fit: BoxFit.fill,
//                  color: Color.fromRGBO(255, 255, 255, 0.6),
//                  colorBlendMode: BlendMode.modulate),
//            ),
            hasLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      getLoginMethodButton(
                          'Sign in with Google',
                          Color(0xffffffff),
                          Icon(
                            FontAwesomeIcons.google,
                            color: Color(0xffCE107C),
                          ),
                          () => _signIn(context)
                              .then((FirebaseUser user) => print(user))
                              .catchError((e) => print(e))),
//                getLoginMethodButton(
//                    'Sign in with Facebook',
//                    Color(0xffffffff),
//                    Icon(
//                      FontAwesomeIcons.facebookF,
//                      color: Color(0xff4754de),
//                    ),
//                    () {}),
//                getLoginMethodButton(
//                    'Sign in with Email',
//                    Color(0xffffffff),
//                    Icon(
//                      FontAwesomeIcons.solidEnvelope,
//                      color: Color(0xff4caf50),
//                    ),
//                    () {}),
                    ],
                  )
                : Center(
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
          ],
        ),
      ),
    );
  }

  Widget getLoginMethodButton(String buttonText, Color buttonColor,
      Icon buttonIcon, Function onButtonPressed) {
    return Container(
        width: 250.0,
        child: Align(
          alignment: Alignment.center,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: buttonColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buttonIcon,
                SizedBox(width: 10.0),
                Text(
                  buttonText,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ],
            ),
            onPressed: onButtonPressed,
          ),
        ));
  }

  Future<dynamic> initUser() async {
    googleUser = await _ensureLoggedInOnStartUp();
    if (googleUser != null) {
      User user = new User.onSignIn(
        googleUser.id,
        googleUser.displayName,
        googleUser.email,
        googleUser.photoUrl,
      );

      debugPrint("*****=====" + user.id);
      _userDataPresenter.setUser(user);
    } else {
      setState(() {
        hasLoaded = true;
      });
    }
  }

  Future<GoogleSignInAccount> _ensureLoggedInOnStartUp() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) {
      user = await _googleSignIn.signInSilently();
    }
    // NB: This could still possibly be null.
    googleUser = user;
    return user;
  }

  Future<FirebaseUser> _signIn(BuildContext context,
      {GoogleSignInAccount googleUser}) async {
    setState(() {
      hasLoaded = false;
    });
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign in'),
    ));

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser fireBaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    Provider providerInfo = new Provider(fireBaseUser.providerId);

    List<Provider> providerData = new List<Provider>();
    providerData.add(providerInfo);

    User user = new User.onSignIn(
      googleUser.id,
      googleUser.displayName,
      googleUser.email,
      googleUser.photoUrl,
    );
    debugPrint("*****" + user.id);
    _userDataPresenter.setUser(user);
    return fireBaseUser;
  }

  navigateHome(User user) {
    MaterialPageRoute screen = user.id == StringsResource.adminUserID
        ? MaterialPageRoute(
      builder: (context) => new SubmissionsListScreen(user),
    )
        : MaterialPageRoute(
      builder: (context) => new BaseUI(user),
    );

    Navigator.pushReplacement(
      context,
      screen,
    );
  }

  signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  @override
  void setUser(User user) {
//    setState(() {
    navigateHome(user);
//      hasLoaded = true;
//    });
  }

  @override
  void showFailureMessage(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
    ));
  }

  @override
  void showSuccessMessage(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
    ));
  }
}
