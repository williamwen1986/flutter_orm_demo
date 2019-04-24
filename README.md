# flutter\_orm\_plugin

A orm database Flutter plugin. 

之前发了一篇文章[《手把手教你在Flutter项目优雅的使用ORM数据库》](https://juejin.im/post/5c45c72d6fb9a049d81c2b4c)，很多人咨询使用也提了一些宝贵的意见，说不希望要写lua，这样不够优雅，也增加了学习成本。细想了一下，确实是，对flutter项目开发来讲，最好就是纯flutter版的orm框架，于是我就写了一个flutter版的 [orm插件flutter\_orm\_plugin](https://pub.dartlang.org/packages/flutter_orm_plugin) ，使用的[demo](https://github.com/williamwen1986/flutter_orm_demo)我放到github上了，大家可以下载来玩玩。下面我介绍一下flutter\_orm_plugin提供的所有api。

![image](https://raw.githubusercontent.com/williamwen1986/flutter_orm_demo/master/img/main.jpg)

![image](https://raw.githubusercontent.com/williamwen1986/flutter_orm_demo/master/img/select.jpg)

## 添加orm表


flutter\_orm_plugin中一个orm对应一个表，例如demo中Student表，它所在的db名字叫School，表名叫Student，它包含如下四个字段：

**studentId** 在数据库中是Integer类型，主键，自增的。

**name** 在数据库中是Text类型

**class** 在数据库中是Text类型，是外键，关联的表是另一个表Class表

**score** 在数据库中是Real类型

创建这样的表的代码在demo的[main.dart](https://github.com/williamwen1986/flutter_orm_demo/blob/master/lib/main.dart)中

```
	Map<String , Field> fields = new Map<String , Field>();
    fields["studentId"] = Field(FieldType.Integer, primaryKey: true , autoIncrement: true);
    fields["name"] = Field(FieldType.Text);
    fields["class"] = Field(FieldType.Text, foreignKey: true, to: "School_Class");
    fields["score"] = Field(FieldType.Real);
    FlutterOrmPlugin.createTable("School","Student",fields);
```

数据库中某一列的数据通过Field类定义，我们先看看Field的定义就可以知道我们的orm对象支持哪些属性了

```
class Field {

  final FieldType type;//类型包括Integer、Real、Blob、Char、Text、Boolean

  bool unique;//是否惟一

  int maxLength;

  bool primaryKey;//是否主键

  bool foreignKey;//是否外键

  bool autoIncrement;//是否自增

  String to;//关联外键表，以DBName_TableName命名

  bool index;//是否有索引
}

```

## 插入数据

单条插入

```
 Map m = {"name":"william", "class":"class1", "score":96.5};
 FlutterOrmPlugin.saveOrm("Student", m);
```

批量插入

```
 List orms = new List();
 for(int i = 0 ; i < 100 ; i++) {
      Map m = {"name":name, "class":className, "score":score};
      orms.add(m);
 }
 FlutterOrmPlugin.batchSaveOrms("Student", orms);
 
```

## 查询数据

全部查询

```
  Query("Student").all().then((List l) {

  });
  
```

查询第一条

```
 Query("Student").first().then((Map m) {
      
 });
  
```

根据主键查询

```
  Query("Student").primaryKey([1,3,5]).all().then((List l) {
      
  });
     
```

where条件查询

```
  Query("Student").whereByColumFilters([WhereCondiction("score", WhereCondictionType.EQ_OR_MORE_THEN, 90)]).all().then((List l) {
      
  });
     
```

where sql 语句查询

```
  Query("Student").whereBySql("class in (?,?) and score > ?", ["class1","class2",90]).all().then((List l) {
      
  });
     
```

where 查询并排序

```
  Query("Student").orderBy(["score desc",]).all().then((List l) {
      
  });
 
```

查询指定列

```
  Query("Student").needColums(["studentId","name"]).all().then((List l) {
      
  });
 
```

group by 、having 查询

```
  Query("Student").needColums(["class"]).groupBy(["class"]).havingByBindings("avg(score) > ?", [40]).orderBy(["avg(score)"]).all().then((List l) {
    
  });
 
```

## 更新数据

全部更新

```
  Query("Student").update({"name":"test all update"});
 
```

根据主键更新

```
  Query("Student").primaryKey([11]).update({"name":"test update by primary key"});
 
```

根据特定条件更新

```
  Query("Student").whereByColumFilters([WhereCondiction("studentId", WhereCondictionType.LESS_THEN, 5),WhereCondiction("score", WhereCondictionType.EQ_OR_MORE_THEN, 0)]).update({"score":100});
 
```

根据自定义where sql更新

```
  Query("Student").whereBySql("studentId <= ? and score <= ?", [5,100]).update({"score":0});
  

```

## 删除数据

全部删除

```
  Query("Student").delete();
 
```

根据主键删除

```
  Query("Student").primaryKey([1,3,5]).delete();
 
```

根据条件删除

```
  Query("Student").whereByColumFilters([WhereCondiction("studentId", WhereCondictionType.IN, [1,3,5])]).delete();


```

根据自定义where sql删除

```
  Query("Student").whereBySql("studentId in (?,?,?)", [1,3,5]).delete();


```

## 联表查询

inner join

```
  JoinCondiction c = new JoinCondiction("Match");
  c.type = JoinType.INNER;
  c.matchColumns = {"studentId": "winnerId"};
  Query("Student").join(c).all().then((List l) {
            
  });
  
```

left join

```
  JoinCondiction c = new JoinCondiction("Match");
  c.type = JoinType.LEFT;
  c.matchColumns = {"studentId": "winnerId"};
  Query("Student").join(c).all().then((List l) {
            
  });
  
```

利用外键联表

```
  JoinCondiction c = new JoinCondiction("Class");
  c.type = JoinType.INNER;
  Query("Student").join(c).all().then((List l) {

  });
  
```

where sql 联表

```
  JoinCondiction c = new JoinCondiction("Match");
  c.type = JoinType.INNER;
  c.matchColumns = {"studentId": "winnerId"};
  Query("Student").join(c).whereBySql("Student.score > ?",[60]).all().then((List l) {
           
  });
  
```

部分column 联表查询

```
  JoinCondiction c = new JoinCondiction("Match");
  c.type = JoinType.INNER;
  c.matchColumns = {"studentId": "winnerId"};
  Query("Student").join(c).needColums(["name","score"]).all().then((List l) {
            
  });
  
```

group by 、having 联表查询

```
  JoinCondiction c = new JoinCondiction("Class");
  c.type = JoinType.INNER;
  Query("Student").join(c).needColums(["class"]).groupBy(["Student.class"]).havingByBindings("avg(Student.score) > ?", [40]).all().then((List l) {
            
  }); 
   
```

order by 联表查询

```
  JoinCondiction c = new JoinCondiction("Class");
  c.type = JoinType.INNER;
  Query("Student").join(c).orderBy(["Student.score desc"]).all().then((List l) {
            
  });
   
```

## 使用介绍

flutter\_orm\_plugin 已经发布到flutter 插件仓库。只要简单配置即可使用，在yaml文件中加上flutter\_orm\_plugin依赖以及orm框架所需要的lua源文件，flutter\_orm\_plugin会对所有lua代码进行封装，最终使用只需要关心dart接口，对lua是无感的。

```
  flutter_orm_plugin: ^1.0.1
  
  .
  .
  .
  
  assets:
    - packages/flutter_orm_plugin/lua/DB.lua
    - packages/flutter_orm_plugin/lua/orm/model.lua
    - packages/flutter_orm_plugin/lua/orm/cache.lua
    - packages/flutter_orm_plugin/lua/orm/dbData.lua
    - packages/flutter_orm_plugin/lua/orm/tools/fields.lua
    - packages/flutter_orm_plugin/lua/orm/tools/func.lua
    - packages/flutter_orm_plugin/lua/orm/class/fields.lua
    - packages/flutter_orm_plugin/lua/orm/class/global.lua
    - packages/flutter_orm_plugin/lua/orm/class/property.lua
    - packages/flutter_orm_plugin/lua/orm/class/query.lua
    - packages/flutter_orm_plugin/lua/orm/class/query_list.lua
    - packages/flutter_orm_plugin/lua/orm/class/select.lua
    - packages/flutter_orm_plugin/lua/orm/class/table.lua
    - packages/flutter_orm_plugin/lua/orm/class/type.lua
  
```

在ios项目podfile加上luakit 依赖

```
source 'https://github.com/williamwen1986/LuakitPod.git'
source 'https://github.com/williamwen1986/curl.git'

.
.
.

pod 'curl', '~> 1.0.0'
pod 'LuakitPod', '~> 1.0.17'

```

在android项目app的build.gradle加上luakit依赖

```
repositories {

    maven { url "https://jitpack.io" }

}

.
.
.

implementation 'com.github.williamwen1986:LuakitJitpack:1.0.9'

```

完成配置即可使用。
