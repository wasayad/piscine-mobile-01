import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const TabBar(
        dividerHeight: 0,
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.settings),
            text: "Currently",
          ),
          Tab(
            icon: Icon(Icons.calendar_today),
            text: "Today",
          ),
          Tab(
            icon: Icon(Icons.calendar_month),
            text: "Weekly",
          ),
        ],
      ),
    );
  }
}
