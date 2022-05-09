// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:external_path/external_path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static const _databaseName = "data_collector.db";
  static const _databaseVersion = 1;

  // Singleton pattern
  static final DBService _dbService = DBService._internal();
  factory DBService() => _dbService;
  DBService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
                      CREATE TABLE IF NOT EXISTS ${TableNames.DATASET} ( 
                        id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, 
                        t_name VARCHAR (100) UNIQUE NOT NULL, 
                        schema VARCHAR 
                      );
                    ''');

    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS ${TableNames.USERS} (
          id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
          user_name VARCHAR(50) UNIQUE NOT NULL,
          password VARCHAR
        );
      '''
    );

  }

  Future checkUser() async {

    final db = await _dbService.database;

    List users = await db.query(TableNames.USERS);

    return users.length;

  }

  Future<int> insertData(String table, Map<String, dynamic> data) async {
    final db = await _dbService.database;
    return await db.insert('[' + table + ']', data);
  }

  Future<List<DatasetModel>> datasets() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.DATASET);
    return List.generate(maps.length, (index) => DatasetModel.fromMap(maps[index]));
  }

  // ignore: non_constant_identifier_names
  Future<List<DatasetModel>> checkSchema(String c_name) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.DATASET, where: 't_name = ?', whereArgs: [c_name]);

    return List.generate(maps.length, (index) => DatasetModel.fromMap(maps[index]));
  }

  // ignore: non_constant_identifier_names
  Future<void> createSchema(String TABLE_NAME, List<Map<String, dynamic>> dynamicSchema) async {

    final db = await _dbService.database;
    await db.update(TableNames.DATASET, {'schema': jsonEncode(dynamicSchema)},where: 't_name = ?', whereArgs:  [TABLE_NAME]);

    String _query = 'CREATE TABLE IF NOT EXISTS [$TABLE_NAME] ( id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, ';

    int i = 0;

    for (final schema in dynamicSchema) {
      switch (schema['type']) {
        case DataTypes.IMAGE:
          _query += '[${schema['name']}] VARCHAR';
          break;
        case DataTypes.TEXT:
          _query += '''
                      [${schema["name"]}] VARCHAR ${(schema["max_length"] != null && schema["max_length"] != "") ? "(${schema["max_length"]})" : ""}
                      ${(schema["regexp"] != null && schema["regexp"] != "") ? "CHECK ( [${schema['name']}] REGEXP '${schema['regexp']}' )" : ""}
                    ''';
          // Todo: Add sanitization logic
          break;
        case DataTypes.NUMERIC:
          _query += '''
                      [${schema["name"]}] INTEGER 
                      ${((schema["min_value"] != null && schema["min_value"] != "") || (schema["max_value"] != null && schema["max_value"] != "")) ? " CHECK ( " : ""}
                      ${(schema["min_value"] != null && schema["min_value"] != "") ? "[${schema['name']}] >= ${schema['min_value']}" : ""}
                      ${((schema["min_value"] != null && schema["min_value"] != "") && (schema["max_value"] != null && schema["max_value"] != "")) ? " AND " : ""}
                      ${(schema["max_value"] != null && schema["max_value"] != "") ? "[${schema['name']}] <= ${schema['max_value']}" : ""}
                      ${((schema["min_value"] != null && schema["min_value"] != "") || (schema["max_value"] != null && schema["max_value"] != "")) ? " )" : ""}
                    ''';
          break;
        case DataTypes.D_LIST:
          _query += '[${schema['name']}] VARCHAR';
          break;
      }

      if (dynamicSchema.length - 1 != i) {_query += ", ";}
      i++;

    }

    _query += ' )';
    return await db.execute(_query);

  }

  // ignore: non_constant_identifier_names
  Future<List<Map<String, dynamic>>> dyn_datasets(String TABLE_NAME) async {
    final db = await _dbService.database;
    return await db.query('['+ TABLE_NAME + ']');
  }

  // ignore: non_constant_identifier_names
  Future deleteDataset(String TABLE_NAME) async {
    final db = await _dbService.database;
    String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);

    Directory dir =  Directory(path + '/' + TABLE_NAME);



    log(dir.path + ':' + (await dir.exists()).toString());

    if (await dir.exists()) {

      await dir.delete(recursive: true);

    }

    await db.delete(TableNames.DATASET, where: 't_name = ?',whereArgs: [TABLE_NAME]);
    await db.execute('DROP TABLE IF EXISTS [$TABLE_NAME]');
  }


  // ignore: non_constant_identifier_names
  Future renameDataset(int id, String TABLE_NAME) async {
    final db = await _dbService.database;

    List<Map<String, dynamic>> p_table = await db.query('[' + TableNames.DATASET + ']', where: 'id = ?', whereArgs: [id]);

    await db.update('[' + TableNames.DATASET + ']', {'t_name': TABLE_NAME}, where: 'id = ?' ,whereArgs: [id]);
    await db.execute('ALTER TABLE [${p_table[0]['t_name']}] RENAME TO [$TABLE_NAME]');
  }

  // ignore: non_constant_identifier_names
  Future removeEntry(String TABLE_NAME, int id) async {
    final db = await _dbService.database;

    List<Map<String, dynamic>> p_table = await db.query('[' + TABLE_NAME + ']', where: 'id = ?', whereArgs: [id]);

    Iterable keys = p_table[0].keys;

    for (String key in keys) {

      if (p_table[0][key].toString().contains('.png')) {

        String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
        File file = File(path + '/' + TABLE_NAME + '/' + p_table[0][key]);
        await file.delete();

      }

    }

    await db.delete('[' + TABLE_NAME + ']', where: 'id = ?', whereArgs: [id]);
  }


}
