import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'esam.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    print('path');
    print(path);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''
  CREATE TABLE "notes" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "note" TEXT NOT NULL
  )
 ''');
    batch.execute('''
    CREATE TABLE `stepstable` (
      `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
      `stepsdate` DATETIME NOT NULL,
      `stepsvalue` VARCHAR NOT NULL)
  ''');
    batch.execute('''
    CREATE TABLE `hrtable` (
      `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
      `hrdate` DATETIME NOT NULL,
      `hrvalue` VARCHAR NOT NULL)
  ''');

    batch.execute('''
      CREATE TABLE `caloriestable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `caloriesdate` DATETIME NOT NULL,
        `caloriesvalue` VARCHAR NOT NULL,
        `untillcaloriesdate` DATETIME NOT NULL)
    ''');

    batch.execute('''
      CREATE TABLE `weighttable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `weightsdate` DATETIME NOT NULL,
        `weightvalue` VARCHAR NOT NULL)
    ''');
    batch.execute('''
      CREATE TABLE `heighttable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `heightdate` DATETIME NOT NULL,
        `heightvalue` VARCHAR NOT NULL)
    ''');
    batch.execute('''
      CREATE TABLE `Glucosetable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `Glucosedate` DATETIME NOT NULL,
        `Glucosevalue` VARCHAR NOT NULL)
    ''');

    // Insulin => BODY_FAT_PERCENTAGE
    batch.execute('''
      CREATE TABLE `Insulintable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `Insulindate` DATETIME NOT NULL,
        `Insulinvalue` VARCHAR NOT NULL)
    ''');
    // Carbohydrates => BODY_TEMPERATURE
    batch.execute('''
      CREATE TABLE `Carbohydratestable` (
        `id` INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        `Carbohydratesdate` DATETIME NOT NULL,
        `Carbohydratesvalue` VARCHAR NOT NULL)
    ''');

    batch.commit();

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'esam.db');
    await deleteDatabase(path);
    print('DataBase Deleted');
  }
}
