import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/components/custombtn.dart';
import 'package:liquitech/components/inputField.dart';
import 'package:liquitech/exceptions/firebaseauth.dart';

bool isLoading = false;

class EmailResetPassword extends StatefulWidget {
  const EmailResetPassword({ Key? key }) : super(key: key);

  @override
  EmailResetPasswordState createState() => EmailResetPasswordState();
}

class EmailResetPasswordState extends State<EmailResetPassword> {
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network('https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png', fit: BoxFit.cover, width: 280, ),
              FadeInDown(
                child: const Text(
                  "Password Reset",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10,),
              FadeInDown(
                child: const Text(
                  "Enter your email address to reset your password of your account",
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FadeInDown(
                child: Form(
                  key: _resetPasswordFormKey,
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      BuildTextInputField(
                        label: 'Email',
                        controller: _emailController,
                        icon: Ionicons.mail_open_outline,
                        validatorName: 'email',
                      ),
                    ],
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child:isLoading 
                  ? const CircularProgressIndicator()
                  :CustomBtn(
                    label: ' Submit',
                    icon: Ionicons.enter_outline,
                    onPressed: () async{
                     if (_resetPasswordFormKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthRepository.instance.checkEmailAddress(_emailController.text.trim()).then((value){
                        setState(() {
                          isLoading = false;
                          }); 
                        });
                      } 
                    },
                  ),
              )
          ],)
        ),
      )
    );
  }
}
