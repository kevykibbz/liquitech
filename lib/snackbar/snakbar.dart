import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquitech/exceptions/exceptions.dart';

class CreateSnackBar{

  //error snackbar
  static SnackbarController buildErrorSnackbar(SignUpWithEmailAndPasswordFailure ex) {
    return Get.snackbar("Error.", ex.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
  }

  //succcess
  static SnackbarController buildSuccessSnackbar(String title,String message) {
    return Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        colorText: Colors.green);
  }

  //error
  static SnackbarController buildCustomErrorSnackbar(String title,String message) {
    return Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
  }
}