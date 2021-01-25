import 'package:flutter/material.dart';
import 'car.dart';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cars Database',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
  List<Car> cars = [];
  List<Car> carsByName = [];
  //Controllers for insert
  var nameController = TextEditingController();
  var milesController = TextEditingController();
  //Controllers for delete
  var delidController = TextEditingController();
  //Controllers for update
  var updIdController = TextEditingController();
  var updNameController = TextEditingController();
  var updMilesController = TextEditingController();
  //Controller for search
  var searchController = TextEditingController();

  var _globalkey = new GlobalKey<ScaffoldState>();

  void showMassege(String msg){

    _globalkey.currentState.showSnackBar(SnackBar(content: Text(msg)));

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _globalkey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Insert'),
              Tab(text: 'Show All'),
              Tab(text: 'Search'),
              Tab(text: 'Update'),
              Tab(text: 'Delete'),
            ],
          ),
          title: Text("Project"),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car Name'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car Miles'),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () {
                      _addCar();
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: cars.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == cars.length) {
                    return RaisedButton(
                      child: Text("Refresh"),
                      onPressed: () {
                        setState(() {
                          _showAll();
                        });
                      },
                    );
                  }

                  return Container(
                    height: 30,
                    child: Center(
                      child: Text(
                        cars[index].id.toString() +
                            " - " +
                            cars[index].name +
                            " - " +
                            cars[index].miles.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car Name'),
                      onChanged: (text) {
                        if (text.length >= 2) {
                          setState(() {
                            _search(text);
                          });
                        } else {
                          setState(() {
                            carsByName.clear();
                          });
                        }
                      },
                    ),
                    height: 100,
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: carsByName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              carsByName[index].id.toString() +
                                  " - " +
                                  carsByName[index].name +
                                  " - " +
                                  carsByName[index].miles.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: updIdController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car ID'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: updNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car Name'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: updMilesController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car Miles'),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      _updateCar();
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: delidController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Car ID'),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Delete'),
                    onPressed: () {
                      _delCar();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCar() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: nameController.text,
      DatabaseHelper.columnMiles: int.parse(milesController.text),
    };

    //var c2 = new Car(0, 'abc', 1200);

    Car c = Car.fromMap(row);
    var id = await dbHelper.insert(c);

    showMassege("Car with id no $id has been added");

    setState(() {
      nameController.text = "";
      milesController.text = "";
    });
  }

  void _delCar() async {
    if (delidController.text.isNotEmpty)
      var id = await dbHelper.delete(int.parse(delidController.text));
  }

  void _updateCar() async {
    Car c = Car(int.parse(updIdController.text), updNameController.text,
        int.parse(updMilesController.text));
    var rowsAffected = await dbHelper.update(c);
  }

  void _showAll() async {
    final allRows = await dbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((element) => cars.add(Car.fromMap(element)));
  }

  void _search(name) async {
    final allRows = await dbHelper.queryRows(name);
    carsByName.clear();
    allRows.forEach((element) => carsByName.add(Car.fromMap(element)));
  }
}
