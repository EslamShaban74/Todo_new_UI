import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null');
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('in database path');
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('create a new one');
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  static Future<int> insert(Task task) async {
    debugPrint('insert Function Called');
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic?>>> query() async {
    debugPrint('query Function Called');

    return await _db!.query(_tableName);
  }

  static Future<int> delete(Task task) async {
    debugPrint('delete Function Called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> update(int id) async {
    debugPrint('update Function Called');
    return await _db!.rawUpdate('''
    
    UPDATE $_tableName 
    SET isCompleted = ?
    WHERE id = ?
      
    ''', [1, id]);
  }
}
