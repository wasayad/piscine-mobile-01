import 'package:flutter/material.dart';

class Weekly extends StatefulWidget  {
  const Weekly({super.key});
  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("It's sunny here"),
    );
  }
}
