// ignore_for_file: avoid_print

import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquitech/components/bottomsheet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:liquitech/payment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquitech/config/config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:liquitech/services/notificationService.dart';
import 'package:liquitech/snackbar/snakbar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/decide.dart';

final user = FirebaseAuth.instance.currentUser!;
bool isLoading = false;

class SelectPaymentType extends StatefulWidget {
  final String productId;
  final String stationId;
  final String countyId;
  const SelectPaymentType(
      {super.key,
      required this.countyId,
      required this.stationId,
      required this.productId});

  @override
  State<SelectPaymentType> createState() => _SelectPaymentTypeState();
}

class _SelectPaymentTypeState extends State<SelectPaymentType> {
  final editPaymentFormKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final List<String> items = [
    'Prepaid',
    'Postpaid',
  ];
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select payment type.'),
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
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInDownBig(
                      child: Image.network(
                        'https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png',
                        fit: BoxFit.cover,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInRightBig(
                        child: const Text("Select payment type.",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue))),
                    const SizedBox(height: 10),
                    FadeInLeftBig(
                        child: const Text(
                      "Please choose your preffered fuel payment type from the dropdown menu below.",
                      textAlign: TextAlign.center,
                    )),
                    const SizedBox(height: 20),
                    FadeInDownBig(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          iconStyleData: const IconStyleData(
                              iconEnabledColor: Colors.blue),
                          isDense: true,
                          barrierLabel: "Payment Type",
                          isExpanded: true,
                          hint: Text(
                            'Select payment type',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });

                            if (selectedValue != null) {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Make Selection",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                      Text(
                                          "Select one of the options given below to pay for the fuel.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      BottomSheetModal(
                                          title: 'M-PESA',
                                          content: "Pay using M-pesa.",
                                          icon: Icons.mobile_friendly_rounded,
                                          onTap: () {
                                            Get.to(() => PaymentScreen(
                                                paymentType:
                                                    selectedValue as String,
                                                productId: widget.productId,
                                                countyId: widget.countyId,
                                                stationId: widget.stationId));
                                          }),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      BottomSheetModal(
                                        title: 'Visa Card',
                                        content: "Pay using visa card",
                                        icon: Icons.card_membership_outlined,
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text("Enter amount"),
                                              content: Form(
                                                key: editPaymentFormKey,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                child: TextFormField(
                                                  controller: amountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: Colors.blue,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Fuel amount is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Amount(USD)',
                                                    hintText:
                                                        'Enter amount in USD',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    prefixIcon: Icon(
                                                        Ionicons.build_outline),
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Ok'),
                                                  onPressed: () async {
                                                    if (editPaymentFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      Get.back(
                                                          closeOverlays: true);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      await makeStripePayment(
                                                        context,
                                                        countyId:
                                                            widget.countyId,
                                                        productId:
                                                            widget.productId,
                                                        stationId: int.parse(
                                                            widget.stationId),
                                                        amountPaid:
                                                            amountController
                                                                .text,
                                                      ).then((_) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      }).catchError((_) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      });
                                                      amountController.text =
                                                          "";
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 40,
                            width: 200,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                expands: true,
                                cursorColor: Colors.blue,
                                enableSuggestions: true,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return (item.value
                                  .toString()
                                  .contains(searchValue));
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Future<void> makeStripePayment(context,
    {required String amountPaid,
    required int stationId,
    required String countyId,
    required String productId}) async {
  Map<String, dynamic>? paymentIntent;
  final themedata = GetStorage();
  bool isDarkMode = themedata.read("darkmode") ?? false;
  try {
    paymentIntent = await createPaymentIntent(amountPaid, 'USD');
    //Payment Sheet
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                // applePay: const PaymentSheetApplePay(
                //   merchantCountryCode: '+254',
                // ),
                // googlePay: const PaymentSheetGooglePay(
                //     testEnv: true,
                //     currencyCode: "KES",
                //     merchantCountryCode: "+254",
                // ),
                style: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                customFlow: true,
                merchantDisplayName: 'Liquitech'))
        .then((value) {});

    ///now finally display payment sheeet
    displayPaymentSheet(context, paymentIntent,
        countyId: countyId, productId: productId, stationId: stationId);
  } catch (error, stacktrace) {
    print('exception:$error$stacktrace');
  }
}

displayPaymentSheet(context, paymentIntent,
    {required String countyId,
    required String productId,
    required int stationId}) async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) {
      createNotification(countyId: countyId, productId: productId, stationId: stationId);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        Text("Payment Successfull"),
                      ],
                    ),
                  ],
                ),
              ));
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

      paymentIntent = null;
    }).onError((error, stackTrace) {
      print('Error is:--->$error $stackTrace');
    });
  } on StripeException catch (e) {
    print('Error is:---> $e');
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: Text("Payments Cancelled "),
      ),
    );
  } catch (e) {
    print('$e');
  }
}

void createNotification(
    {required String countyId,
    required String productId,
    required int stationId}) async {
  var pinNumber = Random().nextInt(999999).toString().padLeft(6, '0');
  await FirebaseFirestore.instance
      .collection("counties")
      .doc(countyId)
      .collection("stations")
      .doc(stationId.toString())
      .collection("products")
      .doc(productId)
      .get()
      .then((value) async {
    var dataRef = value.data() as Map;
    var price = dataRef["Price"] * 1000;
    await FirebaseFirestore.instance.collection('transactions').add({
      "Title": "Success:Stripe Payments",
      "PinNumber": pinNumber,
      "IsRead":false,
      "PaymentMethod":"Stripe",
      "Stripe":true,
      "Date":DateTime.now(),
      "Body":
          "Payments made successfully.Amount of ${dataRef["ProductName"]} in litres bought is ${price.toString()}.Your pin number is $pinNumber",
      "Payload": user.uid,
      user.uid: true,
      "User": user.uid
    }).then((value) {
      sendNotification();
      Get.to(()=>DecisionScreen(countyId:countyId,stationId:stationId.toString()));
    }).catchError((error) {
      CreateSnackBar.buildCustomErrorSnackbar(
          "Error", "Something went wrong while creating notification.");
    });
  }).catchError((error) {
    CreateSnackBar.buildCustomErrorSnackbar(
        "Error", "Failed to get selected product data.");
  });
}

void sendNotification() {
  Stream<QuerySnapshot<Map<String, dynamic>>> stationsData =
      FirebaseFirestore.instance.collection('/transactions').snapshots();
  stationsData.listen((event) {
    if (event.docs.isEmpty) {
      return;
    }
    var dataRef = event.docs.first.data();
    NotificationApi.showNotification(
        title: dataRef['Title'],
        body: dataRef['Body'],
        payload: dataRef['Payload']);
  });
}

//  Future<Map<String, dynamic>>
createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${MyConfig.stripePublishableSecret}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    print('Payment Intent Body->>> ${response.body.toString()}');
    return jsonDecode(response.body);
  } catch (err) {
    print('Error charging user: ${err.toString()}');
  }
}

calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  return calculatedAmount.toString();
}
