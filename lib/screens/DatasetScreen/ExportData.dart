
// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:data_collector/services/db.service.dart';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';

class ExportData {

  final DBService _dbService = DBService();

  String TABLE_NAME;

  ExportData({required this.TABLE_NAME});

  exportFile() async {
    String? csv = _mapListToCsv(await _dbService.dyn_datasets(TABLE_NAME));
    if (csv != null) {
      String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
      var now = DateTime.now();
      String file_name = '${now.day}-${now.month}-${now.year} ${now.hour}-${now.minute}-${now.second}.csv';
      File file = File(path + '/' + TABLE_NAME + '/' + file_name);

      try {
        file.writeAsStringSync(csv);
        return "Exported as " + file_name + " in Documents/" + TABLE_NAME;
      }
      catch (error) {
        return "Error exporting to csv";
      }
    }
    return "Error exporting to csv";
  }

  String? _mapListToCsv(List<Map<String, Object?>>? mapList,
      {ListToCsvConverter? converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List<Object?>.filled(keyIndexMap.length, null);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }


}