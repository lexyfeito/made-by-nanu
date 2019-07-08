import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/settings.dart';

class DbHelper<T> {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MadeByNanu.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 15;

  // Make this a singleton class.
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpdateDebug
    );
  }

  Future _onUpdateDebug(db, oldVersion, newVersion) async {
    _cleanDb(db);
    _onCreate(db, newVersion);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    try {
      await db.execute("CREATE TABLE Settings ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "street TEXT,"
          "city TEXT,"
          "state TEXT,"
          "zip_code TEXT,"
          "phone_number TEXT"
          ")");
    } catch (e) {

    }

    try {
      await db.execute("CREATE TABLE Order_Item ("
          "order_id INTEGER,"
          "item_id INTEGER,"
          "shoe_size TEXT,"
          "shoe_color TEXT,"
          "count INTEGER"
          ")");
    } catch (e) {}

    try {
      await db.execute("CREATE TABLE Orders ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "added TEXT"
          ")");
    } catch (e) {}

    try {
      await db.execute("CREATE TABLE Cart ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "item_id INTEGER,"
          "shoe_size TEXT,"
          "shoe_color TEXT"
          ")");
    } catch (e) {}

    var settings = Settings('', '', '', '', '');
    db.insert('Settings', settings.toJson());
  }

  _cleanDb(Database db,) async {
    try {
      await db.rawQuery('DROP TABLE Settings');
    } catch (e) {
      print(e.toString());
    }
    try {
      await db.rawQuery('DROP TABLE Order_Item');
    } catch (e) {
      print(e.toString());
    }
    try {
      await db.rawQuery('DROP TABLE Orders');
    } catch (e) {
      print(e.toString());
    }
    try {
      await db.rawQuery('DROP TABLE Cart');
    } catch (e) {
      print(e.toString());
    }
  }
}