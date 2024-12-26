import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute(''' 
      CREATE TABLE attendance (
        id $idType,
        name $textType,
        date $textType,
        remark $textType
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(''' 
        ALTER TABLE attendance ADD COLUMN date TEXT;
        ALTER TABLE attendance ADD COLUMN remark TEXT;
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS attendance');
      await _createDB(db, newVersion);
    }
  }

  Future<int> addAttendance(Map<String, dynamic> attendance) async {
    final db = await instance.database;
    return await db.insert('attendance', attendance);
  }

  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    final db = await instance.database;
    return await db.query('attendance');
  }

  Future<int> updateAttendance(Map<String, dynamic> attendance) async {
    final db = await instance.database;
    return await db.update(
      'attendance',
      attendance,
      where: 'id = ?',
      whereArgs: [attendance['id']],
    );
  }

  Future<int> deleteAttendance(int id) async {
    final db = await instance.database;
    return await db.delete(
      'attendance',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
