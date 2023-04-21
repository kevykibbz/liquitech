import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/auth/fingerprint.dart';
import 'package:liquitech/components/custombtn.dart';
import 'package:liquitech/components/inputField.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquitech/mpesa/mpesa.dart';
import 'package:liquitech/snackbar/snakbar.dart';

bool isLoading = false;

class PaymentScreen extends StatefulWidget {
  final String countyId;
  final String stationId;
  final String productId;
  final String paymentType;
  const PaymentScreen(
      {Key? key,
      required this.countyId,
      required this.stationId,
      required this.paymentType,
      required this.productId})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final paymentFormKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  double price = 0.0;
  String product = '';

  @override
  initState() {
    FirebaseFirestore.instance
        .collection("/users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var dataRef = snapshot.data() as Map;
      phoneController.text = dataRef['Phone'].toString();
    });
    FirebaseFirestore.instance
        .collection("counties")
        .doc(widget.countyId)
        .collection("stations")
        .doc(widget.stationId)
        .collection("products")
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot snapshot) {
      var data = snapshot.data() as Map;
      setState(() {
        product = data["ProductName"];
        price = data["Price"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm payment.'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png',
                fit: BoxFit.cover,
                width: 150,
              ),
              FadeInDown(
                child: const Text(
                  "MPesa payment",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FadeInDown(
                child: const Text(
                  "Please confirm the phone number and then input amount to pay.Thank you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue.withOpacity(0.1)),
                ),
                leading: CircleAvatar(
                    child: Text(
                        product.isNotEmpty ? product[0].toUpperCase() : '')),
                title: Text(product),
                dense: false,
                trailing: Text(
                  "Ksh $price/ltr",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeInDown(
                child: Form(
                  key: paymentFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      FadeInDown(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.13)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  //phoneText=number.phoneNumber.toString().split("+").last;
                                },
                                onInputValidated: (bool value) {
                                  //phoneController.text=phoneText;
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    const TextStyle(color: Colors.blueAccent),
                                textFieldController: phoneController,
                                formatInput: false,
                                maxLength: 9,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                cursorColor: Colors.blueAccent,
                                inputDecoration: InputDecoration(
                                  label: const Text("Phone number"),
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 15, left: 0),
                                  border: InputBorder.none,
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16),
                                ),
                                // onSaved: (PhoneNumber number) {
                                //   print('On Saved: $number');
                                // },
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
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInDown(
                        child: BuildTextInputField(
                          label: 'Amount',
                          numberValidator: price,
                          controller: amountController,
                          icon: Icons.money_off_csred_outlined,
                          isNumber: true,
                          validatorName: 'amount',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : CustomBtn(
                        label: ' Submit',
                        icon: Ionicons.enter_outline,
                        onPressed: ()  async{
                          if (paymentFormKey.currentState!.validate()) {
                            final isAuthenticated =await LocalAuthApi.authenticate();
                            if (isAuthenticated) {
                                MpesaManager().startCheckout(
                                  userPhone: "254${phoneController.text}",
                                  countyId:widget.countyId,
                                  paymentType:widget.paymentType,
                                  productId:widget.productId,
                                  stationId:widget.stationId,
                                  amount:double.parse(amountController.text.trim()));
                            }else{
                              CreateSnackBar.buildCustomErrorSnackbar("Error", "Failed to authenticate.");
                            }
                          }
                        },
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'All rights reserved',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'Devme.',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
