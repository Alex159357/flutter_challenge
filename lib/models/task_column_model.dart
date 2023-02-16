import 'package:flutter_challenge/models/task_model.dart';

import 'db_model.dart';

class TaskColumnModel implements DbModel {
  int id;
  String title;
  List<TaskModel> tasks;

  TaskColumnModel({required this.id, required this.title, required this.tasks});

  factory TaskColumnModel.fromMap(Map<String, dynamic> map) => TaskColumnModel(
        id: map["id"],
        title: map["title"],
        tasks: map.entries.map( (entry) => TaskModel.fromMap).cast<TaskModel>().toList(),
      );

  @override
  Map<String, dynamic> toMap() {
    return {};
  }


}
