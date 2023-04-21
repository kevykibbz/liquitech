import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';


class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPress;
  const ProfileMenu({Key? key, required this.icon, required this.label,required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.shade200),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      title: Text(label, style: Theme.of(context).textTheme.bodyText1),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.shade200),
        child: const Icon(
          Ionicons.chevron_forward_outline,
          color: Colors.blue,
          size: 16,
        ),
      ),
    );
  }
}
