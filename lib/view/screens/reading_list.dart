import 'package:flutter/material.dart';

class ReadingList extends StatefulWidget {
  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading List'),
      ),
      body: Text(''),
    );
  }
}
