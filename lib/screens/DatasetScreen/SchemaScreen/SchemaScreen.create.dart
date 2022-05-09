// ignore_for_file: prefer_final_fields, must_be_immutable, non_constant_identifier_names, empty_catches

import 'dart:developer';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:data_collector/widgets/popups/DType.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SchemaScreenCreate extends StatefulWidget {
  String TABLE_NAME;
  Function callback;

  SchemaScreenCreate({Key? key, required this.TABLE_NAME, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchemaScreenCreateState();
}

class _SchemaScreenCreateState extends State<SchemaScreenCreate> {
  late bool _isSubmitted = false;
  late List<Map<String, dynamic>> _formSchema = [];

  GlobalKey<FormState> _dynFormKey = GlobalKey<FormState>();
  final DBService _dbService = DBService();

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black
    );
  }

  _dynForm(int index) {
    switch (_formSchema[index]['type']) {
      case DataTypes.IMAGE:
        return ExpansionTile(
          backgroundColor: Color(CustomColors.POP_UP),
          textColor: Color(CustomColors.ASSETS_DARK),
          iconColor: Color(CustomColors.ASSETS_DARK),
          collapsedIconColor: Color(CustomColors.ASSETS_DARK),
          collapsedBackgroundColor: Color(CustomColors.POP_UP),
          title: Text(
            (_formSchema[index]['name'] != null &&
                    _formSchema[index]['name'] != "")
                ? '${_formSchema[index]['name']} (Image)'
                : 'Image',
            style: TextStyle(color: Color(CustomColors.ASSETS_DARK)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (value.isEmpty) {
                            return 'Required';
                          } else if (!RegExp(r'[a-zA-Z0-9_$-\s]+')
                              .hasMatch(value)) {
                            return r'Allowed a-z,A-Z,0-9,_,$,-';
                          }
                          return null;
                        },
                        initialValue: _formSchema[index]['name'],
                        onChanged: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
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
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Column Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor:
                                          Color(CustomColors.POP_UP),
                                      title: const Text(
                                        'Confirm Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        "Delete ${(_formSchema[index]['name'] != null && _formSchema[index]['name'] != '') ? _formSchema[index]['name'] : 'Image'} ?",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _formSchema.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        );
      case DataTypes.TEXT:
        return ExpansionTile(
          backgroundColor: Color(CustomColors.POP_UP),
          textColor: Color(CustomColors.ASSETS_DARK),
          iconColor: Color(CustomColors.ASSETS_DARK),
          collapsedIconColor: Color(CustomColors.ASSETS_DARK),
          collapsedBackgroundColor: Color(CustomColors.POP_UP),
          title: Text(
            (_formSchema[index]['name'] != null &&
                    _formSchema[index]['name'] != "")
                ? '${_formSchema[index]['name']} (Text)'
                : 'Text',
            style: TextStyle(color: Color(CustomColors.ASSETS_DARK)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (value.isEmpty) {
                            return 'Required';
                          } else if (!RegExp(r'[a-zA-Z0-9_$-\s]+')
                              .hasMatch(value)) {
                            return r'Allowed a-z,A-Z,0-9,_,$,-';
                          }

                          return null;
                        },
                        initialValue: _formSchema[index]['name'],
                        onChanged: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
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
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Column Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor:
                                          Color(CustomColors.POP_UP),
                                      title: const Text(
                                        'Confirm Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        "Delete ${(_formSchema[index]['name'] != null && _formSchema[index]['name'] != '') ? _formSchema[index]['name'] : 'Image'} ?",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _formSchema.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        );
      case DataTypes.NUMERIC:
        return ExpansionTile(
          backgroundColor: Color(CustomColors.POP_UP),
          textColor: Color(CustomColors.ASSETS_DARK),
          iconColor: Color(CustomColors.ASSETS_DARK),
          collapsedIconColor: Color(CustomColors.ASSETS_DARK),
          collapsedBackgroundColor: Color(CustomColors.POP_UP),
          title: Text(
            (_formSchema[index]['name'] != null &&
                _formSchema[index]['name'] != "")
                ? '${_formSchema[index]['name']} (Numeric)'
                : 'Numeric',
            style: TextStyle(color: Color(CustomColors.ASSETS_DARK)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (value.isEmpty) {
                            return 'Required';
                          } else if (!RegExp(r'[a-zA-Z0-9_$-\s]+')
                              .hasMatch(value)) {
                            return r'Allowed a-z,A-Z,0-9,_,$,-';
                          }

                          return null;
                        },
                        initialValue: _formSchema[index]['name'],
                        onChanged: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
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
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Column Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                  Color(CustomColors.POP_UP),
                                  title: const Text(
                                    'Confirm Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Text(
                                    "Delete ${(_formSchema[index]['name'] != null && _formSchema[index]['name'] != '') ? _formSchema[index]['name'] : 'Image'} ?",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _formSchema.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'))
                                  ],
                                ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        );
      case DataTypes.D_LIST:
        return ExpansionTile(
          backgroundColor: Color(CustomColors.POP_UP),
          textColor: Color(CustomColors.ASSETS_DARK),
          iconColor: Color(CustomColors.ASSETS_DARK),
          collapsedIconColor: Color(CustomColors.ASSETS_DARK),
          collapsedBackgroundColor: Color(CustomColors.POP_UP),
          title: Text(
            (_formSchema[index]['name'] != null &&
                _formSchema[index]['name'] != "")
                ? '${_formSchema[index]['name']} (Dropdown List)'
                : 'Dropdown List',
            style: TextStyle(color: Color(CustomColors.ASSETS_DARK)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          } else if (value.isEmpty) {
                            return 'Required';
                          } else if (!RegExp(r'[a-zA-Z0-9_$-\s]+')
                              .hasMatch(value)) {
                            return r'Allowed a-z,A-Z,0-9,_,$,-';
                          }

                          return null;
                        },
                        initialValue: _formSchema[index]['name'],
                        onChanged: (value) {
                          setState(() {
                            _formSchema[index]['name'] = value;
                          });
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
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Column Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (value) {
                          setState(() {
                            _formSchema[index]['d_list'] = value;
                          });
                        },
                        initialValue:
                        _formSchema[index]['d_list']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            try {
                              _formSchema[index]['d_list'] = value;
                            } catch (error) {}
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(CustomColors.ASSETS_DARK)),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Dropdown List (Comma Separated)',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                  Color(CustomColors.POP_UP),
                                  title: const Text(
                                    'Confirm Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Text(
                                    "Delete ${(_formSchema[index]['name'] != null && _formSchema[index]['name'] != '') ? _formSchema[index]['name'] : 'Image'} ?",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _formSchema.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'))
                                  ],
                                ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        );
    }
  }

  Future _saveSchema() async {

    bool _error = false;

    for (final schema in _formSchema) {

      if (schema['name'] == null || schema['name'] == "") {

        _error = true;

      }

    }

    if (_formSchema.isEmpty || _error) {
      _notify(true, 'One or more mandatory fields are empty');
    }
    else {
      try {
        await _dbService.createSchema(widget.TABLE_NAME, _formSchema);
        _notify(false, 'Created !');
      }
      catch (error) {
        _notify(true, 'The error is beyond my capabilities to handle, you must contact developer!');
      }

    }

  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _dynFormKey,
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextFormField(
              initialValue: '#',
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(CustomColors.ASSETS_DARK)),
                ),
                disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(CustomColors.ASSETS_DARK))),
                labelText: 'ID (Auto Generated)',
                labelStyle: const TextStyle(color: Colors.white),
                helperStyle: const TextStyle(color: Colors.white),
              ),
              enabled: false,
            ),
            const SizedBox(
              height: 15,
            ),
            Wrap(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _formSchema.length,
                  itemBuilder: (context, index) {
                    return Wrap(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            _dynForm(index)
                          ],
                        )
                      ],
                    );
                  },
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: IconButton(
                onPressed: () async {
                  var result = await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => Dialog(
                            backgroundColor: Color(CustomColors.POP_UP),
                            child: const DType(),
                          ));

                  setState(() {
                    if (result != null) {
                      _formSchema.add({'type': result});
                    }
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            Visibility(
              visible: !_isSubmitted,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSubmitted = true;
                      });
                      if (_dynFormKey.currentState!.validate()) {
                        _dynFormKey.currentState!.save();

                        await _saveSchema();
                      }

                      setState(() {
                        _isSubmitted = false;
                      });

                      widget.callback();


                    }, child: const Text('Create Dataset')),
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
          ]),
        )),
      );
}