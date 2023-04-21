import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import "package:flutter_slidable/flutter_slidable.dart";

bool isSelected = false;

class CountiesListTile extends ListTile {
  final VoidCallback onPress;
  final BuildContext context;
  CountiesListTile(
    data, {
    super.key,
    required this.onPress,
    required this.context,
  }) : super(
          title: Text(data['CountyName']),
          onTap: () {
           final slidable=Slidable.of(context)!;
           final isClosed=slidable.actionPaneType.value == ActionPaneType.none;
           if(isClosed){
            slidable.openStartActionPane();
           }else{
            slidable.close();
           }
          },
          shape: isSelected
              ? RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5))
              : null,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${data['Stations'].toString()} Station(s)"),
            ],
          ),
          leading: CircleAvatar(
              child: isSelected
                  ? const Icon(Icons.check)
                  : Text(data['CountyName'][0].toUpperCase())),
          dense: false,
          trailing: IconButton(
              onPressed: onPress,
              icon: const Icon(Ionicons.arrow_forward_outline,
                  size: 24.0, color: Colors.blue)
          ),
        );
}
