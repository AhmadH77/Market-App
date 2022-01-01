//@dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/process/DBProvider.dart';
import 'package:market_app/process/payment.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/CustomToast.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartPage extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<CartPage> {
  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  SharedPreferences prefs;
  var total;
  bool isExtend = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            AppLocalizations.getTranslated(context, 'cart'), //cart
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: FutureBuilder<List>(
                future: DBProvider.db.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.length != 0) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return serviceItem(snapshot.data[index]);
                      },
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return SpinKitCubeGrid(
                      color: Constants.primaryColor,
                    );
                  return Align(
                    alignment: Alignment.center,
                    child: Text('Your Cart is Empty!'),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: isExtend
            ? FloatingActionButton.extended(
                onPressed: () async {
                  var calcTotal = await DBProvider.db.calculateTotal();
                  if (calcTotal[0]['Total'] != null &&
                      calcTotal[0]['Total'] > 0) {
                    print('test total ${calcTotal[0]['Total'] >= 0}');
                    double total = calcTotal[0]['Total'];
                    var response = await StripeServices.payNowHandler(
                        amount: '${total.toInt()}', currency: 'USD');
                    print('response message ${response.message}');
                    if (response.message == 'Transaction succeful') {
                      await DBProvider.db.emptyCart();
                      total = 0;
                      isExtend = false;
                      setState(() {});
                      showToastWidget(
                          BannerToastWidget.success(
                              msg: AppLocalizations.getTranslated(
                                  context, 'success')),
                          context: context,
                          animation: StyledToastAnimation.slideFromTop,
                          // reverseAnimation: StyledToastAnimation.slideToTop,
                          position: StyledToastPosition.top,
                          animDuration: Duration(seconds: 1),
                          duration: Duration(seconds: 4),
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.fastOutSlowIn);
                    } else {
                      showToastWidget(
                          BannerToastWidget.fail(
                              msg: AppLocalizations.getTranslated(
                                  context, 'somethingWrong')),
                          context: context,
                          animation: StyledToastAnimation.slideFromTop,
                          // reverseAnimation: StyledToastAnimation.slideToTop,
                          position: StyledToastPosition.top,
                          animDuration: Duration(seconds: 1),
                          duration: Duration(seconds: 4),
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.fastOutSlowIn);
                    }
                  } else {
                    showToastWidget(
                        BannerToastWidget.fail(
                            msg: AppLocalizations.getTranslated(
                                context, 'cartEmpty')),
                        context: context,
                        animation: StyledToastAnimation.slideFromTop,
                        position: StyledToastPosition.top,
                        animDuration: Duration(seconds: 1),
                        duration: Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.fastOutSlowIn);
                  }
                },
                icon: Icon(Icons.payment),
                label: Text(
                  '$total',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ))
            : FloatingActionButton(
                elevation: 10,
                child: Icon(Icons.payment),
                onPressed: () async {
                  var calcTotal = await DBProvider.db.calculateTotal();
                  setState(() {
                    total = calcTotal[0]['Total'];
                    isExtend = true;
                  });
                },
              ),
      ),
      drawer: MainDrawer(),
    );
  }

  Widget serviceItem(product) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              product['image'],
              fit: BoxFit.fill,
            ),
            title: Text(product['name']),
          ),
        ),
        children: [
          ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text(
              product['description'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text('${product['category']}'),
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
                    child: Text(
                      'ر.ع ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${product['price']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
