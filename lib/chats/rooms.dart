import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/chats/util.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../main.dart';
import 'chat.dart';
import 'package:market_app/pages/auth/loginPage.dart';


class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected=[];
  SharedPreferences? prefs;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    Future.delayed(Duration.zero,() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {

      });
    });
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.white;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }


    if(AppLocalizations.of(context).locale.languageCode.toUpperCase()=="EN")
      setState(() {
        isSelected=[true,false];
      });
    else
      setState(() {
        isSelected=[false,true];
      });

    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: (AppLocalizations.of(context).locale.languageCode.toUpperCase()=="EN") ? false : true,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.add),
          //     onPressed: _user == null
          //         ? null
          //         : () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 fullscreenDialog: true,
          //                 builder: (context) => const UsersPage(),
          //               ),
          //             );
          //           },
          //   ),
          // ],
          brightness: Brightness.dark,
          // leading: IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: _user == null ? null : logout,
          // ),
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
               Text(AppLocalizations.getTranslated(context, 'chats') ,  style: TextStyle(
                height: 2.5,
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),),
            ],
          ),
        ),
        body: _user == null
            ? Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.getTranslated(context, 'account_error')),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>  Login(),
                          ),
                        );
                      },
                      child:  Text(AppLocalizations.getTranslated(context, 'login')),
                    ),
                  ],
                ),
              )
            : StreamBuilder<List<types.Room>>(
                stream: FirebaseChatCore.instance.rooms(),
                initialData: const [],
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                      ),
                      child: const Text('No rooms'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final room = snapshot.data![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                room: room,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PhysicalModel(

                            color: Colors.transparent,
                            elevation: 10,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(30) ),
                            // shadowColor: Colors.white,
                            child: Container(

                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(30) ),

                              ),
                              child: Row(
                                children: [
                                  _buildAvatar(room),
                                  Text(room.name ?? ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      drawer: MainDrawer()
    );
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await Constants().setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
