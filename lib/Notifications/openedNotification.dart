import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:liquitech/snackbar/snakbar.dart';

final user = FirebaseAuth.instance.currentUser!;

class OpenedNotificationPage extends StatefulWidget {
  final String? messageId;
  final String? title;
  final String? message;
  final String? date;
  final String? time;
  final bool isRead;
  const OpenedNotificationPage(
      {super.key,
      this.messageId,
      this.message,
      this.title,
      this.date,
      this.time,
      this.isRead = false});

  @override
  State<OpenedNotificationPage> createState() => _OpenedNotificationPageState();
}

class _OpenedNotificationPageState extends State<OpenedNotificationPage> {
  final dbConn = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text("Action"),
                        content: const Text("Confirm deleting this message?"),
                        actions: [
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
                                    .collection("notifications")
                                    .doc(widget.messageId)
                                    .delete()
                                    .then((value) {
                                  Get.back(closeOverlays: true);
                                  Get.back();
                                  CreateSnackBar.buildSuccessSnackbar("Success",
                                      "Message deleted successfully.");
                                });
                              })
                        ]);
                  });
            },
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Icon(
              Ionicons.mail_open_outline,
              size: 20,
            ),
            Expanded(child: Text(" Fuel Payment")),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
                title: Text(widget.title.toString().toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.normal)),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 3),
                      Text(widget.message.toString()),
                      const SizedBox(height: 3),
                      Text(widget.date.toString(),
                          style: const TextStyle(color: Colors.grey))
                    ]),
                trailing: Text(widget.time.toString(),
                    style: const TextStyle(color: Colors.greenAccent)),
                onTap: () {},),
          ),
        ),
      ),
    );
  }
}
