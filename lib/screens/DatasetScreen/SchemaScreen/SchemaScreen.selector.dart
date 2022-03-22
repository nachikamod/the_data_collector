// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:developer';

import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/screens/DatasetScreen/SchemaScreen/SchemaScreen.create.dart';
import 'package:data_collector/screens/DatasetScreen/SchemaScreen/SchemaScreen.update.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:flutter/material.dart';


class SchemaScreenSelector extends StatefulWidget {

  String TABLE_NAME;
  Function callback;

  SchemaScreenSelector({Key? key, required this.TABLE_NAME, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchemaScreenSelector();
}

class _SchemaScreenSelector extends State<SchemaScreenSelector> {


  final DBService _dbService = DBService();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<DatasetModel>>(
      future: _dbService.checkSchema(widget.TABLE_NAME),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (snapshot.data![0].schema != null && snapshot.data![0].schema != "") {
          return SchemaScreenUpdate(TABLE_NAME: snapshot.data![0].t_name);
        }

        return SchemaScreenCreate(TABLE_NAME: snapshot.data![0].t_name, callback: widget.callback);
      }
  );
}