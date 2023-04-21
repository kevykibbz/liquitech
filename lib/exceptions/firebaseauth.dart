// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquitech/config/config.dart';
import 'package:liquitech/dashboard.dart';
import 'package:liquitech/models/profile_model.dart';
import 'package:liquitech/models/users_model.dart';
import 'package:liquitech/snackbar/snakbar.dart';
import '../junction.dart';
import 'exceptions.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  final _firestoreInstance = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const JunctionView())
        : Get.offAll(() => const DashboardPage());
  }

  //sign up
  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((userCredential) async {
        await userCredential.user?.updateDisplayName(user.fullName);
        await userCredential.user?.updatePhotoURL(MyConfig.photoURI);
        await FirebaseFirestore.instance
            .collection('/users')
            .doc(userCredential.user?.uid)
            .set(user.toJson())
            .then((value) {
          CreateSnackBar.buildSuccessSnackbar(
              "Success", "Account created successfully.");
        });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(ex);
      throw ex;
    }
  }

  //login
  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const DashboardPage())
          : Get.to(() => const JunctionView());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(ex);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(ex);
      throw ex;
    }
  }

  //check email address
  Future<bool> checkEmailAddress(String email) async {
    final list = await _auth.fetchSignInMethodsForEmail(email);
    try {
      if (list.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        Get.back();
        return true;
      } else {
        Get.snackbar("Error.", "Email not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(ex);
      return false;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(ex);
      return false;
    }
  }

  //check phone
  Future<bool> checkPhoneNumber(String phone) async {
    final list = await _auth.fetchSignInMethodsForEmail(phone);
    try {
      if (list.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: phone);
        Get.back();
        return true;
      } else {
        Get.snackbar("Error.", "Phone number not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(ex);
      return false;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(ex);
      return false;
    }
  }

  //logout
  Future<void> logout() async => await _auth.signOut();

  //check county
  Future<void> addCounty({required String countyName}) async {
    await _firestoreInstance.collection("counties").doc('kkk').get();
  }

  Future<void> updateUser(ProfileModel user) async {
    try {
      await _auth.currentUser!.updateDisplayName(user.fullName);
      await _auth.currentUser!.updateEmail(user.email);
      await FirebaseFirestore.instance
            .collection('/users')
            .doc(_auth.currentUser!.uid)
            .update(user.toJson())
            .then((value) {
              CreateSnackBar.buildSuccessSnackbar("Success", "Profile infomation updated successfully.");
        });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(ex);
      throw ex;
    }
  }
}
