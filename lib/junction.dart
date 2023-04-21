import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/components/custombtn.dart';
import 'package:liquitech/config/config.dart';
import 'package:liquitech/home.dart';
import "package:get/get.dart";
import 'package:animate_do/animate_do.dart';


class JunctionView extends StatefulWidget {
  const JunctionView({super.key});

  @override
  State<JunctionView> createState() => _JunctionViewState();
}

class _JunctionViewState extends State<JunctionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
                // even space distribution
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInRight(
                        delay: const Duration(milliseconds: 200),
                        child: const Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontFamily: 'kids_club',
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInLeft(
                        delay: const Duration(milliseconds: 200),
                        child: const Text(
                          MyConfig.welcomeText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/welcome.png"))),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: CustomBtn(
                          label: 'Login',
                          icon: Ionicons.log_in_outline,
                          onPressed: () {
                            Get.to(() => const HomePage());
                          },
                        ),
                      ),
                    ],
                  ),
                ],),
          ),
        ),
      ),
    );
  }
}
