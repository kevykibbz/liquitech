import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:liquitech/product.dart';

class FuelPage extends StatefulWidget {
  final String countyId;
  final String stationId;
  const FuelPage({Key? key, required this.countyId,required this.stationId}) : super(key: key);

  @override
  FuelPageState createState() => FuelPageState();
}

class FuelPageState extends State<FuelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [Color(0xff2196f3), Color(0xff42a5f5)],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Waiting for fueling...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      fontFamily: 'kids_club',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 10000,
                    radius: 100,
                    lineWidth: 20,
                    center: const Text("80%", 
                        style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        fontFamily: 'kids_club',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    percent: 0.8,
                    progressColor: Colors.white,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    circularStrokeCap: CircularStrokeCap.round,
                    footer: Padding(
                      padding:const EdgeInsets.symmetric(vertical:12.0),
                      child:FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          // Get.to(() => ProductScreen(
                          //       countyId: widget.countyId,
                          //       stationId:widget.stationId,
                          //     ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Awaiting payment verfication..."),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.power_settings_new,
                          color:Colors.blue
                        ))
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "All rights Reserved.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 12.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
