//@dart=2.9
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/pages/watch_details.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/addProductDialog.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:market_app/main.dart';
import 'package:market_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  SharedPreferences prefs;
  bool searching = false, sorting = false;
  final TextEditingController _searchControl = new TextEditingController();
  List searchList = [], products = [], categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      categories = [
        AppLocalizations.getTranslated(context, 'category1'),
        AppLocalizations.getTranslated(context, 'category2'),
        AppLocalizations.getTranslated(context, 'category3'),
        AppLocalizations.getTranslated(context, 'category4'),
        AppLocalizations.getTranslated(context, 'category5'),
        AppLocalizations.getTranslated(context, 'category6'),
        AppLocalizations.getTranslated(context, 'category7'),
      ];
      prefs = await SharedPreferences.getInstance();

      products = (prefs != null && prefs.get('user_type') == 'buyer')
          ? await APICalls(context).getProduct()
          : await APICalls(context).getSellerProduct();
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categories = [
      AppLocalizations.getTranslated(context, 'category1'),
      AppLocalizations.getTranslated(context, 'category2'),
      AppLocalizations.getTranslated(context, 'category3'),
      AppLocalizations.getTranslated(context, 'category4'),
      AppLocalizations.getTranslated(context, 'category5'),
      AppLocalizations.getTranslated(context, 'category6'),
      AppLocalizations.getTranslated(context, 'category7'),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
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
                      Visibility(
                        visible: searching,
                        child: Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              onChanged: (value) {
                                searchList.clear();
                                for (int i = 0; i < products.length; i++) {
                                  Product product = products[i];
                                  if (product.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                    searchList.add(product);
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
                      Visibility(visible: !searching, child: Spacer()),
                      Visibility(
                        visible: !searching,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              searching = true;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: !searching,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          searchList.clear();
                                          sorting = false;
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
                                            AppLocalizations.getTranslated(
                                                context, 'all'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Constants.primaryColor,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: categories.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    sorting = true;
                                                    searchList.clear();
                                                    for (int i = 0;
                                                        i < products.length;
                                                        i++) {
                                                      Product product =
                                                          products[i];
                                                      if (product.category
                                                          .contains(categories[
                                                              index]))
                                                        searchList.add(product);
                                                      print(
                                                          '${product.category} --- ${categories[index]} -- ${searchList.length} ');
                                                    }

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      categories[index],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Constants.primaryColor,
                                                ),
                                              ],
                                            );
                                          },
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      prefs != null && prefs.get('user_type') == 'seller'
                          ? AppLocalizations.getTranslated(
                              context, 'my_products')
                          : AppLocalizations.getTranslated(context, 'products'),
                      style: TextStyle(
                        height: 2.5,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  products != null
                      ? (searchList.length != 0 ||
                              _searchControl.text.isNotEmpty
                          ? StaggeredGridView.countBuilder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              itemCount: searchList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ZoomIn(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return WatchDetails(
                                            watch: searchList[index],
                                            tag: "watch-$index",
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, top: 15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Hero(
                                                tag: "watch-$index",
                                                child: Image.network(
                                                    searchList[index].image)),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    searchList[index].name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Constants
                                                            .primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    child: Text(
                                                      searchList[index].brand !=
                                                              null
                                                          ? searchList[index]
                                                              .brand
                                                          : searchList[index]
                                                              .model,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Constants.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    40),
                                                            bottomRight: Radius
                                                                .circular(8))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.getTranslated(
                                                            context, 'currency'),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                      FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            ' ${searchList[index].price}',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 3 : 2),
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            )
                          : (sorting && searchList.length == 0
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child:
                                        Text("No products for this category !"),
                                  ),
                                )
                              : StaggeredGridView.countBuilder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  itemCount: products.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          ZoomIn(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return WatchDetails(
                                                watch: products[index],
                                                tag: "watch-$index",
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15.0, top: 15.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Hero(
                                                    tag: "watch-$index",
                                                    child: Image.network(
                                                        products[index].image)),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        child: Text(
                                                          products[index].name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Constants
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3.0,
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        child: Text(
                                                          products[index]
                                                                      .brand !=
                                                                  null
                                                              ? products[index]
                                                                  .brand
                                                              : products[index]
                                                                  .model,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .blueGrey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    decoration: BoxDecoration(
                                                        color: Constants
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        40),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.getTranslated(
                                                                context, 'currency'),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blueGrey),
                                                          ),
                                                          FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Text(
                                                                ' ${products[index].price}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.count(
                                          2, index.isEven ? 3 : 2),
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                )))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(prefs != null &&
                                    prefs.get('user_type') == 'buyer'
                                ? "No Data Found!"
                                : "You don't have products!"),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton:
            (prefs != null && prefs.get('user_type') == 'seller')
                ? FloatingActionButton(
                    backgroundColor: Constants.primaryColor,
                    child: Icon(Icons.add),
                    onPressed: () {
                      // showAddProductDialog();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return AddProduct();
                          },
                        ),
                      );
                    },
                  )
                : SizedBox(),
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
