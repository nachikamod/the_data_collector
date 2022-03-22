import 'package:data_collector/constants/strings.dart';
import 'package:flutter/material.dart';

class DType extends StatefulWidget {
  const DType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DTypeState();
}

class _DTypeState extends State<DType> {

  SizedBox _dataType(int D_TYPE, IconData icon, String label) {
    return  SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, D_TYPE);
            },
            icon: Icon(icon),
            label: Text(label)
        )
    );
  }

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(10), child: Wrap(
    children: [
      Column(
        children: [
          _dataType(DataTypes.IMAGE, Icons.camera, 'Image'),
          _dataType(DataTypes.TEXT, Icons.notes, 'Text'),
          _dataType(DataTypes.NUMERIC, Icons.numbers, 'Numeric'),
          _dataType(DataTypes.D_LIST, Icons.arrow_drop_down, 'Dropdown List')
        ],
      )
    ],
  ),);
}