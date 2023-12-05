import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  const AppBarComponent({
    required this.searchText,
    required this.onChanged,
    super.key
  });

  final String searchText;
  final ValueChanged<String> onChanged;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 200,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:  Row(
        children: <Widget>[
           Expanded(
            flex: 3,
              child: TextField(
                onSubmitted: (String value) {
                  widget.onChanged(value);
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    filled: true,
                    labelText: 'search',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    icon: Icon(Icons.search)),
              )),
          Expanded(
              child: IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => {},
                  iconSize: 50,
          )),
        ],
      ),
    );
  }
}
