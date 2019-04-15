import 'package:flutter/material.dart';
import 'WhereCondictionDemo.dart';
import 'WhereMutiCondictionDemo.dart';
import 'WhereSortDemo.dart';
import 'WhereSqlDemo.dart';

class SelectWhereDemo extends StatefulWidget {
  @override
  _SelectWhereDemoState createState() => _SelectWhereDemoState();
}

class _SelectWhereDemoState extends State<SelectWhereDemo>{

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Select Demo"),
      ),
      body:  new ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          String text = "";
          Widget w;
          if(i == 0){
            text = "where by one condition";
            w = new WhereCondictionDemo();
          } else if(i == 1)  {
            text = "where by muti condition";
            w = new WhereMutiCondictionDemo();
          } else if(i == 2)  {
            text = "where order by sore desc";
            w = new WhereSortDemo();
          } else if(i == 3)  {
            text = "where by sql and bind";
            w = new WhereSqlDemo();
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


