import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:liquitech/components/custombtn.dart';
import '../config/config.dart';



class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 5,
        title: const Text(MyConfig.appName),
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
      body:Container(
        padding:const EdgeInsets.all(10.0),
        child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.mobile_friendly_outlined,
                  size:50,
                  color:Colors.blueAccent,
                ),
                Expanded(
                  child: Text(' Phone Number Verfication.',
                    textAlign:TextAlign.center,
                    style:Theme.of(context).textTheme.headline4
                  ),
                ),
              ]),
            ),
            const SizedBox(height:10.0),
            Text('Enter verfication code send to +254796268817.',style:Theme.of(context).textTheme.bodyText2),
            const SizedBox(height:20.0),
            OtpTextField(
              numberOfFields:6,
              fillColor:Colors.black.withOpacity(0.1),
              filled:true,
              onSubmit:(code){
                print('code:$code');
              }
            ),
            const SizedBox(height:20.0),
           CustomBtn(
              label: 'Next',
              icon:Icons.add,
              onPressed: () {
                
              },
            ),
          ]
        )
      )
   );
  }
}