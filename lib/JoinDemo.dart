import 'package:flutter/material.dart';
import 'InnerJoinDemo.dart';
import 'LeftJoinDemo.dart';
import 'ForeignKeyJoinDemo.dart';
import 'JoinByWhereDemo.dart';
import 'JoinPortionColumnsDemo.dart';
import 'JoinByGroupDemo.dart';
import 'JoinOrderByDemo.dart';

class JoinDemo extends StatefulWidget {
  @override
  _JoinDemoState createState() => _JoinDemoState();
}

class _JoinDemoState extends State<JoinDemo> {

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
        title: new Text("Join Demo"),
      ),
      body:  new ListView.builder(
        itemCount:7,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          String text = "";
          Widget w;
          if(i == 0) {
            text = "inner join";
            w = new InnerJoinDemo();
          } else if(i == 1){
            text = "left join";
            w = new LeftJoinDemo();
          } else if(i == 2){
            text = "Join foreign key";
            w = new ForeignKeyJoinDemo();
          } else if(i == 3)  {
            text = "Join where sql";
            w = new JoinByWhereDemo();
          } else if(i == 4)  {
            text = "Join portion columns";
            w = new JoinPortionColumnsDemo();
          } else if(i == 5)  {
            text = "Join group by having";
            w = new JoinByGroupDemo();
          } else if(i == 6)  {
            text = "Join order by";
            w = new JoinOrderByDemo();
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


