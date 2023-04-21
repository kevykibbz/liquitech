import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/auth/signup.dart';
import 'package:liquitech/auth/social.dart';
import 'package:liquitech/config/config.dart';
import 'package:liquitech/exceptions/firebaseauth.dart';
import 'package:liquitech/my_functions/bottom_modal.dart';
import '../components/custombtn.dart';
import '../components/inputField.dart';
import 'package:provider/provider.dart';

bool isloading = false;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool remember = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 5,
        title: const Text(MyConfig.appName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            size: 20,
            progress: ProxyAnimation(),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeInLeft(
                          delay: const Duration(milliseconds: 200),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInRight(
                          delay: const Duration(milliseconds: 200),
                          child: const Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Form(
                      key: _loginFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            FadeInRight(
                              delay: const Duration(milliseconds: 200),
                              child: BuildTextInputField(
                                label: 'Email',
                                controller: _emailController,
                                icon: Ionicons.mail_outline,
                                validatorName: 'email',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 200),
                              child: BuildTextInputField(
                                label: 'Password',
                                controller: _passwordController,
                                icon: Ionicons.lock_closed_outline,
                                isLogin: true,
                                isPasswordType: true,
                                validatorName: 'password',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: isloading
                          ? const CircularProgressIndicator()
                          : FadeInUp(
                              delay: const Duration(milliseconds: 200),
                              child: CustomBtn(
                                label: 'Login',
                                icon: Ionicons.log_in_outline,
                                onPressed: () {
                                  if (_loginFormKey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    AuthRepository.instance
                                        .loginUserWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text)
                                        .then((value) {
                                      setState(() {
                                        isloading = false;
                                      });
                                    }).onError((error, stackTrace) {
                                      setState(() {
                                        isloading = false;
                                      });
                                      Get.snackbar("Error", error.toString(),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.redAccent.withOpacity(0.1),
                                          colorText: Colors.red);
                                    });
                                  }
                                },
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: remember,
                              onChanged: ((value) {
                                setState(() {
                                  remember = value!;
                                });
                              }),
                            ),
                            const Text('Remember me'),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  ForgetPasswordScreen
                                      .buildShowBottomSheetModal(context);
                                },
                                child: const Text(
                                  'Forgotten password',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // IconButton(
                            //   onPressed: () async {
                            //     final isAuthenticated =
                            //         await LocalAuthApi.authenticate();
                            //     if (isAuthenticated) {
                            //       // ignore: use_build_context_synchronously
                            //       Navigator.of(context).pushReplacement(
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const HomePage()));
                            //     }
                            //   },
                            //   icon: Container(
                            //     padding: const EdgeInsets.all(10),
                            //     width: 40,
                            //     height: 40,
                            //     decoration: BoxDecoration(
                            //         color: Colors.grey.shade200,
                            //         shape: BoxShape.circle),
                            //     child: SvgPicture.asset(
                            //         'assets/images/fingerprint-fill-svgrepo-com.svg'),
                            //   ),
                            // ),
                            IconButton(
                              onPressed: () {
                                facebookLogin();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(10),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(
                                    'assets/images/facebook-svgrepo-com.svg'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.googleLogin();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(10),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(
                                    'assets/images/google-plus-svgrepo-com.svg'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                twitterLogin();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(10),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(
                                    'assets/images/twitter-svgrepo-com.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Dont have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const SignupPage())));
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                )),
                          ],
                        ),
                      ),
                    ),
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
