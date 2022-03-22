// ignore_for_file: file_names

import 'dart:developer';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/screens/HomeScreen/Dataset.ui.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:data_collector/widgets/popups/TDset.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Over engineering
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String pop() {
    return substring(0, length - 1);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  static const _page = "datasets";

  final DBService _dbService = DBService();
  late Future<List<DatasetModel>> datasetFuture;

  callback() {
    log('callback');

    setState(() {
      datasetFuture = _dbService.datasets();
    });
  }

  @override
  void initState() {
    super.initState();
    datasetFuture = _dbService.datasets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page.capitalize()),
      ),
      body: FutureBuilder<List<DatasetModel>>(
        future: datasetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final dataset = snapshot.data![index];
                    return DatasetUI(index: dataset.id!, t_name: dataset.t_name, callback: callback);
                  }));
        },
      ),
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      backgroundColor: Color(CustomColors.POP_UP),
                      child: TDset(),
                    )).then((value) {
              setState(() {
                datasetFuture = _dbService.datasets();
              });
            });
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ))),
          icon: const Icon(Icons.add),
          label: Text(_page.pop().capitalize())),
    );
  }
}
