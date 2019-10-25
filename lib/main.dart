import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'SelectDemo.dart';
import 'InsertDemo.dart';
import 'UpdateDemo.dart';
import 'DeleteDemo.dart';
import 'JoinDemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    Map<String , Field> fields = new Map<String , Field>();
    fields["studentId"] = Field(FieldType.Integer, primaryKey: true , autoIncrement: true);
    fields["name"] = Field(FieldType.Text);
    fields["class"] = Field(FieldType.Text, foreignKey: true, to: "School_Class");
    fields["score"] = Field(FieldType.Real);

    Map<String , Field> classFields = new Map<String , Field>();
    classFields["className"] = Field(FieldType.Text, primaryKey: true );
    classFields["teacher"] = Field(FieldType.Text);

    Map<String , Field> matchFields = new Map<String , Field>();
    matchFields["matchId"] = Field(FieldType.Integer, primaryKey: true , autoIncrement: true);
    matchFields["matchName"] = Field(FieldType.Text);
    matchFields["winnerId"] = Field(FieldType.Integer);

    FlutterOrmPlugin.createTable("School","Match",matchFields);
    FlutterOrmPlugin.createTable("School","Class",classFields);
    FlutterOrmPlugin.createTable("School","Student",fields);

    Map<String , dynamic> user = new Map<String , dynamic>();
    user["studentId"] = 1;
    user["name"] = "tom";
    user["class"] = "class1";
    user["score"] = 1;
    FlutterOrmPlugin.saveOrm("Student", user);

    Query("Student").whereByColumFilters([
      WhereCondiction("score", WhereCondictionType.IN, [1])
    ]).delete().then((_){
      int a = 0;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_orm_plugin example app'),
        ),
        body: Center(
          child: new ListView.builder(
            itemCount: 5,
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, i) {
              String text;
              Widget go;
              if (i == 0) {
                text = "insert";
                go = new InsertDemo();
              } else if(i == 1){
                text = "select";
                go = new SelectDemo();
              } else if(i == 2){
                text = "update";
                go = new UpdateDemo();
              } else if(i == 3){
                text = "delete";
                go = new DeleteDemo();
              } else if(i == 4){
                text = "join";
                go = new JoinDemo();
              }
              Widget w = GestureDetector(
                child: new ListTile(
                  title: new Text(text, style: const TextStyle(fontSize: 26.0)),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => go),
                  );
                },
              );
              return new Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  w,
                  new Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
