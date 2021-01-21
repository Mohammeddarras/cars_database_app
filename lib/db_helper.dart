import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'car.dart';

class DatabaseHelper {

  static final _databaseName = "cardb.db";
  static final _databaseVersion = 1;
  static final table = "cars_table";

  static final columnId = "id";
  static final columnName = "name";
  static final columnMiles = "miles";

  //Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  _initDatabase () async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path ,version: _databaseVersion, onCreate: _onCreate );
  }

  Future<Database> get database async{
    if(_database != null )return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future _onCreate(Database db , int version) async{
    await db.execute('''
    creat table $table(
    $columnId integer primary key autoincrement,
    $columnName text not null,
    $columnMiles integer)
    ''');
  }

  Future<int> insert (car c) async{
    Database db = await instance.database;

    return await db.insert(table, {columnName: c.name, columnMiles: c.miles});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async{
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async{
    Database db = await instance.database;
    return await db.query(table, where: "$columnName like '%$name%'");
  }

  Future<int> queryRowCount()async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("select count(*) from $table"));
  }
  
  Future<int> delete(int id) async{
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId=?', whereArgs: [id]);
  }
  
  Future<int> update(car c) async{
    Database db = await instance.database;
    return await db.update(table, c.toMap(), where: '$columnId=?', whereArgs: [c.id]);
  }

}