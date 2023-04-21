import 'package:flutter/material.dart';
import "package:get/get.dart";


class ProfileUpdateController extends GetxController {
  static ProfileUpdateController get instance => Get.find();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cardNo = TextEditingController();

}