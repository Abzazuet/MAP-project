import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/models/datos.dart';
import 'package:path/path.dart';

class Operation{
  Operation._();
  static final Operation db = Operation._();
  static Database _database;
  Future <Database> get database async{
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  static const tableDatos = """
  CREATE TABLE IF NOT EXISTS datos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sys STRING,
            dys STRING,
            ppm STRING,
            tem STRING,
            fecha STRING
  );""";

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "pani.db");
    return await openDatabase(path, version: 2,
    onCreate: (Database db, int version) async {
      await db.execute(tableDatos);
    }
    );
  }
  Future <void> insert(Datos datos) async{
    int result=0;
    final db = await database;
    result = await db.insert('datos', datos.toMap());
    return result;
  }
  Future <List<Datos>> read() async{
    final db = await database;
    final List<Map<String, dynamic>> queryResult = await db.query('datos');
    return queryResult.map((e) => Datos.fromMap(e)).toList();
  }
  Future<void> delete(Datos dato) async{
    final db = await database;
    await db.delete(
        'datos',
        where: "fecha = ?",
        whereArgs: [dato.fecha],
    );
  }
  Future<void> deleteAll() async{
    final db = await database;
    await db.delete(
      'datos'
    );
  }
}
