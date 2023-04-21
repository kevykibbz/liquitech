// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquitech/config/config.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquitech/snackbar/snakbar.dart';
import 'package:get/get.dart';
import 'package:liquitech/waiting.dart';

final user = FirebaseAuth.instance.currentUser!;

class MpesaManager {
  DateTime currentDate = DateTime.now();
  String? mUserMail = user.email;

  Future<dynamic> startCheckout(
      {required String userPhone,
      required double amount,
      required String countyId,
      required String productId,
      required String paymentType,
      required String stationId}) async {
    dynamic transactionInitialisation;
    try {
      //Run it
      final callBackUri =
          Uri.https(MyConfig.mpesaCallbackUrl, MyConfig.mpesaCallbackUrlPath);
      final baseUri = Uri.https("api.safaricom.co.ke");
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: MyConfig.shortCode.toString(),
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: amount,
              partyA: userPhone,
              partyB: MyConfig.shortCode,
              callBackURL: callBackUri,
              accountReference: userPhone,
              phoneNumber: userPhone,
              baseUri: baseUri,
              transactionDesc: "Fuel Purchase.",
              passKey: MyConfig.mpesaPassKey);
      var result = transactionInitialisation as Map<String, dynamic>;
      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        if (mResponseCode == '0') {
          //request successfully accepted for processing.
          var checkOutId = result["CheckoutRequestID"];
          FirebaseFirestore.instance
              .collection("transactions")
              .doc(checkOutId)
              .set({
            "CheckoutRequestId": checkOutId,
            "userId": user.uid,
            user.uid: true,
            "PaymentType":paymentType,
            "Status": "Transaction initiated",
            "Host": "Liquitech",
            "Date Initiated": currentDate.toString(),
          }).then((value) {
            CreateSnackBar.buildSuccessSnackbar(
                "Message", result["CustomerMessage"]);
            Get.to(() => WaitingScreen(
                stationId: stationId,
                checkOutId: checkOutId,
                productId: productId,
                countyId: countyId));
          }).catchError((error) {
            CreateSnackBar.buildCustomErrorSnackbar("Error", error.toString());
          });
        } else {
          CreateSnackBar.buildCustomErrorSnackbar(
              "Error", "Unknown problem occured");
        }
      }
    } catch (e) {
      var t = e.toString();
      print("Error: $t");
    }
  }
}
