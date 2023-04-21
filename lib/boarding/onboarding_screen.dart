import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquitech/junction.dart';
import '../config/config.dart';


class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});
  final String myAppName=MyConfig.appName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(),
        bodyPadding:const EdgeInsets.all(10.0),
        pages: [
          PageViewModel(
            titleWidget: const Text('1. Who are we?',            
            style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:Colors.blue,fontFamily:'kids_club'),),
            body:'$myAppName is a national technologised energy company with expertise in exploration,production,refining and marketing of oil and natural gas and the manufacturing and marketing of chemicals.',
            image: SvgPicture.asset('assets/images/onboarding_screen/1.svg',height:400.0,width: 400.0,),
          ),
           PageViewModel(
            titleWidget: const Text('2. Our Purpose',
            style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:Colors.blue,fontFamily:'kids_club'),
            ),
            body:'Our purpose is to power progress together with more and cleaner,quality,affodable energy solutions.',
            image: SvgPicture.asset('assets/images/onboarding_screen/2.svg',height:400.0,width: 400.0,),
          ),
           PageViewModel(
            titleWidget: const Text('3. Our clients',
            style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:Colors.blue,fontFamily:'kids_club'),
            ),
            body:'Our clients are essential in the successful delivery of $myAppName strategy and to sustain business peromance over long term. ',
            image: SvgPicture.asset('assets/images/onboarding_screen/3.svg',height:400.0,width: 400.0,),
          ),
        ],
        onDone: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const JunctionView()));
        },
        onSkip:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const JunctionView()));
        },
        showSkipButton: true,
        skip:const Text('Skip',style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Color(0xff2196f3)),),
        next:Container(
          width:40,height:40,
          decoration:BoxDecoration(
            borderRadius:BorderRadius.circular(100),
            color:Colors.grey.shade200
          ),
          child: const Icon(Icons.arrow_forward,color:Color(0xff2196f3))
        ),
        done:const Text('Done',style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Color(0xff2196f3)),),
        dotsDecorator:DotsDecorator(
          size:const Size.square(10.0),
          activeSize:const Size(20.0, 10.0),
          activeColor:const Color(0xff2196f3),
          spacing:const EdgeInsets.symmetric(horizontal:3.0),
          activeShape:RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}