import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import '../models/users_model.dart';
import '../auth/otp.dart';


class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection('Users').add(user.toJson()).whenComplete(() {
      Get.snackbar("Success",
          "Your account has  been created.Verification email has been send to $userEmail ",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
          Get.to(() => const OtpScreen());
    }).catchError((error, stacktrace) {
      Get.snackbar("Error", "Something went wrong.Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    });
  }
}
