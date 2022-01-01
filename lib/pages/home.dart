import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/pages/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/loginPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAccountStatus();
  }

  Future<void> checkAccountStatus() async {
    bool logged = false;
    bool statue = false;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('passenger_id'))
      logged = true;
    else
      logged = false;
    if (prefs.containsKey('state'))
      statue = true;
    else
      statue = false;

    if (logged) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Store(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 150.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/market.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Add a brand\n",
                                style: TextStyle(
                                  height: 2.5,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "to your look",
                                style: TextStyle(
                                  fontSize: 28.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 130.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(50.0),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Constants.primaryColor,
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
