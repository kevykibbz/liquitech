import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'boarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CheckerPage extends StatefulWidget {
  const CheckerPage({super.key});

  @override
  State<CheckerPage> createState() => _CheckerPageState();
}

class _CheckerPageState extends State<CheckerPage> {
  final user = FirebaseAuth.instance.currentUser;

  
  @override
  Widget build(BuildContext context) {
    if( user!=null){
      return const DashboardPage();
    }else{
      return const BoardingScreen();
    }
  }
}