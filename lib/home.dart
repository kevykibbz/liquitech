import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquitech/auth/login.dart';

import 'dashboard.dart';

const bool useLocalEmulator = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  @override
  void didChangeDependencies() async {
    if (useLocalEmulator) {
      db.useFirestoreEmulator(host, 8080);
      db.settings = const Settings(
        persistenceEnabled: false,
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else if (snapshot.hasData) {
              return const DashboardPage();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
