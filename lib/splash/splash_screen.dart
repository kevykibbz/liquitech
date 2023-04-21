import 'dart:async';
import 'package:flutter/material.dart';
import '../checker.dart';




class SplashScreen extends StatefulWidget {
  final String myAppName;
  const SplashScreen({Key? key,required this.myAppName}):super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds:5),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const CheckerPage())));
  }
  @override
  Widget build(BuildContext context) {
      var year = DateTime.now().year;
      return Container(
        decoration:const BoxDecoration(
          
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors:  [Color(0xff2196f3),Color(0xff42a5f5)],
            ),
        ),
        child: Column(
          children:  <Widget>[
            Expanded(
              flex:9,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.myAppName,
                      style:const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:40.0,
                        fontFamily:'kids_club',
                        decoration:TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height:30.0,
                  ),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex:1,
              child: Container(
                alignment:Alignment.center,
                child: Text("\u00a9 $year,v1.1,Devme.",
                            style:const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle:FontStyle.italic,
                              fontSize:12.0,
                              decoration:TextDecoration.none,
                  ),
                ),
              )
            ),
           ],
        ),
      );
  }
}