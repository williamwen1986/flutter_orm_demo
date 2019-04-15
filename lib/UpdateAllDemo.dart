import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';


class UpdateAllDemo extends StatefulWidget {
  @override
  _UpdateAllDemoState createState() => _UpdateAllDemoState();
}

class _UpdateAllDemoState extends State<UpdateAllDemo>{

  List userList = new List();

  @override
  void initState() {
    super.initState();
    Query("Student").all().then((List l) {
      setState(() {
        userList = l;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Update Demo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Query("Student").update({"name":"test all update"});
          Query("Student").all().then((List l) {
            setState(() {
              userList = l;
            });
          });
        },
        child: Text("UPDATE", style: const TextStyle(fontSize: 10.0)),
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


