import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prehranko/user.dart';


class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  DateTime _currentdate = DateTime.now();
  num calorieSum = 0;
  double water = 0, liters = 0.1;
  late String _searchText = '';
  List<String> _items = [];


  @override
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) => 
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yMMMMd').format(_currentdate)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<User>> (
                    stream: readUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong! ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('You can still eat ${snapshot.data![0].calories} calories'),
                            SizedBox(height: 8),
                            LinearProgressIndicator(value: 0),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('... calories eaten'),
                                Text('Goal: ${snapshot.data![0].calories}'),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text('You still have to drink ${4 - liters}'),
                      SizedBox(height: 8),
                      LinearProgressIndicator(value: water),
                      SizedBox(height: 8),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          water = water + 0.05;
                          if (water == 4) {
                            water = 4;
                          }
                        }, 
                        child: Text('Add 0.1l'),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search), 
                            hintText: 'Search...',
                          ),
                          onChanged: (val) {
                            _searchText = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('food').snapshots(),
                    builder: ((context, snapshots) {
                      return (snapshots.connectionState == ConnectionState.waiting)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          :ListView.builder(
                            shrinkWrap: false,
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context,index) {
                              var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;
                              
                              if (_searchText.isEmpty) {
                                return ListTile(
                                  title: Text(
                                    data['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    data['weight'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Text(
                                    data['calories'],
                                    maxLines: 0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }
                              if (data['name'].toString().startsWith(_searchText.toLowerCase())){
                                return ListTile(
                                  title: Text(
                                    data['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    data['weight'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Text(
                                    data['calories'],
                                    maxLines: 0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }
                              return Container();
                            });
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        }, 
      ),
    );
  }
}