// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquitech/profile.dart';
import 'package:liquitech/counties.dart';
import 'package:liquitech/Notifications/notification.dart';
import 'package:liquitech/settings.dart';
import 'package:liquitech/mixins/shutdown.dart';
import 'package:ionicons/ionicons.dart';
import 'package:badges/badges.dart' as badges;

final user = FirebaseAuth.instance.currentUser!;
bool isloading = false;
bool isNotified = false;
int total = 0;
var currentIndex = 0;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AppCloser {
  List<String> querySearch = ["", "f", "fa", "fal", "fals", "false"];
  List<Widget> screens = [
    const CountiesList(),
    const SettingsPage(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .where('IsRead', isEqualTo: false)
        .where(user.uid, isEqualTo: true)
        .get()
        .then((value) {
      setState(() {
        total = value.size;
        isNotified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return WillPopScope(
        child: Scaffold(
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(displayWidth * .05),
            height: displayWidth * .155,
            decoration: BoxDecoration(
              //color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: screens.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                    HapticFeedback.lightImpact();
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentIndex
                          ? displayWidth * .32
                          : displayWidth * .18,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == currentIndex ? displayWidth * .12 : 0,
                        width: index == currentIndex ? displayWidth * .32 : 0,
                        decoration: BoxDecoration(
                          color: index == currentIndex
                              ? Colors.blueAccent.withOpacity(.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentIndex
                          ? displayWidth * .31
                          : displayWidth * .18,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentIndex
                                    ? displayWidth * .13
                                    : 0,
                              ),
                              AnimatedOpacity(
                                opacity: index == currentIndex ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == currentIndex
                                      ? listOfStrings[index]
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentIndex
                                    ? displayWidth * .03
                                    : 20,
                              ),
                              (index == 2 && isNotified)
                                  ? badges.Badge(
                                      position: badges.BadgePosition.topEnd(
                                          top: -10, end: -12),
                                      showBadge: true,
                                      ignorePointer: false,
                                      badgeContent: Text(total.toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      badgeStyle: badges.BadgeStyle(
                                          elevation: 2,
                                          badgeColor: Colors.redAccent,
                                          shape: badges.BadgeShape.circle,
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              width: 2),
                                          borderGradient:
                                              const badges.BadgeGradient.linear(
                                                  colors: [
                                                Color(0xff2196f3),
                                                Color(0xff42a5f5)
                                              ]),
                                          badgeGradient:
                                              const badges.BadgeGradient.linear(
                                                  colors: [
                                                Color(0xff2196f3),
                                                Color(0xff42a5f5)
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                      child: Icon(
                                        listOfIcons[index],
                                        size: displayWidth * .076,
                                        color: index == currentIndex
                                            ? Colors.blueAccent
                                            : (isDarkMode
                                                ? Colors.grey
                                                : Colors.black26),
                                      ),
                                    )
                                  : Icon(
                                      listOfIcons[index],
                                      size: displayWidth * .076,
                                      color: index == currentIndex
                                          ? Colors.blueAccent
                                          : (isDarkMode
                                              ? Colors.grey
                                              : Colors.black26),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: screens[currentIndex],
        ),
        onWillPop: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 20,
                            color: Colors.blue,
                          ),
                          Expanded(child: Text("Warning")),
                        ]),
                    content: const Text('Do you wish to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          closeApp();
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No')),
                    ]);
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        });
  }

  List<IconData> listOfIcons = [
    Ionicons.home_outline,
    Ionicons.settings,
    Ionicons.notifications_outline,
    Ionicons.person_outline,
  ];

  List<String> listOfStrings = [
    'Home',
    'Settings',
    'Inbox',
    'Profile',
  ];
}
