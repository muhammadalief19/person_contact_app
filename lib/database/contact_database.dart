import 'package:path/path.dart';
import 'package:person_contact_app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDatabase {
  static final ContactDatabase instance = ContactDatabase._init();

  ContactDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contact.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE $tableContact(
      ${ContactField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ContactField.name} TEXT NOT NULL,
      ${ContactField.phoneNumber} TEXT NOT NULL,
      ${ContactField.time} TEXT NOT NULL
    )
    ''';

    await db.execute(sql);
  }

  Future<Contact> create(Contact contact) async {
    final db = await instance.database;
    final id = await db.insert(tableContact, contact.toJson());
    return contact.copy(id: id);
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await instance.database;
    final results = await db.query(tableContact);

    return results.map((json) => Contact.fromJson(json)).toList();
  }

  Future<Contact> getNoteById(int id) async {
    final db = await instance.database;
    final result = await db
        .query(tableContact, where: '${ContactField.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Contact.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> deleteContactById(int id) async {
    final db = await instance.database;
    return await db
        .delete(tableContact, where: '${ContactField.id} = ?', whereArgs: [id]);
  }

  Future<int> updateContactById(Contact contact) async {
    final db = await instance.database;
    return await db.update(tableContact, contact.toJson(),
        where: '${ContactField.id} = ?', whereArgs: [contact.id]);
  }
}
