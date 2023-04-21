import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'countiesdata.dart';
import 'listview_title.dart';
import 'stations.dart';
import 'package:liquitech/components/nodata.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/countiesdata.dart';
import 'package:liquitech/snackbar/snakbar.dart';


bool isloading = false;
bool stationUpdating = false;
bool isdmin = false;
bool setCounties = false;
bool isSelected = false;

class CountiesList extends StatefulWidget {
  const CountiesList({
    Key? key,
  }) : super(key: key);

  @override
  State<CountiesList> createState() => _CountiesListState();
}

class _CountiesListState extends State<CountiesList> {
  //check if collection name exists in FirebaseFirestore
  Future<void> checkCollection({required String collectionName}) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.size == 0) {
        setState(() {
          setCounties = true;
        });
      } else {
        setState(() {
          setCounties = false;
        });
      }
    });
  }

  @override
  initState() {
    checkCollection(collectionName: "counties");
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

  final Stream<QuerySnapshot> _countiesStream = FirebaseFirestore.instance
      .collection("counties")
      .orderBy("CountyNumber", descending: false)
      .snapshots();

  static final AppBar defaultBar = AppBar(
      title: const Text('Select county'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            //showSearch(context: context, delegate: DataSearch());
          },
        ),
      ],
    );

    static final AppBar selectedBar = AppBar(
      title: const Text('Edit county'),
      backgroundColor: const Color(0xff42a5f5),
      leading: IconButton(
        onPressed: () {

        },
        icon: const Icon(
          Icons.close,
          size: 20,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever_outlined),
          onPressed: () {},
        ),
      ],
    );

    AppBar myAppBar = defaultBar;

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    final editFuelFormKey = GlobalKey<FormState>();
    final editFuelController = TextEditingController();

    return Scaffold(
      floatingActionButton: (isdmin && setCounties)
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.add,
                  color: isDarkMode ? Colors.white : Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Add counties"),
                          content:
                              const Text("Upload counties to the database"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () async {
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
                                      await addCounties(
                                              collectionName: 'counties')
                                          .then((value) {
                                        setState(() {
                                          setCounties = false;
                                        });
                                      });
                                    },
                                  ),
                          ],
                        ));
              },
            )
          : null,
      appBar: AppBar(
      title: const Text('Select county'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Ionicons.search_outline),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ],
    ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _countiesStream,
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return const Nodata(message: "No counties found.");
              }
              return ListView.builder(
                itemCount: snap.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var id = snap[index].reference.id.toString();
                  return Slidable(
                    startActionPane:isdmin ?ActionPane(
                      motion:const StretchMotion(),
                      children:[
                        SlidableAction(
                          backgroundColor:Colors.blue,
                          icon:Ionicons.pencil,
                          label:"Edit",
                          onPressed: (context){
                            FirebaseFirestore.instance
                              .collection("counties")
                              .doc(id)
                              .get()
                              .then((value){
                                var data=value.data() as Map;
                                editFuelController.text=data['CountyName'];
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                              title: const Text("Edit fuel station"),
                              content: Form(
                                key: editFuelFormKey,
                                autovalidateMode:AutovalidateMode.onUserInteraction,
                                child: TextFormField(
                                  controller: editFuelController,
                                  cursorColor: Colors.blue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'County name',
                                    hintText: 'Enter county name',
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
                                    if (editFuelFormKey.currentState!
                                        .validate()) {
                                      await FirebaseFirestore.instance
                                          .collection('/counties')
                                          .doc(id)
                                          .update({
                                              "CountyName":editFuelController.text.trim(),
                                              "indexKey": addSearchKeys(
                                                searchName:editFuelController.text.trim())
                                          })
                                          .then((value) {
                                            Get.back(closeOverlays: true);
                                            CreateSnackBar.buildSuccessSnackbar("Success", "County name changed successfully.");
                                      });
                                    }
                                  },
                                ),
                              ],
                            )
                          );
                          }
                        ),
                      ]
                    ) : null,
                    endActionPane:ActionPane(
                      motion:const StretchMotion(),
                      children:[
                        SlidableAction(
                          backgroundColor:Colors.green,
                          icon:Ionicons.arrow_forward_outline,
                          label:"Go to station",
                          onPressed:(context){
                            Get.to(() => StationsPage(countyId: id));
                          }
                        ),
                      ]
                    ),
                    child: Card(
                      elevation: 5.0,
                      child: CountiesListTile(
                        context:context,
                        snap[index],
                        onPress: () {
                          Get.to(() => StationsPage(countyId: id));
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
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
                .where('indexKey', arrayContains: query.toLowerCase())
                .snapshots()
            : FirebaseFirestore.instance
                .collection("counties")
                .orderBy("CountyNumber", descending: false)
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
              return const Nodata(message: "No counties found.");
            }
            return ListView.builder(
              itemCount: snap.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5.0,
                  child: CountiesListTile(
                    context:context,
                    snap[index],
                    onPress: () {
                      var id = snap[index].reference.id.toString();
                      Get.to(() => StationsPage(countyId: id));
                    },
                  ),
                );
              },
            );
          }
        });
  }
}
