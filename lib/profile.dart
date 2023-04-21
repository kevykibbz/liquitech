import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquitech/auth/changePassword.dart';
import 'package:liquitech/stats.dart';
import 'package:liquitech/updateprofile.dart';
import 'components/profileitems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isdmin = false;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  initState() {
    FirebaseFirestore.instance
        .collection("/users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var dataRef = snapshot.data() as Map;
      if (dataRef['Role'] == "Client") {
        setState(() {
          isdmin = false;
        });
      } else {
        setState(() {
          isdmin = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Icon(
                Ionicons.person_outline,
                size: 20,
              ),
              Expanded(child: Text("Profile")),
            ]),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 2,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ]),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: user.photoURL!,
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          color: Colors.blue),
                      child: isdmin
                          ? const Icon(Ionicons.shield_checkmark_outline,
                              color: Colors.white, size: 12)
                          : const Icon(Ionicons.person_outline,
                              color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),
              Text(user.displayName!,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 8,
              ),
              Text(
                user.email!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(),
              const SizedBox(
                height: 40,
              ),

              //menu
              ProfileMenu(
                icon: Ionicons.settings_outline,
                label: 'Edit profile',
                onPress: () {
                  Get.to(() => const UpdateProfile());
                },
              ),
              ProfileMenu(
                icon: Ionicons.shield_checkmark_outline,
                label: 'Change password',
                onPress: () {
                  Get.to(() => const ChangePasswordScreen());
                },
              ),
              ProfileMenu(
                icon: Ionicons.wallet_outline,
                label: 'View Stats',
                onPress: () {
                  Get.to(() => const StatsScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
