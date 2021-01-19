import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'car.dart';

class DatabaseHelper {

  static final _databaseName = "cardb.db";
  static final _databaseVersion = 1;
  static final _table = "cars_table";

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
    creat table $_table(
    $columnId integer primary key autoincrement,
    $columnName text not null,
    $columnMiles integer)
    ''');
  }

  Future insert (car c) async{
    Database db = await instance.database;

    return await db.insert(table, {columnName: c.name, columnMiles: c.miles});

  }

}