import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:intl/intl.dart";
import "package:calendar_time/calendar_time.dart";
import 'package:grouped_list/grouped_list.dart';
import 'package:liquitech/components/nodata.dart';


final user = FirebaseAuth.instance.currentUser!;

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>  {
  final Stream<QuerySnapshot> _statsStream = FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection("Stats")
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
        title:const Text("Stats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _statsStream,
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
              return const Nodata(message: "No stats(s) found.");
            }
            return buildList(context, dataList);
          }
        }
      ),
    );
  }
}


Widget buildList(BuildContext context, data) {
  return GroupedListView<dynamic, String>(
    elements: data,
    groupBy: (element) => element['CountyName'],
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
    itemComparator: (item1, item2) => item1['CountyName'].compareTo(item2['CountyName']), // optional
    useStickyGroupSeparators: true, // optional
    floatingHeader: true, // optional
    order: GroupedListOrder.ASC, // optional
  );
}



Widget createList(data) {
  var time = DateFormat("hh:mm:a").format(data['Date'].toDate());
  var date=CalendarTime(data['Date'].toDate()).isToday
          ? "Today"
          : (CalendarTime(data['Date'].toDate()).isYesterday
            ? "Yesterday"
            : DateFormat.MMMMEEEEd().format(data['Date'].toDate()));
  return Card(
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(
            data['port'].toUpperCase(),
            style:const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            const SizedBox(height:3),
            Text("Bought fuel successfuly.Paid Ksh ${data['Amount'].toString()} amounting to ${data['Ltrs'].toString()} ltrs of ${data['Product']}."),
            const SizedBox(height:3),
            Text(date,style:const TextStyle(color:Colors.grey))
          ]
        ),
        leading: CircleAvatar(child: Text(data['port'][0].toUpperCase())),
        dense: false,
        trailing:Row(
          children:[
            const Icon(Icons.add),
            Text(time, style: const TextStyle(color: Colors.greenAccent))
          ]
        ),
      ),
    ),
  );
}