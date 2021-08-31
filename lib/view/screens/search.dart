import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace)),
        title: Flexible(
          child: TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Search for books...',
            ),
          ),
        ),
      ),
    );
  }
}
