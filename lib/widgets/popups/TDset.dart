// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset_mode.model.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TDset extends StatefulWidget {
  DatasetMode? dMode;

  TDset({Key? key, this.dMode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDsetState();
}

class _TDsetState extends State<TDset> {
  final GlobalKey<FormState> _fdset = GlobalKey<FormState>();
  final DBService _dbService = DBService();

  late bool _isSubmitted = false;
  late String _dname;

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black
    );
  }


  _createDataset() async {
    Map<String, String> dataset = <String, String>{};
    dataset['t_name'] = _dname;

    try {
      await _dbService.insertData(TableNames.DATASET, dataset);
      setState(() {
        _isSubmitted = false;
      });
      _notify(false, '$_dname created');
      Navigator.pop(context);
    }
    catch (e) {
      setState(() {
        _isSubmitted = false;
      });
      if ('DatabaseException(UNIQUE constraint failed: dataset.t_name' == e.toString().substring(0, 58)) {
        _notify(true, '$_dname already exists');
      }
      else {
        _notify(true, 'Unhandled exception');
      }
    }
  }

  _updateDatasetName() async {
    try {
      String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
      log(widget.dMode!.index.toString() + ':' + _dname);
      await _dbService.renameDataset(widget.dMode!.index, _dname);
      Directory dir = Directory(path + '/' + widget.dMode!.t_name);
      await dir.rename(path + '/' + _dname);
      setState(() {
        _isSubmitted = false;
      });
      _notify(false, '$_dname updated');
      Navigator.pop(context, _dname);
    }
    catch(e) {
      setState(() async {
        _isSubmitted = false;
      });

      if (e.toString().contains('no such table')) {
        log('No such table');
        Navigator.pop(context, _dname);
      }
      else if (e.toString().contains('UNIQUE constraint failed')) {
        _notify(true, '$_dname already exists');
      }
      else {
        _notify(true, 'Unhandled exception');
      }
    }
  }

  @override
  Widget build(BuildContext context) => Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(widget.dMode == null) ? 'Create' : 'Update'} Dataset",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _fdset,
                    child: TextFormField(
                      initialValue: (widget.dMode == null) ? null : widget.dMode?.t_name,
                      onSaved: (dname) {
                        _dname = dname!;
                      },
                      validator: (dname) {
                        if (dname!.isEmpty) {
                          setState(() {
                            _isSubmitted = false;
                          });
                          return 'Dataset name is required';
                        }
                        if (dname.length < 3) {
                          setState(() {
                            _isSubmitted = false;
                          });
                          return 'Min 3 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9\s]+').hasMatch(dname)) {
                          _isSubmitted = false;
                          return 'Only alphabets and numbers';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      maxLength: 100,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.ASSETS_DARK)),
                        ),
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white),
                        helperStyle: const TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(height: 10),
                Visibility(
                  visible: !_isSubmitted,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_fdset.currentState!.validate()) {
                            _fdset.currentState!.save();

                            setState(() {
                              _isSubmitted = true;
                            });

                            (widget.dMode == null) ? _createDataset() : _updateDatasetName();
                          }
                        },
                        child: Text("${(widget.dMode == null) ? 'Create' : 'Update'} Dataset")),
                  ),
                ),
                Visibility(
                    visible: _isSubmitted,
                    child: const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )),
              ],
            ),
          )
        ],
      );
}
