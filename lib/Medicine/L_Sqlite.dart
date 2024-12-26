import 'package:flutter_application_8/Medicine/L_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _tableName = 'medicines';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'medicine.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dosage TEXT, type TEXT, time TEXT)',
      );
    });
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert(
      _tableName,
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        name: maps[i]['name'],
        dosage: maps[i]['dosage'],
        type: maps[i]['type'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update(
      _tableName,
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
