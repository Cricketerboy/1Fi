import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 65, 81, 226),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color.fromARGB(255, 65, 81, 226),
          ),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
