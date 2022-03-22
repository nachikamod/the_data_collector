import 'dart:developer';
import 'dart:io';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/models/dataset_mode.model.dart';
import 'package:data_collector/screens/DatasetScreen/DataScreen/DataScreen.dart';
import 'package:data_collector/screens/DatasetScreen/ExportData.dart';
import 'package:data_collector/screens/DatasetScreen/SchemaScreen/SchemaScreen.selector.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:data_collector/widgets/popups/TDset.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_share/flutter_share.dart';

class DatasetScreen extends StatefulWidget {

  const DatasetScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatasetScreenState();
}

class _DatasetScreenState extends State<DatasetScreen> {
  int _selectedIndex = 0;
  // ignore: non_constant_identifier_names
  late String? t_name;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  callback() {
    setState(() {});
  }

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black);
  }

  _dialogNotify(String topic) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Color(CustomColors.POP_UP),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(topic,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        const CircularProgressIndicator(),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    t_name = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DBService _dbService = DBService();
    final _dataset = ModalRoute.of(context)!.settings.arguments as DatasetModel;

    List<Widget> _pages = <Widget>[
      DataScreen(
        TABLE_NAME: (t_name != null) ? t_name! : _dataset.t_name,
      ),
      SchemaScreenSelector(TABLE_NAME: (t_name != null) ? t_name! : _dataset.t_name, callback: callback)
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          (t_name != null) ? t_name! : _dataset.t_name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Color(CustomColors.POP_UP),
                          title: Text('Delete ${(t_name != null) ? t_name! : _dataset.t_name}',
                              style: const TextStyle(color: Colors.white)),
                          content: Text(
                              'Once you delete ${(t_name != null) ? t_name! : _dataset.t_name} all the files and backups related to dataset will be permanently deleted from you storage',
                              style: const TextStyle(color: Colors.white)),
                          actions: [
                            TextButton(
                                onPressed: () async {


                                  try {
                                    _dialogNotify('Deleting ${(t_name != null) ? t_name! : _dataset.t_name}');
                                    await _dbService.deleteDataset((t_name != null) ? t_name! : _dataset.t_name);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    _notify(false, '${(t_name != null) ? t_name! : _dataset.t_name} deleted');
                                  }
                                  catch (error) {
                                    log(error.toString());
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    _notify(true, 'Error deleting ${(t_name != null) ? t_name! : _dataset.t_name}');
                                  }

                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Color(CustomColors.ASSETS_DARK)),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color(CustomColors.ASSETS_DARK)),
                                ))
                          ],
                        ));
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Color(CustomColors.POP_UP),
                      child: TDset(dMode: DatasetMode(index: _dataset.id!, t_name: (t_name != null) ? t_name! : _dataset.t_name)),
                    )).then((value) {
                      setState(() {
                        log(value);
                          t_name = value;
                      });
                });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () async {
                _dialogNotify('Exporting dataset ${(t_name != null) ? t_name! : _dataset.t_name}');

                String message =
                    await ExportData(TABLE_NAME: (t_name != null) ? t_name! : _dataset.t_name).exportFile();

                Navigator.pop(context);
                _notify(message == "Error exporting to csv", message);
              },
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              )),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.storage_rounded), label: 'Data'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schema_rounded), label: 'Schema')
          ]),
    );
  }
}
