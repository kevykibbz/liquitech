import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:liquitech/controllers/signup_controllers.dart';
import 'package:liquitech/exceptions/firebaseauth.dart';
import 'package:liquitech/models/profile_model.dart';
import 'components/inputField.dart';
import 'package:liquitech/components/customIcon.dart';
import 'package:animate_do/animate_do.dart';
import '../components/custombtn.dart';
import "dart:io";
import 'package:liquitech/snackbar/snakbar.dart';

bool isloading = false;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final updateFormKey = GlobalKey<FormState>();
    final controller = Get.put(SignUpController());
    FirebaseFirestore.instance
        .collection("/users")
        .doc(user.uid)
        .get()
        .then((value) {
      var data = value.data() as Map;
      controller.fullNameController.text = data['FullName'];
      controller.emailController.text = data['Email'];
      controller.phoneController.text = "0${data['Phone']}";
    });

    Future<void> imageSelector() async {
      final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth:2000,
          maxHeight: 2000,
          imageQuality: 75);
      Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");
      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) async{
       await user.updatePhotoURL(value);
       FirebaseFirestore.instance.collection("/users").doc(user.uid).update({"PhotoURI":value}).then((value){
          CreateSnackBar.buildSuccessSnackbar("Success", "Profile pic updated successfully.");
       });
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Icon(
                Icons.edit,
                size: 20,
              ),
              Expanded(child: Text(" Update Profile")),
            ]),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: <Widget>[
            FadeInUp(
              child: Stack(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 2,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ]),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: user.photoURL!,
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          color: Colors.blue),
                      child: GestureDetector(
                          onTap: () {
                            imageSelector();
                          },
                          child: Icon(Ionicons.camera_outline,
                              color: Colors.white, size: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Text("Edit details", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              height: 10.0,
            ),
            Form(
              key: updateFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: <Widget>[
                FadeInUp(
                  child: BuildTextInputField(
                    label: 'Full name',
                    controller: controller.fullNameController,
                    icon: Icons.person_add_alt,
                    validatorName: 'username',
                  ),
                ),
                FadeInUp(
                  child: BuildTextInputField(
                    label: 'Email',
                    controller: controller.emailController,
                    icon: Icons.email_outlined,
                    validatorName: 'email',
                  ),
                ),
                FadeInUp(
                  child: BuildTextInputField(
                    label: 'Submit card no',
                    controller: controller.cardNoController,
                    icon: Icons.card_giftcard_outlined,
                    validatorName: 'card',
                  ),
                ),
                FadeInUp(
                  child: IntlPhoneField(
                    cursorColor: Colors.blueAccent,
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                      hintText: 'Enter your phone number',
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      suffixIcon: const CustomSuffixIcon(
                          icon: Ionicons.phone_portrait_outline),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 10),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 10),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            isloading
                ? const CircularProgressIndicator()
                : FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: CustomBtn(
                      label: 'Update',
                      icon: Icons.edit,
                      onPressed: () {
                        if (updateFormKey.currentState!.validate()) {
                          final user = ProfileModel(
                            fullName: controller.fullNameController.text.trim(),
                            email: controller.emailController.text.trim(),
                            phone: int.parse(
                                controller.phoneController.text.trim()),
                            cardNo: controller.cardNoController.text.trim(),
                          );
                          AuthRepository.instance.updateUser(user);
                        }
                      },
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}
