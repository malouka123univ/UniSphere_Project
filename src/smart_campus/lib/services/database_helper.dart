import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/announcement_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('campus.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE announcements (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL
      )
    ''');
  }

  Future<void> cacheAnnouncements(List<AnnouncementModel> list) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('announcements');
      for (var item in list) {
        await txn.insert('announcements', item.toJson());
      }
    });
  }

  Future<List<AnnouncementModel>> getCachedAnnouncements() async {
    final db = await database;
    final maps = await db.query('announcements');
    return maps.map((json) => AnnouncementModel.fromJson(json)).toList();
  }
}
