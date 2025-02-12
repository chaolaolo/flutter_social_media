import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;

  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        // borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Text(
        text.isNotEmpty ? text : "No bio",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
