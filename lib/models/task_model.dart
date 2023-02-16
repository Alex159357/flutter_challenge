

import 'db_model.dart';

class TaskModel implements DbModel{
  int id;

  TaskModel({required this.id});

  factory TaskModel.fromMap(Map<String, dynamic> map)=> TaskModel(
    id: map["id"]
  );

  @override
  Map<String, dynamic> toMap() {
    return {};
  }

}