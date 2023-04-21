import 'package:flutter/material.dart';


class CustomBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const CustomBtn(
    {
      Key? key,
      required this.label,
      required this.
      onPressed,
      required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      height:60,
      padding: const EdgeInsets.only(left: 3),
      child: ElevatedButton(
        onPressed: onPressed,
        style:ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states){
          if(states.contains(MaterialState.pressed)){
            return Colors.black26;
          }
          return Colors.blue;
          }),
          shape:MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
          ),
        ),
        child:Row(
          mainAxisAlignment:MainAxisAlignment.center,
            children:<Widget>[
            Icon(icon),
            Text(label,style:const TextStyle(fontSize:20))
          ]
        ),
      ),
    );
  }
}

