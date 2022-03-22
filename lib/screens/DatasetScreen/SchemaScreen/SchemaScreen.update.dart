// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SchemaScreenUpdate extends StatefulWidget {
  String TABLE_NAME;
  SchemaScreenUpdate({Key? key, required this.TABLE_NAME}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchemaScreenUpdate();
}

class _SchemaScreenUpdate extends State<SchemaScreenUpdate> {

  final DBService _dbService = DBService();

  late Future<List<DatasetModel>> _formSchema;

  @override
  void initState() {
    super.initState();
    _formSchema = _dbService.checkSchema(widget.TABLE_NAME);
  }

  _dynForm(var mapJSON) {
    switch(mapJSON['type']) {
      case DataTypes.IMAGE:
        return ExpansionTile(
          backgroundColor: Color(CustomColors.POP_UP),
          textColor: Color(CustomColors.ASSETS_DARK),
          iconColor: Color(CustomColors.ASSETS_DARK),
          collapsedIconColor: Color(CustomColors.ASSETS_DARK),
          collapsedBackgroundColor: Color(CustomColors.POP_UP),
          title: Text(
            "${mapJSON['name']} (Image)",
            style: TextStyle(color: Color(CustomColors.ASSETS_DARK)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        TextFormField(
                          enabled: false,
                          onSaved: (value) {
                            // Todo: on saved
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
                          initialValue: mapJSON['name'],
                          onChanged: (value) {
                            // Todo : on changed
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
                        /*const SizedBox(
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
                                      "Delete ${mapJSON['name']} ?",
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
                                            // Todo: Delete Logic
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'))
                                    ],
                                  ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))*/
                      ],
                    )
                  ],
                ),
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
            "${mapJSON['name']} (Text)",
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
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
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
                        initialValue: mapJSON['name'],
                        onChanged: (value) {
                          // Todo : on changed
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
                      /*const SizedBox(height: 15),
                      TextFormField(
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
                        },
                        validator: (value) {
                          if (!RegExp(r'[0-9]+').hasMatch(value!)) {
                            return 'Numeric Only';
                          }
                          return null;
                        },
                        initialValue:
                        mapJSON['max_length']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            try {
                              // Todo : on changed
                            } catch (error) {}
                          });
                        },
                        keyboardType: TextInputType.number,
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
                          labelText: 'Max Length',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
                        },
                        initialValue: mapJSON['regexp'],
                        onChanged: (value) {
                          // Todo : on changed
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(CustomColors.ASSETS_DARK)),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(CustomColors.ASSETS_DARK))),
                          labelText: 'Regexp (For sanitization)',
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
                                    "Delete ${mapJSON['name']} ?",
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
                                          // Todo : Delete logic
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'))
                                  ],
                                ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))*/
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
            "${mapJSON['name']} (Numeric)",
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
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
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
                        initialValue: mapJSON['name'],
                        onChanged: (value) {
                          // Todo : on changed
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
                      /*const SizedBox(height: 15),
                      TextFormField(
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
                        },
                        validator: (value) {
                          if (!RegExp(r'([-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?').hasMatch(value!)) {
                            return 'Numeric Only';
                          }
                          return null;
                        },
                        initialValue:
                        mapJSON['min_value']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            try {
                              // Todo : on changed
                            } catch (error) {}
                          });
                        },
                        keyboardType: TextInputType.number,
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
                          labelText: 'Min Value',
                          labelStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        enabled: false,
                        onSaved: (value) {
                          setState(() {
                            // Todo : on saved
                          });
                        },
                        validator: (value) {
                          if (!RegExp(r'([-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?').hasMatch(value!)) {
                            return 'Numeric Only';
                          }
                          return null;
                        },
                        initialValue:
                        mapJSON['max_value']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            try {
                              // Todo : on changed
                            } catch (error) {}
                          });
                        },
                        keyboardType: TextInputType.number,
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
                          labelText: 'Max Value',
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
                                    "Delete ${mapJSON['name']} ?",
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
                                          // Todo : Delete logic
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'))
                                  ],
                                ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))*/
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
            "${mapJSON['name']} (Dropdown List)",
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
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
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
                        initialValue: mapJSON['name'],
                        onChanged: (value) {
                          // Todo : on changed
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
                        enabled: false,
                        onSaved: (value) {
                          // Todo : on saved
                        },
                        initialValue:
                       mapJSON['d_list']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            try {
                              // Todo : on changed
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
                      /*const SizedBox(
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
                                    "Delete ${mapJSON['name']} ?",
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
                                          // Todo : Delete logic
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'))
                                  ],
                                ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))*/
                    ],
                  )
                ],
              ),
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<DatasetModel>>(
      future: _formSchema,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var schema = snapshot.data![0].schema;

        if (schema != null) {

          List schemaJSON = jsonDecode(schema);

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: '#' + snapshot.data![0].id.toString(),
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
                  Wrap(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: schemaJSON.length,
                          itemBuilder: (context, index) {
                            return Wrap(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _dynForm(schemaJSON[index])
                                  ],
                                ),
                              ],
                            );
                          }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }
  );
}