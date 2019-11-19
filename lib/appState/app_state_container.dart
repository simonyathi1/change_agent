import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:change_agent/models/provider.dart';
import 'package:change_agent/models/user.dart';
import 'package:change_agent/views/base/base_ui.dart';

import 'app_state.dart';

class AppStateContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppState state;

  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  /// This creates a method on the AppState that's just like 'of'
  /// On MediaQueries, Theme, etc
  /// This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  /// Pass the state through because on a StatefulWidget,
  /// properties are immutable. This way we can update it.
  AppState state;
  GoogleSignInAccount googleUser;
  //final googleSignIn = new GoogleSignIn(); // new

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      // Call a separate function because you can't use
      // async functionality in initState()
      initUser(); // new
    }
  }

  Future<Null> initUser() async {
    // First, check if a user exists.
    googleUser = await _ensureLoggedInOnStartUp();
    // If the user is null, we aren't loading anyhting
    // because there isn't anything to load.
    // This will force the homepage to navigate to the auth page.
    if (googleUser == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      // Do some other stuff, handle later.
    }
  }

  Future<GoogleSignInAccount> _ensureLoggedInOnStartUp() async {
    // That class has a currentUser if there's already a user signed in on
    // this device.
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) {
      // but if not, Google should try to sign one in whos previously signed in
      // on this phone.
      user = await _googleSignIn.signInSilently();
    }
    // NB: This could still possibly be null.
    googleUser = user;
    return user;
  }

  /* If all goes well, when you launch the app
   you'll see a loading spinner for 2 seconds
   Then the HomeScreen main view will appear
   */
  Future<Null> startCountdown() async {
    const timeOut = const Duration(seconds: 2);
    new Timer(timeOut, () {
      setState(() => state.isLoading = false);
    });
  }

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  Future<Null> logIntoFirebase() async {
    // This method will be used in two cases,
    // To make it work from both, we'll need to see if theres a user.
    // When fired from the button on the auth screen, there should
    // never be a googleUser
    if (googleUser == null) {
      // This built in method brings starts the process
      // Of a user entering their Google email and password.
      googleUser = await _googleSignIn.signIn();
    }

    // This is how you'll always sign into Firebase.
    // It's all built in props and methods, so not much work on your end.
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      // Authenticate the GoogleUser
      // This will give back an access token and id token
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Sign in to firebase with that:

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Not necessary

      final FirebaseUser fireBaseUser =
          (await _auth.signInWithCredential(credential)).user;
      print('Logged in: ${fireBaseUser.displayName}');

      setState(() {
        state.isLoading = false;
        state.user = fireBaseUser;
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> signIn() async {
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
      fireBaseUser.uid,
      fireBaseUser.displayName,
      fireBaseUser.email,
      fireBaseUser.photoUrl,
    );

    Navigator.push(
      context,
      new MaterialPageRoute(
//        builder: (context) => new BaseUI(fireBaseUser),
      ),
    );
    return fireBaseUser;
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
