import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class DataScreenForm extends StatefulWidget {
  const DataScreenForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataScreenFormState();
}

class _DataScreenFormState extends State<DataScreenForm> {

  bool _progress = false;

  final DBService _dbService = DBService();
  final GlobalKey<FormState> _dynFormKey = GlobalKey<FormState>();
  late Permission permission;
  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {};

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black);
  }


  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    final _dataset = ModalRoute.of(context)!.settings.arguments as DatasetModel;

    _dynForm(var mapJSON) {
      switch (mapJSON['type']) {
        case DataTypes.IMAGE:
          return Wrap(
            children: [
              Column(
                children: [
                  if (_formData['${mapJSON["name"]}_raw'] != null)
                    Image.file(File((_formData['${mapJSON["name"]}_raw'] as XFile).path)),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          var status_storage = await Permission.storage.status;
                          var status_camera = await Permission.camera.status;

                          if (status_camera.isRestricted ||
                              status_camera.isDenied) {
                            await Permission.camera.request();
                          }

                          if (status_storage.isRestricted ||
                              status_storage.isDenied) {
                            await Permission.storage.request();
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  final ImagePicker _picker = ImagePicker();

                                  return Dialog(
                                    backgroundColor: Color(CustomColors.POP_UP),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton.icon(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                                        _formData['${mapJSON["name"]}_raw'] = photo;
                                                        setState(() {

                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.camera),
                                                      label:
                                                      const Text('CAMERA'))),
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton.icon(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                                        _formData['${mapJSON["name"]}_raw'] = image;
                                                        setState(() {

                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.image_search),
                                                      label:
                                                      const Text('GALLERY'))),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        label: Text('${mapJSON["name"]} (IMAGE)'),
                        icon: const Icon(Icons.camera),
                      ))
                ],
              )
            ],
          );
        case DataTypes.TEXT:
          return TextFormField(
            initialValue: _formData[mapJSON['name']],
            onChanged: (val) {
              if (val != "") {
                _formData[mapJSON['name']] = val;
              }
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(CustomColors.ASSETS_DARK)),
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(CustomColors.ASSETS_DARK))),
              labelText: '${mapJSON['name']} (Text)',
              labelStyle: const TextStyle(color: Colors.white),
              helperStyle: const TextStyle(color: Colors.white),
            ),
          );
        case DataTypes.NUMERIC:
          return TextFormField(
            initialValue: _formData[mapJSON['name']],
            onChanged: (val) {
              if (val != "") {
                _formData[mapJSON['name']] = val;
              }
            },
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(CustomColors.ASSETS_DARK)),
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(CustomColors.ASSETS_DARK))),
              labelText: '${mapJSON['name']} (Numeric)',
              labelStyle: const TextStyle(color: Colors.white),
              helperStyle: const TextStyle(color: Colors.white),
            ),
          );
        case DataTypes.D_LIST:
        // ignore: non_constant_identifier_names
          List<String> d_list = mapJSON['d_list'].split(',');
          // ignore: non_constant_identifier_names
          List<DropdownMenuItem> dm_list = [];
          for (String item in d_list) {
            dm_list.add(DropdownMenuItem(
                child: Text(
                  item.trim(),
                  style: const TextStyle(color: Colors.white),
                ),
                value: item.trim()));
          }

          return DropdownButtonFormField(
              alignment: AlignmentDirectional.bottomCenter,
              dropdownColor: Color(CustomColors.POP_UP),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(CustomColors.ASSETS_DARK)),
                ),
                disabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(CustomColors.ASSETS_DARK))),
                labelText: '${mapJSON['name']} (Dropdown)',
                labelStyle: const TextStyle(color: Colors.white),
                helperStyle: const TextStyle(color: Colors.white),
              ),
              items: dm_list,
              onChanged: (dynamic val) {
                if (val != null) {
                  _formData[mapJSON['name']] = val;
                }
              });
      }
    }


    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_dataset.t_name + " (Form)"),
        ),
        body: Form(
            key: _dynFormKey,
            child: FutureBuilder<List<DatasetModel>>(
                future: _dbService.checkSchema(_dataset.t_name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var schema = snapshot.data![0].schema;

                  if (schema != null) {
                    List schemaJSON = jsonDecode(schema);

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: '#',
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(CustomColors.ASSETS_DARK)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color(CustomColors.ASSETS_DARK))),
                                labelText: 'ID (Auto Generated)',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                helperStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                              enabled: false,
                            ),
                            Wrap(
                              children: [
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: schemaJSON.length,
                                    itemBuilder: (context, index) {
                                      return Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              _dynForm(schemaJSON[index])!
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: !_progress,
                              child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {

                                        setState(() {

                                          _progress = true;

                                        });

                                        if (_dynFormKey.currentState!
                                            .validate()) {


                                          String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
                                          String root = path + '/' + _dataset.t_name;
                                          Directory storage = Directory(root);

                                          Map<String, dynamic> _toAdd = {};
                                          List _toRemove = [];

                                          for (String key in _formData.keys) {
                                            if (RegExp(r'[a-zA-Z0-9@#$\*&()_\-\s]+_raw').hasMatch(key)) {

                                              if (!await storage.exists()) {
                                                await storage.create();
                                              }

                                              Directory _namedStorage = Directory(root + '/' + key.split('_raw')[0]);
                                              if (!await _namedStorage.exists()) {
                                                await _namedStorage.create();
                                              }

                                              String file_name = getRandomString(10) + '.png';
                                              String _savePath = _namedStorage.path + '/' + file_name;
                                              await File((_formData[key] as XFile).path).copy(_savePath);
                                              _toRemove.add(key);
                                              _toAdd[key.split('_raw')[0]] = key.split('_raw')[0] + '/' + file_name;
                                            }
                                          }

                                          _formData.removeWhere((key, value) => _toRemove.contains(key));
                                          _formData.addAll(_toAdd);

                                          await _dbService.insertData(_dataset.t_name, _formData);

                                          setState(() {

                                            _progress = false;

                                          });

                                          _notify(false, 'Created!');

                                          _formData = {};
                                          _dynFormKey.currentState!.reset();
                                          //Navigator.pop(context);

                                        } else {
                                          setState(() {

                                            _progress = false;

                                          });
                                          _notify(true,
                                              'One or more field is either empty or not properly formatted');
                                        }
                                      },
                                      child: const Text('CREATE'))),
                            ),
                            Visibility(
                                visible: _progress,
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: Text(
                      'No schema found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                })));
  }
}
