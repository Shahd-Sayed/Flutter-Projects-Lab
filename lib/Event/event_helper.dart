import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabasesHelper {
  static final _databaseName = "EventDB.db";
  static final _databaseVersion = 1;

  static final table = 'events';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDate = 'date';
  static final columnTime = 'time';
  static final columnLocation = 'location';
  static final columnDescription = 'description';
  static final columnStatus = 'status';
  static final columnIsFavorite = 'isFavorite';

  DatabasesHelper._privateConstructor();
  static final DatabasesHelper instance = DatabasesHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      readOnly: false,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT,
        $columnLocation TEXT NOT NULL,
        $columnDescription TEXT,
        $columnStatus INTEGER NOT NULL,
        $columnIsFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> addEvent(Map<String, dynamic> event) async {
    Database db = await database;
    return await db.insert(table, event);
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getFavoriteEvents() async {
    Database db = await database;
    final result = await db.query(
      table,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
    );
    return result;
  }

  Future<int> updateEvent(int id, Map<String, dynamic> updatedEvent) async {
    Database db = await database;
    return await db.update(
      table,
      updatedEvent,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    final db = await database;
    try {
      final result = await db.rawQuery('PRAGMA table_info($table)');
      bool columnExists = result.any((column) => column['name'] == columnIsFavorite);

      if (!columnExists) {
        print('Error: Column isFavorite does not exist.');
        return;
      }

      await db.update(
        table,
        {columnIsFavorite: isFavorite ? 1 : 0},
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  Future<int> deleteEvent(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
