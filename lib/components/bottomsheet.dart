import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class BottomSheetModal extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;
  const BottomSheetModal({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themedata=GetStorage();
    bool isDarkMode=themedata.read("darkmode") ?? false;
    return GestureDetector(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isDarkMode?Colors.black12:Colors.grey.shade200,
        ),
        child: Row(children: <Widget>[
          Icon(icon,size: 40.0,color:Colors.blue,),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headline6),
              Text(content,style: Theme.of(context).textTheme.bodyText2),
            ],
          )
        ]),
      ),
    );
  }
}
