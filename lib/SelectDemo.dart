import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'SelectAllDemo.dart';
import 'SelectFirstDemo.dart';
import 'SelectByPrimaryKeyDemo.dart';
import 'SelectWhereDemo.dart';
import 'SelectPortionColumnsDemo.dart';
import 'SelectGroupbyHavingDemo.dart';

class SelectDemo extends StatefulWidget {
  @override
  _SelectDemoState createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Query("Student").delete();
    List orms = new List();
    for(int i = 0 ; i < 99 ; i++) {
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
        title: new Text("Select Demo"),
      ),
      body:  new ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          String text = "";
          Widget w;
          if(i == 0){
            text = "select all";
            w = new SelectAllDemo();
          } else if(i == 1)  {
            text = "select first";
            w = new SelectFirstDemo();
          } else if(i == 2)  {
            text = "select by primary key";
            w = new SelectByPrimaryKeyDemo();
          } else if(i == 3)  {
            text = "select where";
            w = new SelectWhereDemo();
          } else if(i == 4)  {
            text = "select portion columns";
            w = new SelectPortionColumnsDemo();
          } else if(i == 5)  {
            text = "select groupby having";
            w = new SelectGroupbyHavingDemo();
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


