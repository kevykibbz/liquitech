// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquitech/components/nodata.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import 'package:grouped_list/grouped_list.dart';
import "package:calendar_time/calendar_time.dart";
import 'package:get/get.dart';
import 'package:liquitech/snackbar/snakbar.dart';
import 'package:liquitech/Notifications/openedNotification.dart';

final user = FirebaseAuth.instance.currentUser!;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
      .collection("notifications")
      .orderBy("Date", descending: false)
      .snapshots();

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
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Icon(
                Ionicons.mail_unread_outline,
                size: 20,
              ),
              Expanded(child: Text(" Notifications")),
            ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _messagesStream,
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
              List<QueryDocumentSnapshot> dataList = snapshot.data!.docs;
              if (dataList.isEmpty) {
                return const Nodata(message: "No new message(s) found.");
              }
              return buildList(context, dataList);
            }
          }),
    );
  }
}

Widget buildList(BuildContext context, data) {
  return GroupedListView<dynamic, String>(
    elements: data,
    groupBy: (element) => (CalendarTime(element['Date'].toDate()).isToday
            ? "Today"
            : (CalendarTime(element['Date'].toDate()).isYesterday
                ? "Yesterday"
                : DateFormat.MMMMEEEEd().format(element['Date'].toDate())))
        .toUpperCase(),
    groupSeparatorBuilder: (String groupByValue) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Text(groupByValue,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent)))
        ])),
    itemBuilder: (context, dynamic element) {
      return createList(element);
    },
    itemComparator: (item1, item2) => item1['Date']
        .toDate()
        .toString()
        .compareTo(item2['Date'].toDate().toString()), // optional
    useStickyGroupSeparators: true, // optional
    floatingHeader: true, // optional
    order: GroupedListOrder.ASC, // optional
  );
}

Widget createList(data) {
  var isRead = data['IsRead'];
  var time = DateFormat("hh:mm:a").format(data['Date'].toDate());
  return Slidable(
      startActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.redAccent,
          icon: Ionicons.trash_outline,
          label: "Delete",
          onPressed: (context) {
            deleteMessage(context, data.id);
          },
        )
      ]),
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.redAccent,
          icon: Ionicons.trash_outline,
          label: "Delete",
          onPressed: (context) {
            deleteMessage(context, data.id);
          },
        )
      ]),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
              title: Text("${data['Title']}".toUpperCase(),
                  style:
                      TextStyle(fontWeight: !isRead ? FontWeight.bold : null)),
              subtitle: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: data['Body'],
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  )),
              leading:
                  CircleAvatar(child: Text(data['Title'][0].toUpperCase())),
              dense: false,
              trailing: Text(time, style: const TextStyle(color: Colors.grey)),
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection("notifications")
                    .doc(data.id)
                    .get()
                    .then((snapshot) async {
                  var dataRef = snapshot.data()!;
                  bool isRead = dataRef['IsRead'];
                  String message = dataRef['Body'];
                  String title = dataRef['Title'];
                  String date =
                      dataRef['Date'].toDate().toString().substring(0, 10);
                  String time =
                      DateFormat("hh:mm:a").format(dataRef['Date'].toDate());
                  await FirebaseFirestore.instance
                      .collection("notifications")
                      .doc(data.id)
                      .update({"IsRead": true})
                      .then((value){
                          Get.to(() => OpenedNotificationPage(
                            messageId: data.id,
                            isRead: isRead,
                            title: title,
                            date: date,
                            time: time,
                            message: message));
                      })
                      .catchError((onError) {
                        CreateSnackBar.buildCustomErrorSnackbar(
                            "Error", "Unknown error ocurred");
                      });
                });
              }),
        ),
      ));
}

deleteMessage(BuildContext context, messageId) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Delete"),
            content: const Text("Confirm deleting message"),
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
                      .collection("notifications")
                      .doc(messageId)
                      .delete()
                      .then((value) {
                    Get.back(closeOverlays: true);
                    CreateSnackBar.buildSuccessSnackbar(
                        "Success", "Message deleted successfully.");
                  });
                },
              ),
            ],
          ));
}
