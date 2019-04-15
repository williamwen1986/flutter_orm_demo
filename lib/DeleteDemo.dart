import 'package:flutter/material.dart';
import 'DeleteAllDemo.dart';
import 'DeleteByPrimaryKeyDemo.dart';
import 'DeleteByCondictionsDemo.dart';
import 'DeleteSqlDemo.dart';

class DeleteDemo extends StatefulWidget {
  @override
  _DeleteDemoState createState() => _DeleteDemoState();
}

class _DeleteDemoState extends State<DeleteDemo> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Delete Demo"),
      ),
      body:  new ListView.builder(
        itemCount:4,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          String text = "";
          Widget w;
          if(i == 0){
            text = "delete all";
            w = new DeleteAllDemo();
          } else if(i == 1)  {
            text = "delete by primary key";
            w = new DeleteByPrimaryKeyDemo();
          } else if(i == 2)  {
            text = "delete by condictions";
            w = new DeleteByCondictionsDemo();
          } else if(i == 3)  {
            text = "delete by where and binding";
            w = new DeleteSqlDemo();
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


