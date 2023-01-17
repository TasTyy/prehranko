import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final int age;
  final int height;
  final int weight;
  final bool boolWeight;
  final num calories;
  

  User({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.boolWeight,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'height':height,
    'weight': weight,
    'boolWeight': boolWeight,
    'calories': calories,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    age: json['age'],
    height: json['height'],
    weight: json['weight'],
    boolWeight: json['boolWeight'],
    calories: json['calories'],
  );
}