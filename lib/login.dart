import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prehranko/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _age, _height, _weight;
  bool _gainLose = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Prehranko"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,50),
              // ignore: prefer_const_constructors
              child: Text(
                "Please insert your data.\nChoose also if you want to lose or gain weight.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.lightGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid name" : null,
              onSaved: (input) => _name = input!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Age"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid age" : null,
              onSaved: (input) => _age = input!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Height"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid height" : null,
              onSaved: (input) => _height = input!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Weight"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid weight" : null,
              onSaved: (input) => _weight = input!,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _gainLose = false;
                    _submit();
                  },
                  child: Text("Lose Weight"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _gainLose = true;
                    _submit();
                  },
                  child: Text('Gain Weight'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
      
      final json = {
        'name': _name,
        'age': _age,
        'height': _height,
        'weight': _weight,
        'boolWeight': _gainLose,
      };

      await docUser.set(json);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
    }
  }
}