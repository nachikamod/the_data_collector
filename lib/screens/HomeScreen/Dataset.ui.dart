import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/models/dataset.model.dart';
import 'package:flutter/material.dart';

class DatasetUI extends StatelessWidget {
  int index;
  String t_name;
  Function callback;
  DatasetUI(
      {Key? key,
      required this.index,
      required this.t_name,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteStrings.DATASET,
                          arguments: DatasetModel(id: index, t_name: t_name))
                      .then((value) {
                    callback();
                  });
                },
                style: const ButtonStyle(alignment: Alignment.topLeft),
                child: Text(
                  t_name,
                  style: const TextStyle(color: Colors.white),
                ))),
        Divider(color: Color(CustomColors.DIVIDER))
      ]);
}
