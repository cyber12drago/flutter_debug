import 'package:sqflite/sqflite.dart';

class Model {
  Future<void> onConfigure(Database db) async {
    print('[db] configure version ${await db.getVersion()}');
  }

  Future<void> onOpen(Database db, int version) async {
    print('[db] open version ${await db.getVersion()}');
  }

  Future<void> onCreate(Database db, int version) async {
    print('[db] create version ${version.toString()}');
    final sql = '''
      CREATE TABLE IF NOT EXISTS Siswa (
        id_siswa INTEGER PRIMARY KEY NOT NULL,
        first_name TEXT(20),
        last_name TEXT(20),
        gender TEXT(6),
        grade TEXT(3),
        address TEXT(45),
        mobile_phone TEXT(13),
        hobbies TEXT,
        created_at TEXT,
        updated_at TEXT
      );
    ''';
    await db.execute(sql);
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion > oldVersion) {
      // TODO: place migration script here
    }
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion < oldVersion) {
      // TODO: place migration script here
    }
  }
}