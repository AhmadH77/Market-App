//@dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/Customer.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<ProfilePage> {
  SharedPreferences prefs;
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  var image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode.toUpperCase() == "EN")
      setState(() {
        isSelected = [true, false];
      });
    else
      setState(() {
        isSelected = [false, true];
      });
    return AdvancedDrawer(
        backdropColor: Colors.blueGrey,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening:
            (AppLocalizations.of(context).locale.languageCode.toUpperCase() ==
                    "EN")
                ? false
                : true,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: FutureBuilder<Customer>(
          future: APICalls(context).getUserInfo(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null)
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 250),
                  child: Stack(
                    children: [
                      Container(
                        height: 230,
                        child: AppBar(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(bottom: Radius.circular(40))),
                          backgroundColor: Colors.blueGrey,
                          elevation: 0.0,
                          title: Row(
                            children: [
                              IconButton(
                                onPressed: _handleMenuButtonPressed,
                                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                                  valueListenable: _advancedDrawerController,
                                  builder: (_, value, __) {
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 250),
                                      child:  value.visible ?Icon(
                                        Icons.clear ,
                                        key: ValueKey<bool>(value.visible),
                                      )
                                          : SvgPicture.asset(
                                        "assets/svg/menu.svg",
                                        width: 12.0,
                                        height: 12.0,
                                        key:  ValueKey<bool>(value.visible),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                AppLocalizations.getTranslated(context, 'profile'), //cart
                                style: TextStyle(
                                  height: 2.5,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: PhysicalModel(
                          elevation: 8.0,
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: Image.network(snapshot.data.photo ,).image
                              )
                            ),
                          )
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                ),
                body: Container(
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading:
                          Icon(Icons.info, color: Constants.primaryColor),
                          title: Text(
                            snapshot.data.firstName,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          subtitle: Text(snapshot.data.type),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading:
                          Icon(Icons.email, color: Constants.primaryColor),
                          title: Text(
                            snapshot.data.email,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: Icon(
                            Icons.phone,
                            color: Constants.primaryColor,
                          ),
                          title: Text(
                            snapshot.data.phone,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              );

            if(snapshot.connectionState == ConnectionState.waiting)
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 250),
                  child: Stack(
                    children: [
                      Container(
                        height: 230,
                        child: AppBar(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(bottom: Radius.circular(40))),
                          backgroundColor: Colors.blueGrey,
                          elevation: 0.0,
                          title: Row(
                            children: [
                              IconButton(
                                onPressed: _handleMenuButtonPressed,
                                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                                  valueListenable: _advancedDrawerController,
                                  builder: (_, value, __) {
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 250),
                                      child:  value.visible ?Icon(
                                        Icons.clear ,
                                        key: ValueKey<bool>(value.visible),
                                      )
                                          : SvgPicture.asset(
                                        "assets/svg/menu.svg",
                                        width: 12.0,
                                        height: 12.0,
                                        key:  ValueKey<bool>(value.visible),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                AppLocalizations.getTranslated(context, 'profile'), //cart
                                style: TextStyle(
                                  height: 2.5,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: PhysicalModel(
                          elevation: 8.0,
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                ),
                body: Container(
                  // color: Colors.red,
                  child: Center(
                    child:  SpinKitCubeGrid(
                    color: Constants.primaryColor,
                  ),
                  ),
                ),

              );

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 250),
                child: Stack(
                  children: [
                    Container(
                      height: 230,
                      child: AppBar(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(40))),
                        backgroundColor: Colors.blueGrey,
                        elevation: 0.0,
                        title: Row(
                          children: [
                            IconButton(
                              onPressed: _handleMenuButtonPressed,
                              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                                valueListenable: _advancedDrawerController,
                                builder: (_, value, __) {
                                  return AnimatedSwitcher(
                                    duration: Duration(milliseconds: 250),
                                    child:  value.visible ?Icon(
                                      Icons.clear ,
                                      key: ValueKey<bool>(value.visible),
                                    )
                                        : SvgPicture.asset(
                                      "assets/svg/menu.svg",
                                      width: 12.0,
                                      height: 12.0,
                                      key:  ValueKey<bool>(value.visible),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              AppLocalizations.getTranslated(context, 'profile'), //cart
                              style: TextStyle(
                                height: 2.5,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: PhysicalModel(
                        elevation: 8.0,
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        child:CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
              body: Container(
                // color: Colors.red,
                child: Center(
                  child: Text('No data found !'),
                ),
              ),

            );
          },
        ),
      drawer: MainDrawer(),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
