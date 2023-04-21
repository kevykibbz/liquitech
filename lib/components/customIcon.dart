import 'package:flutter/material.dart';


class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({Key? key,required this.icon}) : super(key: key);
   
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.only(right:10,),
      child:Icon(icon),
    );
  }
}
