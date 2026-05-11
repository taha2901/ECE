import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/address_model.dart';

class AddressRepository {
  static const _databaseName = 'real_ecommerce_addresses.db';
  static const _databaseVersion = 1;
  static const _tableName = 'addresses';

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        label TEXT NOT NULL,
        fullAddress TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        isDefault INTEGER NOT NULL
      )
    ''');
  }

  Future<List<AddressModel>> getAddresses() async {
    final db = await _db;
    final rows = await db.query(
      _tableName,
      orderBy: 'isDefault DESC, label ASC',
    );
    return rows.map(AddressModel.fromMap).toList();
  }

  Future<void> addAddress(AddressModel address) async {
    final db = await _db;
    await db.transaction((txn) async {
      if (address.isDefault) {
        await txn.update(_tableName, {'isDefault': 0});
      }
      await txn.insert(
        _tableName,
        address.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> updateAddress(AddressModel address) async {
    final db = await _db;
    await db.transaction((txn) async {
      if (address.isDefault) {
        await txn.update(_tableName, {'isDefault': 0});
      }
      await txn.update(
        _tableName,
        address.toMap(),
        where: 'id = ?',
        whereArgs: [address.id],
      );
    });
  }

  Future<void> deleteAddress(String id) async {
    final db = await _db;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setDefaultAddress(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.update(_tableName, {'isDefault': 0});
      await txn.update(
        _tableName,
        {'isDefault': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}
