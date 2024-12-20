import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? additionalText;

  const StatCard({
    required this.title,
    required this.value,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Fixed width for equal size

      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 4),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold),
                ),
                if (additionalText != null) ...[
                  SizedBox(width: 4),
                  Text(
                    additionalText!,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
