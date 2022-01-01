//@dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/TextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Customer.dart';
import '../store.dart';
import 'RegisterPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _isAuthenticating = false;
  String _authorized = 'Not s';
  SharedPreferences prefs;

  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isObsecure = true;
  bool isloading = false;
  bool userIsValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {});
    });
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 30,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 75),
          child: Text(
            AppLocalizations.getTranslated(context, 'login'),
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(18.0),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                loginScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  loginScreen() {
    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: TextFieldItem(
                  labelText: AppLocalizations.getTranslated(context, 'Phone'),
                  controller: phoneCont,
                  type: 'phone',
                )),
            Padding(
                padding: EdgeInsets.only(top: 23.0),
                child: TextFieldItem(
                  type: 'password',
                  controller: passCont,
                  labelText:
                      AppLocalizations.getTranslated(context, 'Password'),
                )),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: MaterialButton(
                elevation: 10,
                padding: EdgeInsets.all(15),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SpinKitCubeGrid(
                          color: Constants.primaryColor,
                        );
                      },
                    );
                    var result = await APICalls(context)
                        .login(phoneCont.text, passCont.text);
                    Navigator.pop(context);
                    if (result == 'Not Verified')
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Store()
                              // VerifyAccount(phone: phoneCont.text),
                              ));
                    else if (result == 'success') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Store(),
                          ));
                    }
                  }
                },
                color: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: isloading
                    ? CupertinoActivityIndicator()
                    : Text(AppLocalizations.getTranslated(context, 'login')),
              ),
            ),
            (_supportState != _SupportState.unsupported &&
                    prefs != null &&
                    prefs.containsKey('bindDevice'))
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '-- OR --',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Authenticate'),
                                Icon(Icons.perm_device_information),
                              ],
                            ),
                          ),
                          onPressed: _authenticate,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            Padding(
              padding: EdgeInsets.only(top: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.getTranslated(context, 'newUser?')),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registration(),
                            ),
                          ),
                      child: Text(
                        AppLocalizations.getTranslated(context, 'register'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    if (authenticated) {
      showDialog(
        context: context,
        builder: (context) {
          return SpinKitCubeGrid(
            color: Constants.primaryColor,
          );
        },
      );
      Customer user =
          await APICalls(context).getUserInfo(id: prefs.getInt('bindDevice'));

      if (user != null) {
        prefs.setInt('passenger_id', prefs.getInt('bindDevice'));
        prefs.setString('user_type', user.type);

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
        } on Exception catch (e) {
          // TODO
          print('firebase catch $e');
        }

        Navigator.pop(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Store();
            },
          ),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
