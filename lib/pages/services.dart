//@dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/models/service.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List services = [
    Service(1, 'Visa application for expatriates', 'Royal Oman Police',
        Icons.payment),
    Service(2, 'Notification of the status of the visa application',
        'Royal Oman Police', Icons.notifications),
    Service(3, 'Alert about the expiration of the expatriate card',
        'Royal Oman Police', Icons.error),
    Service(4, 'Resident card renewal request', 'Royal Oman Police',
        Icons.redo_rounded),
    Service(5, 'Updating the company profile', 'SMEs Development Authority',
        Icons.update),
    Service(6, 'Initiatives', 'SMEs Development Authority',
        Icons.miscellaneous_services_rounded),
    Service(7, 'Registering a new establishment', 'SMEs Development Authority',
        Icons.app_registration_outlined),
    Service(8, 'Inquiry about the Entrepreneurship Card',
        'SMEs Development Authority', Icons.credit_card_sharp),
    Service(9, 'Entrepreneurship card application',
        'SMEs Development Authority', Icons.credit_card_sharp),
    Service(10, 'Tenders', 'SMEs Development Authority',
        Icons.miscellaneous_services_rounded),
    Service(
        11, 'Right to use land', 'SMEs Development Authority', Icons.copyright),
    Service(12, 'Request a new worker', 'Ministry of Labor',
        Icons.request_page_rounded),
    Service(13, 'Updating the workers data', 'Ministry of Labor',
        Icons.info_outline_rounded),
    Service(14, "Renewing a worker's license", 'Ministry of Labor',
        Icons.redo_rounded),
    Service(15, 'Transfer of manpower services', 'Ministry of Labor',
        Icons.miscellaneous_services),
  ];

  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  SharedPreferences prefs;
  bool searching = false;
  final TextEditingController _searchControl = new TextEditingController();
  List<Service> searchList = [];

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
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25, right: 8.0, left: 8.0),
                        child: IconButton(
                          onPressed: _handleMenuButtonPressed,
                          icon: ValueListenableBuilder<AdvancedDrawerValue>(
                            valueListenable: _advancedDrawerController,
                            builder: (_, value, __) {
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                child: value.visible
                                    ? Icon(
                                        Icons.clear,
                                        key: ValueKey<bool>(value.visible),
                                      )
                                    : SvgPicture.asset(
                                        "assets/svg/menu.svg",
                                        width: 12.0,
                                        height: 12.0,
                                        key: ValueKey<bool>(value.visible),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: searching,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30, right: 8.0, left: 8.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                onChanged: (value) {
                                  searchList.clear();
                                  for (int i = 0; i < services.length; i++) {
                                    Service service = services[i];
                                    if (service.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        service.from
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                      searchList.add(service);
                                  }
                                  setState(() {});
                                },
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blueGrey[300],
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "بحث",
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.blueGrey[300],
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searching = false;
                                      });
                                    },
                                    icon: Icon(Icons.clear),
                                    color: Colors.blueGrey[300],
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.blueGrey[300],
                                  ),
                                ),
                                maxLines: 1,
                                controller: _searchControl,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(visible: !searching, child: Spacer()),
                      Visibility(
                        visible: !searching,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 8.0, left: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                searching = true;
                              });
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !searching,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 8.0, left: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.sort),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            searchList.clear();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              '    All   ',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Constants.primaryColor,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            searchList.clear();
                                            for (int i = 0;
                                                i < services.length;
                                                i++) {
                                              Service service = services[i];
                                              if (service.from.contains(
                                                  'Royal Oman Police'))
                                                searchList.add(service);
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Royal Oman Police',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Constants.primaryColor,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            searchList.clear();
                                            for (int i = 0;
                                                i < services.length;
                                                i++) {
                                              Service service = services[i];
                                              if (service.from.contains(
                                                  'SMEs Development Authority'))
                                                searchList.add(service);
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'SMEs Development Authority',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Constants.primaryColor,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            searchList.clear();
                                            for (int i = 0;
                                                i < services.length;
                                                i++) {
                                              Service service = services[i];
                                              if (service.from.contains(
                                                  'Ministry of Labor'))
                                                searchList.add(service);
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Ministry of Labor',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.getTranslated(context, 'services'),
                    style: TextStyle(
                      height: 2.5,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  searchList.length != 0 || _searchControl.text.isNotEmpty
                      ? ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return serviceItem(searchList[index]);
                          },
                        )
                      : ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return serviceItem(services[index]);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        drawer: MainDrawer());
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget serviceItem(Service service) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              service.icon,
              color: Colors.blueGrey,
            ),
            title: Text(service.name),
          ),
        ),
        children: [
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text(
              AppLocalizations.getTranslated(context, 'from'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(service.from),
          ),
          InkWell(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), topRight: Radius.circular(30)),
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                shape: BoxShape.rectangle,
                color: Constants.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.white,
                        size: 30,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
