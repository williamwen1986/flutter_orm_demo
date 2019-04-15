import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'UpdateAllDemo.dart';
import 'UpdateByPrimaryKeyDemo.dart';
import 'UpdateByCondictionsDemo.dart';
import 'UpdateSqlDemo.dart';

class UpdateDemo extends StatefulWidget {
  @override
  _UpdateDemoState createState() => _UpdateDemoState();
}

class _UpdateDemoState extends State<UpdateDemo> {

  @override
  void dispose() {
    super.dispose();
  }

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
    FlutterOrmPlugin.batchSaveOrms("Student", orms);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Update Demo"),
      ),
      body:  new ListView.builder(
        itemCount:4,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          String text = "";
          Widget w;
          if(i == 0){
            text = "update all";
            w = new UpdateAllDemo();
          } else if(i == 1)  {
            text = "update by primary key";
            w = new UpdateByPrimaryKeyDemo();
          } else if(i == 2)  {
            text = "update by condictions";
            w = new UpdateByCondictionsDemo();
          } else if(i == 3)  {
            text = "update by where and binding";
            w = new UpdateSqlDemo();
          }
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => w),
              );
            },
            child: new Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  title: new Text(text, style: const TextStyle(fontSize: 26.0)),
                ),
                new Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}


