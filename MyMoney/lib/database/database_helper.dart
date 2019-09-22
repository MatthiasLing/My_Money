import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_money/engine/engine.dart';
import 'package:my_money/screens/overview_screen.dart';
import 'package:my_money/screens/total_expense_screen.dart';
import 'package:my_money/engine/entry.dart';

class EntryDataBase {
  static final EntryDataBase _instance = EntryDataBase._();

  static Database _database;

  EntryDataBase._();

  factory EntryDataBase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'database.db');
    var database = openDatabase(dbPath, version: 5, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE entry(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      amount DOUBLE,
      type TEXT,
      date INTEGER,
      tagString TEXT
      )
  ''');
    print('database created!');
  }

  Future<List<Entry>> fetchAll() async {
    var client = await db;
    var res = await client.query('entry');

    if (res.isNotEmpty) {
      var entryList = res.map((entryMap) => Entry.fromJson(entryMap)).toList();
      return entryList;
    }
    return [];
  }

  Future<int> addEntry(Entry entry) async {
    var client = await db;
    int i = await client.insert('entry', entry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return i;
  }

  // Future<Entry> getEntry(int id) async {
  //   var client = await db;
  //   final Future<List<Map<String, dynamic>>> futureMaps =
  //       client.query('entry', where: 'id = ?', whereArgs: [id]);

  //   var maps = await futureMaps;

  //   if (maps.length != 0) {
  //     return Entry.fromJson(maps.first);
  //   }
  //   return null;
  // }

  Future closeDb() async {
    var client = await db;
    client.close();
  }

  void getLastWeek() async {
    wkSpent = 0;
    int lastSunday = findPriorSunday(DateTime.now()).millisecondsSinceEpoch;

    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('entry', where: 'date>=$lastSunday');

    var maps = await futureMaps;

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Entry e = Entry.fromJson(maps[i]);
        if (e.type != 'Withdrawal' &&
            e.type != 'Cash Deposit' &&
            e.type != 'Card Deposit') {
          wkSearch.add(e);
          wkSpent = wkSpent + e.amount;
        }
      }
    }
  }

  Future<void> removeEntry(int id) async {
    var client = await db;
    return client.delete('entry', where: 'id = ?', whereArgs: ['$id']);
  }

  //Search function - may be buggy because of contains function
  Future<List<Entry>> search(String name, String tags, String type) async {
    List<Entry> list = [];
    var client = await db;
    String str;

    Future<List<Map<String, dynamic>>> futureMaps;
    var maps;

    //checks by name
    if (name != null) {
      futureMaps = client.query('entry',
          where: 'lower(name) LIKE ?', whereArgs: ['%${name.toLowerCase()}%']);

      maps = await futureMaps;

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          Entry e = Entry.fromJson(maps[i]);

          if (list.contains(e) == false) {
            list.add(e);
          }
        }
      }
    }

    //checks by tag
    if (tags != null) {
      List<String> searchList = tags.split(" ");

      //only accepts first tag
      str = searchList.first;

      //removes entries from list that don't contain the tag
      for (int j = 0; j < list.length;) {
        if (list == null ||
            list.length == 0 ||
            list[j].tags == null ||
            list[j].tags.contains(str.toLowerCase()) == false) {
          list.removeAt(j);
        } else {
          j++;
        }
      }

      if (name == null) {
        futureMaps = client.query('entry',
            where: 'lower(tagString) LIKE ?',
            whereArgs: ['%${str.toLowerCase()}%']);
      } else {
        futureMaps = client.query('entry',
            where: 'lower(tagString) LIKE ? AND lower(name) LIKE ?',
            whereArgs: ['%${str.toLowerCase()}%', '%${name.toLowerCase()}%']);
      }

      maps = await futureMaps;
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          Entry e = Entry.fromJson(maps[i]);
          if (contains(list, e) == false) {
            list.add(e);
          }
        }
      }
    }

    //checks by type
    if (type != null) {
      //remove entries with different type
      for (int j = 0; j < list.length;) {
        if (list == null ||
            list.length == 0 ||
            list[j].tags == null ||
            list[j].type.contains(type) == false) {
          list.removeAt(j);
        } else {
          j++;
        }
      }

      if (name != null && tags != null) {
        futureMaps = client.query('entry',
            where: 'type LIKE ? AND lower(name) LIKE ? AND tagString LIKE ?',
            whereArgs: ['%$type%', '%$name%', '%$str%']);
      }
      //only type
      else if (name == null && tags == null) {
        futureMaps =
            client.query('entry', where: 'type LIKE ?', whereArgs: ['%$type%']);
      }
      //only name, check name
      else if (tags == null) {
        futureMaps = client.query('entry',
            where: 'type LIKE ? AND lower(name) LIKE ?',
            whereArgs: ['%$type%', '%${name.toLowerCase()}%']);
      }
      //only tags, check tags
      else {
        futureMaps = client.query('entry',
            where: 'type LIKE ? AND lower(tagString) LIKE ?',
            whereArgs: ['%$type%', '%${tags.toLowerCase()}%']);
      }

      maps = await futureMaps;

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          Entry e = Entry.fromJson(maps[i]);
          if (contains(list, e) == false) {
            list.add(e);
          }
        }
      }
    }
    list = list.reversed.toList();
    return list;
  }
}
