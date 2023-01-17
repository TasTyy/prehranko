import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  DateTime _currentdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yMMMMd').format(_currentdate)),
      ),
    );
  }
}