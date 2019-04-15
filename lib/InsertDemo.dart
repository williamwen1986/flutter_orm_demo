import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';


class InsertDemo extends StatefulWidget {
  @override
  _InsertDemoState createState() => _InsertDemoState();
}

class _InsertDemoState extends State<InsertDemo> {
  List userList = new List();

  @override
  void initState() {
    super.initState();
    Query("Student").delete();
    Query("Student").all().then((List l) {
      setState(() {
        if(l != null) {
          userList = l;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Insert Demo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List words = new List();
          words.addAll(generateWordPairs().take(1));
          WordPair np = words[0];
          String name = np.asString;
          int score = Random().nextInt(100);
          String className = "class${score%3}";
          Map m = {"name":name, "class":className, "score":score};
          FlutterOrmPlugin.saveOrm("Student", m);
          Query("Student").all().then((List l) {
            setState(() {
              userList = l;
            });
          });
        },
        child: Text("INSERT", style: const TextStyle(fontSize: 10.0)),
        foregroundColor: Colors.black,
      ),
      body: userList.length <= 0
          ? new Center(
              child: new RaisedButton(
                onPressed: () {
                  List words = new List();
                  words.addAll(generateWordPairs().take(1));
                  WordPair np = words[0];
                  String name = np.asString;
                  int score = Random().nextInt(100);
                  String className = "class${score%3}";
                  Map m = {"name":name, "class":className, "score":score};
                  FlutterOrmPlugin.saveOrm("Student", m);
                  Query("Student").all().then((List l) {
                    setState(() {
                      userList = l;
                    });
                  });
                },
                child: new Text('Its empty, tap to add first data!'),
              ),
            )
          : new ListView.builder(
              itemCount: userList.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, i) {
                Map data = userList[i];

                List words = new List();
                words.addAll(generateWordPairs().take(1));
                WordPair wp = words[0];
                String t = wp.asString;

                return GestureDetector(
                  child: new Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                      new Text('name  : ${data["name"]}', style: const TextStyle(fontSize: 15.0)),
                      new Text('studentId: ${data["studentId"]}', style: const TextStyle(fontSize: 15.0)),
                      new Text('class : ${data["class"]}', style: const TextStyle(fontSize: 15.0)),
                      new Text('score : ${data["score"]}', style: const TextStyle(fontSize: 15.0)),
                      new Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
