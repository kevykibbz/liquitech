import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/components/nodata.dart';
import 'package:liquitech/countiesdata.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import 'package:liquitech/snackbar/snakbar.dart';
import 'package:liquitech/payment_type.dart';

bool isdmin = false;

class ProductScreen extends StatefulWidget {
  final String stationId;
  final String countyId;
  const ProductScreen(
      {super.key, required this.countyId, required this.stationId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  initState() {
    FirebaseFirestore.instance
        .collection("/users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var dataRef = snapshot.data() as Map;
      if (dataRef['Role'] == "Client") {
        setState(() {
          isdmin = false;
        });
      } else {
        setState(() {
          isdmin = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    final productFormKey = GlobalKey<FormState>();
    final productController = TextEditingController();
    final priceController = TextEditingController();
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection("counties")
        .doc(widget.countyId)
        .collection("stations")
        .doc(widget.stationId)
        .collection("products")
        .snapshots();
    return Scaffold(
      floatingActionButton: isdmin
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.add,
                  color: isDarkMode ? Colors.white : Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Add product"),
                          content: Form(
                            key: productFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.24,
                              child: Column(children: <Widget>[
                                TextFormField(
                                  controller: productController,
                                  cursorColor: Colors.blue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Product name',
                                    hintText: 'Enter product name',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    prefixIcon:
                                        Icon(Ionicons.add_circle_outline),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  controller: priceController,
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                    hintText: 'Product price per ltr',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    prefixIcon:
                                        Icon(Icons.currency_bitcoin_outlined),
                                  ),
                                )
                              ]),
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
                              onPressed: () {
                                if (productFormKey.currentState!.validate()) {
                                  FirebaseFirestore.instance
                                      .collection("counties")
                                      .doc(widget.countyId)
                                      .collection("stations")
                                      .doc(widget.stationId)
                                      .collection("products")
                                      .add({
                                    "ProductName":
                                        productController.text.trim(),
                                    "Price": double.parse(
                                        priceController.text.trim()),
                                    "indexKey": addSearchKeys(
                                        searchName:
                                            productController.text.trim())
                                  }).then((value) {
                                    Get.back(closeOverlays: true);
                                    Get.snackbar("Success",
                                        "Product added successfully.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            Colors.green.withOpacity(0.1),
                                        colorText: Colors.green);
                                  });
                                }
                              },
                            ),
                          ],
                        ));
              },
            )
          : null,
      appBar: AppBar(
        title: const Text('Select product.'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(
                      countyId: widget.countyId, stationId: widget.stationId));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          const SizedBox(height: 50),
          FadeInRight(
              delay: const Duration(milliseconds: 200),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade200),
                      child: const Icon(
                        Ionicons.language_outline,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Choose Product",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))
                  ],
                ),
              )),
          const SizedBox(height: 12.0),
          StreamBuilder<QuerySnapshot>(
              stream: productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                } else {
                  final snap = snapshot.data!.docs;
                  if (snap.isEmpty) {
                    return const Nodata(message: "No product(s) found.");
                  }
                  return buildList(
                      context, snap, widget.countyId, widget.stationId);
                }
              }),
        ]),
      ),
    );
  }
}

Widget buildList(context, data, countyId, stationId) {
  final editProductFormKey = GlobalKey<FormState>();
  final editProductController = TextEditingController();

  return ListView.builder(
    itemCount: data.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      var productId = data[index].reference.id.toString();
      return Slidable(
        startActionPane: isdmin
            ? ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                    backgroundColor: Colors.blue,
                    icon: Ionicons.pencil,
                    label: "Edit",
                    onPressed: (context) async {
                      FirebaseFirestore.instance
                          .collection("counties")
                          .doc(countyId)
                          .collection("stations")
                          .doc(stationId)
                          .collection("products")
                          .doc(productId)
                          .get()
                          .then((value) {
                        var data = value.data() as Map;
                        editProductController.text = data['ProductName'];
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text("Edit product "),
                                content: Form(
                                  key: editProductFormKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: TextFormField(
                                    controller: editProductController,
                                    cursorColor: Colors.blue,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Product name',
                                      hintText: 'Enter product name',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      prefixIcon: Icon(Ionicons.build_outline),
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
                                      if (editProductFormKey.currentState!
                                          .validate()) {
                                        await FirebaseFirestore.instance
                                            .collection("counties")
                                            .doc(countyId)
                                            .collection("stations")
                                            .doc(stationId)
                                            .collection("products")
                                            .doc(productId)
                                            .update({
                                          "ProductName":
                                              editProductController.text.trim(),
                                          "indexKey": addSearchKeys(
                                              searchName: editProductController
                                                  .text
                                                  .trim())
                                        }).then((value) {
                                          Get.back(closeOverlays: true);
                                          CreateSnackBar.buildSuccessSnackbar(
                                              "Success",
                                              "Product name changed successfully.");
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ));
                    }),
                SlidableAction(
                    backgroundColor: Colors.red,
                    icon: Ionicons.trash_outline,
                    label: "Delete",
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete"),
                                content: const Text("Confirm deleting item"),
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
                                      await FirebaseFirestore.instance
                                          .collection("counties")
                                          .doc(countyId)
                                          .collection("stations")
                                          .doc(stationId)
                                          .collection("products")
                                          .doc(productId)
                                          .delete()
                                          .then((value) {
                                        Get.back(closeOverlays: true);
                                        CreateSnackBar.buildSuccessSnackbar(
                                            "Success",
                                            "Station name deleted successfully.");
                                      },);
                                    },
                                  ),
                                ],
                              ),);
                    },)
              ],)
            : null,
        child: ProductTile(
            title: data[index]['ProductName'],
            onPress: () {
              Get.to(()=>SelectPaymentType( 
                  productId: productId,
                  countyId: countyId,
                  stationId: stationId));
            },),
      );
    },
  );
}

class ProductTile extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const ProductTile({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.blue.withOpacity(0.1)),
        ),
        leading: CircleAvatar(child: Text(title[0].toUpperCase())),
        title: Text(title),
        dense: false,
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade200),
          child: IconButton(
            onPressed: onPress,
            icon: const Icon(
              Ionicons.chevron_forward_outline,
              color: Colors.blue,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final String stationId;
  final String countyId;

  DataSearch({required this.countyId, required this.stationId});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("hello world");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: query.isNotEmpty
            ? FirebaseFirestore.instance
                .collection("counties")
                .doc(countyId)
                .collection("stations")
                .doc(stationId)
                .collection("products")
                .where('indexKey', arrayContains: query.toLowerCase())
                .snapshots()
            : FirebaseFirestore.instance
                .collection("counties")
                .doc(countyId)
                .collection("stations")
                .doc(stationId)
                .collection("products")
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            final snap = snapshot.data!.docs;
            if (snap.isEmpty) {
              return const Nodata(message: "No product(s) found.");
            }
            return buildList(context, snap, countyId, stationId);
          }
        });
  }
}
