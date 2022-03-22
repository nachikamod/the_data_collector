class DatasetModel {
  final int? id;
  final String t_name;
  final String? schema;

  DatasetModel({this.id, required this.t_name, this.schema});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      't_name': t_name,
      'schema': schema
    };
  }

  factory DatasetModel.fromMap(Map<String, dynamic> map) {
    return DatasetModel(
        id: map['id']?.toInt() ?? 0,
        t_name: map['t_name'] ?? '',
        schema: map['schema'] ?? ''
    );
  }

}