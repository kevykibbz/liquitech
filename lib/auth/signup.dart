import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/auth/login.dart';
import 'package:liquitech/components/customIcon.dart';
import 'package:liquitech/exceptions/firebaseauth.dart';
import 'package:liquitech/models/users_model.dart';
import '../components/custombtn.dart';
import '../components/inputField.dart';
import '../config/config.dart';
import '../controllers/signup_controllers.dart';

bool isloading = false;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 5,
        title: const Text(MyConfig.appName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInRight(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      "Create an account, It's free ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Form(
                  key: _registerFormKey,
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      BuildTextInputField(
                        label: 'Full name',
                        controller: controller.fullNameController,
                        icon: Ionicons.person_add_outline,
                        validatorName: 'displayName',
                      ),
                      BuildTextInputField(
                        label: 'Email',
                        controller: controller.emailController,
                        icon: Ionicons.mail_outline,
                        validatorName: 'email',
                      ),
                      IntlPhoneField(
                        controller: controller.phoneController,
                        cursorColor: Colors.blueAccent,
                        initialCountryCode: '254',
                        validator: (value) {
                          if (value == null) {
                            return "Please enter your phone number";
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Phone number",
                          hintText: 'Enter your phone number',
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          suffixIcon: const CustomSuffixIcon(
                              icon: Ionicons.phone_portrait_outline),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal:10),
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
                      BuildTextInputField(
                        label: 'Password',
                        controller: controller.passwordController,
                        icon: Ionicons.lock_closed_outline,
                        isPasswordType: true,
                        validatorName: 'password',
                      ),
                    ],
                  ),
                ),
              ),
              isloading
                  ? const CircularProgressIndicator()
                  : FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: CustomBtn(
                        label: 'Signup',
                        icon: Icons.add,
                        onPressed: () {
                          if (_registerFormKey.currentState!.validate()) {
                            //firebase store
                            final user = UserModel(
                              fullName:
                                  controller.fullNameController.text.trim(),
                              email: controller.emailController.text.trim(),
                              photoUri: MyConfig.photoURI,
                              role: "Client",
                              phone: int.parse(
                                  controller.phoneController.text.trim()),
                              password:
                                  controller.passwordController.text.trim(),
                            );
                            AuthRepository.instance
                                .createUserWithEmailAndPassword(user);
                            _registerFormKey.currentState?.reset();
                          }
                        },
                      ),
                    ),
              FadeInRightBig(
                delay: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginPage())));
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
