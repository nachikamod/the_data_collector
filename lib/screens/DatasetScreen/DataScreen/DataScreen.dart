// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataScreen extends StatefulWidget {
  String TABLE_NAME;

  DataScreen({Key? key, required this.TABLE_NAME}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DBService _dbService = DBService();

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black);
  }

  late DatasetModel _formSchema;

  Future<List<Map<String, dynamic>>> _getDataset() async {
    _formSchema = (await _dbService.checkSchema(widget.TABLE_NAME))[0];

    return _dbService.dyn_datasets(widget.TABLE_NAME);
  }

  List<Widget> _dynData(Map<String, dynamic> snapshot) {
    List<Widget> _data = [];
    List schema = jsonDecode(_formSchema.schema!);

    for (String key in snapshot.keys) {
      Iterable struct =
          schema.where((element) => element['name'].contains(key));

      if (struct.isNotEmpty) {
        switch (struct.elementAt(0)['type']) {
          case DataTypes.IMAGE:
            if (snapshot[key] != null){
              _data.add(FutureBuilder<String>(
                  future: ExternalPath.getExternalStoragePublicDirectory(
                      ExternalPath.DIRECTORY_DOCUMENTS),
                  builder: (context, file) {
                    if (file.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (file.hasError) {
                      return const Center(
                        child: Text(
                          'Storage exception',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(10),
                      child: Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(CustomColors.ASSETS_DARK),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.file(File(file.data! +
                                  '/' +
                                  widget.TABLE_NAME +
                                  '/' +
                                  snapshot[key]))
                            ],
                          ),
                        ],
                      ),
                    );
                  }));
            }
            break;
          case DataTypes.TEXT:
            if (snapshot[key] != null) {
            _data.add(Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(CustomColors.ASSETS_DARK),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            snapshot[key],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )),
                    ],
                  )
                ],
              ),
            ));}
            break;
          case DataTypes.NUMERIC:
            if (snapshot[key] != null){
              _data.add(Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(CustomColors.ASSETS_DARK),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              snapshot[key].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )),
                      ],
                    )
                  ],
                ),
              ));
            }
            break;
          case DataTypes.D_LIST:
            if (snapshot[key] != null){
              _data.add(Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(CustomColors.ASSETS_DARK),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              snapshot[key],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )),
                      ],
                    )
                  ],
                ),
              ));
            }
            break;
        }
      }
    }

    return _data;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getDataset(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              if (snapshot.error.toString().contains('no such table')) {
                return const Center(
                  child: Text(
                    'Create Schema',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No entries',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Dismissible(
                            key: Key(data.toString()),
                            background: Container(
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete),
                            ),
                            onDismissed: (direction) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Delete ${index}th entry ?',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        content: const Text(
                                            'Once deleted you will not be able to retrieve content',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor:
                                            Color(CustomColors.POP_UP),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await _dbService.removeEntry(
                                                    widget.TABLE_NAME,
                                                    data['id']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: Color(CustomColors
                                                          .ASSETS_DARK)))),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Color(CustomColors
                                                          .ASSETS_DARK))))
                                        ],
                                      ));
                            },
                            child: ExpansionTile(
                              backgroundColor: Color(CustomColors.POP_UP),
                              textColor: Color(CustomColors.ASSETS_DARK),
                              iconColor: Color(CustomColors.ASSETS_DARK),
                              collapsedIconColor:
                                  Color(CustomColors.ASSETS_DARK),
                              collapsedBackgroundColor:
                                  Color(CustomColors.POP_UP),
                              title: Text(
                                '#' + index.toString(),
                                style: TextStyle(
                                    color: Color(CustomColors.ASSETS_DARK)),
                              ),
                              children: _dynData(data),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  );
                });
          },
        ),
        floatingActionButton: ElevatedButton.icon(
            onPressed: () async {
              var isSchema =
                  (await _dbService.checkSchema(widget.TABLE_NAME))[0].schema;
              if (isSchema != null && isSchema != "") {
                Navigator.pushNamed(context, RouteStrings.DATASET_FORM,
                        arguments: DatasetModel(t_name: widget.TABLE_NAME))
                    .then((value) {
                  setState(() {});
                });
              } else {
                _notify(true, 'No schema found');
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))),
            icon: const Icon(Icons.add),
            label: const Text('Data')),
      );
}
