import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get_storage/get_storage.dart';

bool isloading = false;

class NoConnection extends StatefulWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  NoConnectionState createState() => NoConnectionState();
}

class NoConnectionState extends State<NoConnection> {
 

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FadeInUp(child: Image.asset('assets/images/no-connection.gif')),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  FadeInRight(
                    child: const Text(
                      "Ooops! 😓",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FadeInLeft(
                    child: const Text(
                      "No internet connection found. Check your connection or try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  FadeInDown(
                    child: isloading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: () async {
                              Connectivity()
                                  .checkConnectivity()
                                  .then((subscription) {
                                setState(() {
                                  isloading = true;
                                });
                                if (subscription == ConnectivityResult.mobile) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.wifi) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.bluetooth) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.ethernet) {
                                  Get.back();
                                } else {
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              }).then((value){
                                setState(() {
                                    isloading = false;
                                });
                              });
                            },
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.blueAccent,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Ionicons.refresh_circle_outline,color:Colors.white),
                                  Text("Try Again",
                                      style: TextStyle(fontSize: 20,color:Colors.white))
                                ]),
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
