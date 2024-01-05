// data_helper.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cash_flow.dart';

class DataHelper {
  late Database db;

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}buku_kas.db';
    var itemDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cashflow (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type INTEGER,
      amount INTEGER,
      description TEXT,
      date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      password TEXT
      )
    ''');
  }

  Future<void> resetCashFlow() async {
    Database db = await initDb();
    String currentMonth = DateTime.now().toString().substring(0, 7);
    await db.rawDelete('''
      DELETE FROM cashflow WHERE strftime('%Y-%m', date) = '$currentMonth'
    ''');
  }

  Future<bool> authUser(String username, String password) async {
    db = await initDb();
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    return result.isNotEmpty;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    db = await initDb();
    var result = await db.rawQuery(
        'SELECT * FROM users WHERE username = "$oldPassword" AND password = "$oldPassword"');
    if (result.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE users SET password = "$newPassword" WHERE username = "$oldPassword"');
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteCashFlow(int id) async {
    Database db = await initDb();
    await db.delete('cashflow', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CashFlow>> selectCashFlow() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('cashflow', orderBy: 'date');
    return List.generate(maps.length, (i) {
      return CashFlow(
        id: maps[i]['id'],
        type: maps[i]['type'],
        amount: maps[i]['amount'],
        description: maps[i]['description'],
        date: maps[i]['date'], inputTime: '',
      );
    });
  }

  Future<List<CashFlow>> selectCashFlowByMonth() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM cashflow WHERE strftime('%m', date) = strftime('%m', 'now') order by date
    ''');
    return List.generate(maps.length, (i) {
      return CashFlow(
        id: maps[i]['id'],
        type: maps[i]['type'],
        amount: maps[i]['amount'],
        description: maps[i]['description'],
        date: maps[i]['date'], inputTime: '',
      );
    });
  }

  Future<CashFlow> getCashFlow(int id) async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('cashflow', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return CashFlow(
        id: maps[0]['id'],
        type: maps[0]['type'],
        amount: maps[0]['amount'],
        description: maps[0]['description'],
        date: maps[0]['date'], inputTime: '',
      );
    } else {
      throw Exception('Cash flow not found');
    }
  }

  Future<void> updateCashFlow(CashFlow updatedCashFlow) async {
    Database db = await initDb();
    await db.update(
      'cashflow',
      updatedCashFlow.toJson(),
      where: 'id = ?',
      whereArgs: [updatedCashFlow.id],
    );
  }

  Future<void> insertCashFlow(CashFlow cashFlow) async {
    Database db = await initDb();
    await db.insert(
      'cashflow',
      cashFlow.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> registerUser(String username, String password) async {
    db = await initDb();
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username'
    ''');
    if (result.isEmpty) {
      await db.rawInsert('''
        INSERT INTO users (username, password) VALUES ('$username', '$password')
      ''');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    db = await initDb();
    var result = await db.rawQuery(
        'SELECT * FROM users WHERE username = "$oldPassword" AND password = "$oldPassword"');
    if (result.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE users SET password = "$oldPassword" WHERE username = "$oldPassword"');
      return true;
    } else {
      return false;
    }
  }

  Future close() async {
    Database db = await initDb();
    db.close();
  }
}
