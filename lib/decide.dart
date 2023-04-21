import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquitech/config/config.dart';
import 'package:get/get.dart';
import 'package:liquitech/map.dart';
import 'package:liquitech/fuel.dart';

class DecisionScreen extends StatefulWidget {
  final String countyId;
  final String stationId;
  const DecisionScreen({
    super.key,
    required this.countyId,
    required this.stationId
  });

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select option"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          elevation: 0,
        ),
        body: getBody(widget.stationId,widget.countyId),
      ),
    );
  }

  Widget getBody(stationId,countyId) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInLeftBig(
            child: const Text(
              "Select your next destination",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeftBig(
              child: const Text(
            "Where do you wish to go next? View maps for station guiding or head straight to fuel injection.",
          )),
          const Spacer(),
          Row(
            children: [
              FadeInLeftBig(
                child: Hero(
                  tag: "reject_btn",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 60,
                    padding: const EdgeInsets.only(left: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>const MapsScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: MyConfig.color,
                        shape: const StadiumBorder(),
                        disabledBackgroundColor: Colors.grey,
                        maximumSize: const Size(double.infinity, 56),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text("VIEW MAPS"),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              FadeInRightBig(
                child: Hero(
                  tag: "accept_btn",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 60,
                    padding: const EdgeInsets.only(left: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>FuelPage(stationId:stationId,countyId:countyId));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: MyConfig.color,
                        shape: const StadiumBorder(),
                        disabledBackgroundColor: Colors.grey,
                        maximumSize: const Size(double.infinity, 56),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text("FUELLING"),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
