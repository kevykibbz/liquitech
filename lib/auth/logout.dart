import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

Future<void> signOut() async {
  try {
    final providerData = auth.currentUser!.providerData;
    if (providerData.isNotEmpty) {
      if (providerData[0].providerId.toLowerCase().contains('google')) {
        //final provider =Provider.of<GoogleSignInProvider>(context, listen: false);
        //provider.logout();
      } else if (providerData[0]
          .providerId
          .toLowerCase()
          .contains('facebook')) {
        await FacebookAuth.instance.logOut();
      } else if (providerData[0]
          .providerId
          .toLowerCase()
          .contains('twitter')) {
        await FirebaseAuth.instance.signOut();
      }
    }
    await auth.signOut();
  } catch (e) {
    print(e);
  }
}