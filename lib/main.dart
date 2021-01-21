import 'package:flutter/material.dart';
import 'car.dart';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Car Database",
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final dbHelper = DatabaseHelper.instance;
  List<int> cars = [];
  List<int> carsByName = [];

  var nameController = TextEditingController();
  var milesController = TextEditingController();

  var delidController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Insert"),
                Tab(text: "Show All"),
                Tab(text: "Search"),
                Tab(text: "Update"),
                Tab(text: "Delete"),
              ],
            ),
            title: Text('Database Cars'),
          ),
          body: TabBarView(
            children: [
              Center(child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: OutlineInputBorder
                        (borderRadius: BorderRadius.circular(20)),
                          hintText: 'car name'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(border: OutlineInputBorder
                        (borderRadius: BorderRadius.circular(20)),
                          hintText: 'car miles'),
                    ),
                  ),
                  RaisedButton(
                      onPressed: (){_addCar();},
                    child: Text('Save'),
                      ),
                ],
              ),),
              Container(),
              Container(),
              Container(),
              Center(child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: delidController,
                      decoration: InputDecoration(border: OutlineInputBorder
                        (borderRadius: BorderRadius.circular(20)),
                          hintText: 'car ID'),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){_delCar();},
                    child: Text('Delete'),
                  ),
                ],
              )),

            ],
          ),
        ),
    );
  }

  void _addCar() async{
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : nameController.text,
      DatabaseHelper.columnMiles : milesController.text,
    };
    car c = car.fromMap(row);
    var id = await dbHelper.insert(c);
  }


  void _delCar() async{
    if(!delidController.text.isEmpty)
      var id = await dbHelper.delete(int.parse(delidController.text));  }
}
