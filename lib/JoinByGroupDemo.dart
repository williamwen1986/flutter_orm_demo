import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

class JoinByGroupDemo extends StatefulWidget {
  @override
  _JoinByGroupDemoState createState() => _JoinByGroupDemoState();
}

class _JoinByGroupDemoState extends State<JoinByGroupDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List userList = new List();

  List classList = new List();

  List joinedList = new List();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

    Query("Student").delete();
    List orms = new List();
    for (int i = 0; i < 99; i++) {
      List words = new List();
      words.addAll(generateWordPairs().take(1));
      WordPair np = words[0];
      String name = np.asString;
      int score = Random().nextInt(100);
      String className = "class${score % 3}";
      Map m = {"name": name, "class": className, "score": score};
      orms.add(m);
    }
    FlutterOrmPlugin.batchSaveOrms("Student", orms).then((_){
      Query("Student").all().then((List l) {
        setState(() {
          userList = l;
        });
      });
    });

    print("111");
    Query("Match").delete();
    Query("Class").delete();

    List classes = new List();
    for (int i = 0; i < 3; i++) {
      List words = new List();
      words.addAll(generateWordPairs().take(1));
      WordPair np = words[0];
      String name = np.asString;
      String className = "class$i";
      Map m = {"className": className, "teacher": name};
      classes.add(m);
    }
    FlutterOrmPlugin.batchSaveOrms("Class", classes).then((_){
      Query("Class").all().then((List l) {
        setState(() {
          classList = l;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return joinedList.length > 0
        ? getJoinedWidget(context)
        : getTwoClassesWidget(context);
  }

  Widget getJoinedWidget(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Join Demo"),
      ),
      body: new ListView.builder(
        itemCount: joinedList.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          Map data = joinedList[i];
          Map cls = joinedList[i]["Class"];
          return GestureDetector(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('name  : ${data["name"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('studentId: ${data["studentId"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('class : ${data["class"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('score : ${data["score"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('className  : ${cls["className"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('teacher: ${cls["teacher"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getTwoClassesWidget(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          JoinCondiction c = new JoinCondiction("Class");
          c.type = JoinType.INNER;
          Query("Student").join(c).needColums(["class"]).groupBy(["Student.class"]).havingByBindings("avg(Student.score) > ?", [40]).all().then((List l) {
            setState(() {
              joinedList = l;
            });
          });
        },
        child: Text("JOIN", style: const TextStyle(fontSize: 10.0)),
        foregroundColor: Colors.black,
      ),
      appBar: new AppBar(
        title: new Text('Join demo'),
        bottom: new TabBar(
          tabs: <Widget>[
            new Tab(
              text: "student",
            ),
            new Tab(
              text: "classes",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new ListView.builder(
              itemCount: userList.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, i) {
                Map data = userList[i];
                return GestureDetector(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('name  : ${data["name"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('studentId: ${data["studentId"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('class : ${data["class"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('score : ${data["score"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Divider(),
                    ],
                  ),
                );
              }),
          new ListView.builder(
              itemCount: classList.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, i) {
                Map data = classList[i];
                return GestureDetector(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('className  : ${data["className"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('teacher: ${data["teacher"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Divider(),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
