import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prehranko/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late num _age, _height, _weight;
  bool _gainLose = false;

  num calculateCalories() {
    num calories = (10 * _weight) + (6.25 * _height) + (5 * _age) + 305;
    return calories.floor();
  }

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
              onSaved: (input) => _age = num.parse(input!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Height"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid height" : null,
              onSaved: (input) => _height = num.parse(input!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Weight"),
              validator: (input) => input!.trim().isEmpty ? "Please enter a valid weight" : null,
              onSaved: (input) => _weight = num.parse(input!),
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
      num _calories = 0;
      
      final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
      if (_gainLose == false) {
        _calories = calculateCalories() + 300;
      } else {
        _calories = calculateCalories() + 500;
      }
      
      final json = {
        'name': _name,
        'age': _age,
        'height': _height,
        'weight': _weight,
        'boolWeight': _gainLose,
        'calories': _calories,
      };

      await docUser.set(json);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
    }
  }
}