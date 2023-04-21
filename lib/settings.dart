import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/dashboard.dart';
import 'package:liquitech/updateprofile.dart';
import 'components/settingtile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquitech/exceptions/firebaseauth.dart';




class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themedata=GetStorage();
  
 

  @override
  Widget build(BuildContext context) {
    themedata.writeIfNull("darkmode",false);
    bool isDarkMode=themedata.read("darkmode");

    return Scaffold(
      appBar: AppBar(
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Icon(
                Icons.settings,
                size: 20,
              ),
              Expanded(child: Text("Settings")),
            ]),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: <Widget>[
          SettingTile(
            color: Colors.green,
            icon: Ionicons.pencil_outline,
            label: "Edit info",
            onPress: () {
              Get.to(()=>const UpdateProfile());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap:(){},
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
              child: Icon(
                isDarkMode ? Ionicons.sunny_outline : Ionicons.moon_outline,
                color: Colors.white,
              ),
            ),
            title: Text("Theme", style: Theme.of(context).textTheme.bodyLarge),
            trailing:  Switch(
                activeColor:Colors.blue,
                value:isDarkMode,
                onChanged: (bool value) {
                setState((){
                  isDarkMode=value;
                });
                isDarkMode ? Get.changeTheme(ThemeData.dark()) : Get.changeTheme(ThemeData.light());
                themedata.write("darkmode",value);
                }
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SettingTile(
            color: Colors.purple,
            icon: Ionicons.language_outline,
            label: "Language",
            onPress: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          SettingTile(
            color: Colors.red,
            icon: Ionicons.log_out_outline,
            label: "Logout",
            onPress: () async {
              AuthRepository.instance.logout();
            },
          ),
        ]),
      ),
    );
  }
}
