import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

class DeleteAllDemo extends StatefulWidget {
  @override
  _DeleteAllDemoState createState() => _DeleteAllDemoState();
}

class _DeleteAllDemoState extends State<DeleteAllDemo>{

  List userList = new List();

  @override
  void initState() {
    super.initState();
    Query("Student").delete();
    List orms = new List();
    for(int i = 0 ; i < 100 ; i++) {
      List words = new List();
      words.addAll(generateWordPairs().take(1));
      WordPair np = words[0];
      String name = np.asString;
      int score = Random().nextInt(100);
      String className = "class${score%3}";
      Map m = {"name":name, "class":className, "score":score};
      orms.add(m);
    }
    FlutterOrmPlugin.batchSaveOrms("Student", orms).then((_){
      Query("Student").all().then((List l) {
        setState(() {
          userList = l;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Delete Demo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Query("Student").delete();
          Query("Student").all().then((List l) {
            setState(() {
              if(l != null) {
                userList = l;
              } else {
                userList = [];
              }
            });
          });
        },
        child: Text("DELETE", style: const TextStyle(fontSize: 10.0)),
        foregroundColor: Colors.black,
      ),
      body:  new ListView.builder(
        itemCount: userList.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          Map data = userList[i];
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


