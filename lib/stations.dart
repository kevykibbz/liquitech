import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:liquitech/countiesdata.dart';
import 'package:liquitech/map.dart';
import 'package:liquitech/components/nodata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquitech/product.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import 'package:liquitech/services/notificationService.dart';
import 'package:liquitech/snackbar/snakbar.dart';
import "dart:math";

bool isdmin = false;
bool isloading = false;
final user = FirebaseAuth.instance.currentUser!;

class StationsPage extends StatefulWidget {
  final String countyId;
  const StationsPage({
    Key? key,
    required this.countyId,
  }) : super(key: key);

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
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
    final fuelFormKey = GlobalKey<FormState>();
    final fuelController = TextEditingController();
    final Stream<QuerySnapshot> stationStream = FirebaseFirestore.instance
        .collection("counties")
        .doc(widget.countyId)
        .collection("stations")
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
                    title: const Text("Add fuel station"),
                    content: Form(
                      key: fuelFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: fuelController,
                        cursorColor: Colors.blue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Station name',
                          hintText: 'Enter station name',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                      isloading
                          ? Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator())
                          : TextButton(
                              child: const Text('Ok'),
                              onPressed: () async {
                                if (fuelFormKey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  List position = [];
                                  var docId = Random()
                                      .nextInt(999999)
                                      .toString()
                                      .padLeft(6, '0');
                                  await FirebaseFirestore.instance
                                      .collection("counties")
                                      .doc(widget.countyId)
                                      .collection("stations")
                                      .doc(docId)
                                      .set({
                                    "FuelAvailability": false,
                                    "User": user.uid,
                                    user.uid: true,
                                    "Position": const GeoPoint(0,0), //latitude,longitude
                                    "StationId": int.parse(docId),
                                    "StationName": fuelController.text.trim(),
                                    "indexKey": addSearchKeys(
                                        searchName: fuelController.text.trim())
                                  }).then((value) async {
                                    await FirebaseFirestore.instance
                                        .collection('/counties')
                                        .doc(widget.countyId)
                                        .get()
                                        .then(
                                            (DocumentSnapshot document) async {
                                      var item = document.data() as Map;
                                      await FirebaseFirestore.instance
                                          .collection("/counties")
                                          .doc(widget.countyId)
                                          .update({
                                        "Stations": item['Stations'] + 1
                                      }).then((value) {
                                        setState(() {
                                          isloading = false;
                                        });
                                        createNotification(
                                            stationId: int.parse(docId),
                                            stationName:
                                                fuelController.text.trim());
                                        Get.back(closeOverlays: true);
                                        Get.snackbar("Success",
                                            "Station added successfully.",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor:
                                                Colors.green.withOpacity(0.1),
                                            colorText: Colors.green);
                                      });
                                    });
                                  });
                                }
                              },
                            ),
                    ],
                  ),
                );
              },
            )
          : null,
      appBar: AppBar(
        title: const Text('Select fueling station.'),
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
                  delegate: DataSearch(countyId: widget.countyId));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: stationStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return const Nodata(message: "No stations found.");
              }
              return buildList(snap, widget.countyId);
            }
          }),
    );
  }

  void sendNotification() {
    Stream<QuerySnapshot<Map<String, dynamic>>> stationsData = FirebaseFirestore
        .instance
        .collection('/counties')
        .doc(widget.countyId)
        .collection('notifications')
        .snapshots();
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

  void createNotification(
      {required String stationName, required int stationId}) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .add({
      "Title": "Station created Successfully.",
      "Body":
          "${stationName.capitalizeFirst} station created successfully.Here is the station ID: $stationId",
      "Payload": user.uid,
      "IsRead":false,
      user.uid: true,
      "User": user.uid,
      "Date":DateTime.now()
    }).then((value) {
      sendNotification();
    }).catchError((error) {
      CreateSnackBar.buildCustomErrorSnackbar(
          "Error", "Something went wrong while creating notification.");
    });
  }
}

Widget buildList(data, countyId) {
  final editStationFormKey = GlobalKey<FormState>();
  final editStationController = TextEditingController();
  return ListView.builder(
    itemCount: data.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      bool isFuelAvailable = data[index]['FuelAvailability'];
      var id = data[index].reference.id.toString();
      return Slidable(
        startActionPane: isdmin
            ? ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.blue,
                    icon: Ionicons.pencil,
                    label: "Edit",
                    onPressed: (context) {
                      FirebaseFirestore.instance
                          .collection("counties")
                          .doc(countyId)
                          .collection("stations")
                          .doc(id)
                          .get()
                          .then((value) {
                        var data = value.data() as Map;
                        editStationController.text = data['StationName'];
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Edit fuel station"),
                          content: Form(
                            key: editStationFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: editStationController,
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Station name',
                                hintText: 'Enter station name',
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
                                if (editStationFormKey.currentState!
                                    .validate()) {
                                  await FirebaseFirestore.instance
                                      .collection("counties")
                                      .doc(countyId)
                                      .collection("stations")
                                      .doc(id)
                                      .update({
                                    "StationName":
                                        editStationController.text.trim(),
                                    "indexKey": addSearchKeys(
                                        searchName:
                                            editStationController.text.trim())
                                  }).then((value) {
                                    Get.back(closeOverlays: true);
                                    CreateSnackBar.buildSuccessSnackbar(
                                        "Success",
                                        "Station name changed successfully.");
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                                            .doc(id)
                                            .delete()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('/counties')
                                              .doc(countyId)
                                              .get()
                                              .then((DocumentSnapshot
                                                  document) async {
                                            var item = document.data() as Map;
                                            int updater = 0;
                                            if (item['Stations'] > 0) {
                                              updater = item['Stations'] - 1;
                                            }
                                            await FirebaseFirestore.instance
                                                .collection("/counties")
                                                .doc(countyId)
                                                .update({
                                              "Stations": updater
                                            }).then((value) {
                                              Get.back(closeOverlays: true);
                                              CreateSnackBar.buildSuccessSnackbar(
                                                  "Success",
                                                  "Station name deleted successfully.");
                                            });
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ));
                      }),
                ],
              )
            : null,
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
              backgroundColor: Colors.green,
              icon: Ionicons.arrow_forward_outline,
              label: "Go to products",
              onPressed: (context) {
                Get.to(() => ProductScreen(countyId: countyId, stationId: id));
              }),
        ]),
        child: Card(
          elevation: 5.0,
          child: ListTile(
            title: Text(data[index]['StationName']),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "8",
                  style: TextStyle(color: Colors.blue),
                ),
                const Text(" pple in station"),
                const Text(
                  " | ",
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(() => const MapsScreen());
                    },
                    child: const Text(
                      "View Map",
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            leading: CircleAvatar(
                child: Text(data[index]['StationName'][0].toUpperCase())),
            dense: false,
            trailing: isFuelAvailable
                ? IconButton(
                    onPressed: () {
                      Get.to(() =>
                          ProductScreen(countyId: countyId, stationId: id));
                    },
                    icon: const Icon(Ionicons.arrow_forward_outline,
                        size: 24.0, color: Colors.blue))
                : IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(
                            "Theres no fuel in this petrol station."),
                        action: SnackBarAction(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          label: "Ok",
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ));
                    },
                    icon: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade200),
                      child: const Icon(
                        Ionicons.warning_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ),
        ),
      );
    },
  );
}

class DataSearch extends SearchDelegate<String> {
  final String countyId;

  DataSearch({required this.countyId});

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
    return const Card(
      color: Colors.red,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: query.isNotEmpty
            ? FirebaseFirestore.instance
                .collection("counties")
                .doc(countyId)
                .collection("stations")
                .where('indexKey', arrayContains: query.toLowerCase())
                .snapshots()
            : FirebaseFirestore.instance
                .collection("counties")
                .doc(countyId)
                .collection("stations")
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
              return const Nodata(message: "No stations found.");
            }
            return buildList(snap, countyId);
          }
        });
  }
}
