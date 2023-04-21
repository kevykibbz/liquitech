import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ItemListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ItemListTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: color),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade200),
          child:
              const Icon(Ionicons.chevron_forward_outline, color: Colors.blue),
        ),
      ],
    );
  }
}
