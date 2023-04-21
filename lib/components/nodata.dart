import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_storage/get_storage.dart';


class Nodata extends StatelessWidget {
  final String message;
  const Nodata({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      FadeInUp(child: Image.asset('assets/images/no-connection.gif')),
      const SizedBox(
        height: 15,
      ),
      FadeInRight(
        child: Text(
          "Ooops! 😓",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      FadeInLeft(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(
        height: 40,
      ),
    ]));
  }
}