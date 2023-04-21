import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:liquitech/components/custombtn.dart';
import 'package:liquitech/fuel.dart';
import 'package:get/get.dart';


class SuccessPage extends StatelessWidget {
  final String countyId;
  final String stationId;
  const SuccessPage({super.key,required this.stationId,required this.countyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Success'),
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
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInUp(
              child: Image.asset('assets/images/success.gif', 
                fit: BoxFit.cover, 
                width:280, 
              ),
            ),
            const SizedBox(height:10.0,),
            const Text("Success",style:TextStyle(fontSize:40,fontWeight:FontWeight.bold,color:Colors.blue,fontFamily: 'kids_club')),
            const Text("Your payments was done successfully",style:TextStyle(fontSize:16,)),
            const SizedBox(height:10.0,),
            CustomBtn(
              label: 'Next',
              icon:Icons.arrow_forward_ios,
              onPressed: () {
                Get.to(()=>FuelPage(stationId:stationId,countyId:countyId));
              },
            )
          ]
        ),
      ),
    );
  }
}