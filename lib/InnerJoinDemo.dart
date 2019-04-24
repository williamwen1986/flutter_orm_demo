import 'package:flutter/material.dart';
import 'package:flutter_orm_plugin/flutter_orm_plugin.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

class InnerJoinDemo extends StatefulWidget {
  @override
  _InnerJoinDemoState createState() => _InnerJoinDemoState();
}

class _InnerJoinDemoState extends State<InnerJoinDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List userList = new List();

  List matchList = new List();

  List joinedList = new List();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);

    Query("Student").delete();
    List orms = new List();
    for (int i = 0; i < 5; i++) {
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

    Query("Match").delete();
    List matchs = new List();
    for (int i = 0; i < 5; i++) {
      List words = new List();
      words.addAll(generateWordPairs().take(1));
      WordPair np = words[0];
      String name = np.asString;
      Map m = {"matchName": name, "winnerId": i + 2};
      matchs.add(m);
    }
    FlutterOrmPlugin.batchSaveOrms("Match", matchs).then((_){
      Query("Match").all().then((List l) {
        setState(() {
          matchList = l;
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
          Map match = joinedList[i]["Match"];
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
                new Text('matchId  : ${match["matchId"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('matchName: ${match["matchName"]}',
                    style: const TextStyle(fontSize: 15.0)),
                new Text('winnerId : ${match["winnerId"]}',
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
          JoinCondiction c = new JoinCondiction("Match");
          c.type = JoinType.INNER;
          c.matchColumns = {"studentId": "winnerId"};
          Query("Student").join(c).all().then((List l) {
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
              text: "match winner",
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
              itemCount: matchList.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, i) {
                Map data = matchList[i];
                return GestureDetector(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('matchId  : ${data["matchId"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('matchName: ${data["matchName"]}',
                          style: const TextStyle(fontSize: 15.0)),
                      new Text('winnerId : ${data["winnerId"]}',
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
