import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquitech/success.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:liquitech/payment.dart';

class WaitingScreen extends StatefulWidget {
  final String countyId;
  final String productId;
  final String stationId;
  final String checkOutId;
  const WaitingScreen(
      {super.key,
      required this.productId,  
      required this.checkOutId,
      required this.stationId,
      required this.countyId});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final auth = FirebaseAuth.instance;
  late Timer timer;
  User? user;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkPayments();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(" Waiting for payment confirmation...")
            ]),
      ),
    );
  }

  Future<void> checkPayments() async {
    user = auth.currentUser;
    FirebaseFirestore.instance
        .collection("trasactions")
        .doc(widget.checkOutId)
        .get()
        .then((value) {
      var data = value.data() as Map;
      if(data['ResultCode'] !=null){
        timer.cancel();
        if(data['ResultCode'] == 0){
          Get.to(()=>SuccessPage(stationId: widget.stationId,countyId: widget.countyId));
        }else{
          Get.to(() => PaymentScreen(productId: widget.productId, countyId: widget.countyId, stationId: widget.stationId, paymentType:data["paymentType"],));
        }
      }
    });
  }
}
