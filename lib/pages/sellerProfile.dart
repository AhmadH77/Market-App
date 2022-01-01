//@dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/Customer.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class SellerProfilePage extends StatefulWidget {
  final id;

  const SellerProfilePage({Key key, this.id}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<SellerProfilePage> {
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
    return Scaffold(
      body: FutureBuilder<Customer>(
        future: APICalls(context).getUserInfo(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            print('test ${snapshot.data.long} -${snapshot.data.lat}');
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 250),
                child: Stack(
                  children: [
                    Container(
                      height: 230,
                      child: AppBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(40))),
                        backgroundColor: Colors.blueGrey,
                        elevation: 0.0,
                        title: Row(
                          children: [
                            Text(
                              AppLocalizations.getTranslated(
                                  context, 'seller_profile'), //cart
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image: Image.network(
                                  snapshot.data.photo,
                                ).image)),
                          )),
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
                      ),
                      ListTile(
                        onTap: () {
                          openMap(snapshot.data.long, snapshot.data.lat);
                        },
                        contentPadding: EdgeInsets.all(10),
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: Constants.primaryColor,
                        ),
                        title: Text(
                          AppLocalizations.getTranslated(
                              context, 'showLocation'),
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
          }

          if (snapshot.connectionState == ConnectionState.waiting)
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 250),
                child: Stack(
                  children: [
                    Container(
                      height: 230,
                      child: AppBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(40))),
                        backgroundColor: Colors.blueGrey,
                        elevation: 0.0,
                        title: Row(
                          children: [
                            Text(
                              AppLocalizations.getTranslated(
                                  context, 'seller_profile'), //cart
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
                  child: SpinKitCubeGrid(
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
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(40))),
                      backgroundColor: Colors.blueGrey,
                      elevation: 0.0,
                      title: Row(
                        children: [
                          Text(
                            AppLocalizations.getTranslated(
                                context, 'seller_profile'), //cart
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
                child: Text(AppLocalizations.getTranslated(context, 'NoData')),
              ),
            ),
          );
        },
      ),
    );
  }

  void openMap(String long, String lat) async {
    String url =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long'; //35.5266725,35.8053569';//$lat,$long';
    if (await canLaunch(url))
      await launch(url);
    else
      print('couldnot luanch! ');
  }
}
