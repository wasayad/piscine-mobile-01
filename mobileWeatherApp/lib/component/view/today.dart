import 'package:flutter/material.dart';

class Today extends StatefulWidget  {
  const Today({super.key});
  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("It's rainy here"),
    );
  }
}
