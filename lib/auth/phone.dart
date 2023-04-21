// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/components/custombtn.dart';

class PhoneResetPassword extends StatefulWidget {
  const PhoneResetPassword({ Key? key }) : super(key: key);

  @override
  PhoneResetPasswordState createState() => PhoneResetPasswordState();
}

class PhoneResetPasswordState extends State<PhoneResetPassword> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child:Column(
              children: <Widget>[
                Image.network('https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png', fit: BoxFit.cover, width: 280, ),
                const SizedBox(height:10,),
                FadeInDown(
                  child: const Text('Phone Verification', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                    child: Text('Enter your phone number to continue, we will send you OTP to verifiy.', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontSize: 14,),),
                  ),
                ),
                const SizedBox(height:20,),
                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.13)),
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(color: Colors.blueAccent),
                          textFieldController: controller,
                          formatInput: false,
                          maxLength: 9,
                          keyboardType:
                              const TextInputType.numberWithOptions(signed: true, decimal: true),
                          cursorColor: Colors.blueAccent,
                          inputDecoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                        Positioned(
                          left: 90,
                          top: 8,
                          bottom: 8,
                          child: Container(
                            height: 40,
                            width: 1,
                            color: Colors.blueAccent.withOpacity(0.13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height:50,),
                FadeInDown(
                  delay: const Duration(milliseconds: 600),
                  child: isLoading 
                  ? const CircularProgressIndicator()
                  :CustomBtn(
                    label: 'Request OTP',
                    icon: Ionicons.hand_right_outline,
                    onPressed: () {
                      
                    },
                  ),
                ),
                const SizedBox(height: 50,),
                FadeInDown(
                  delay: const Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('All rights reserved',),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                        },
                        child: const Text('Devme.', style: TextStyle(color: Colors.blueAccent),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
