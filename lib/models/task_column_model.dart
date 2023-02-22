import 'package:flutter_challenge/models/task_model.dart';

import 'db_model.dart';

class TaskColumnModel implements DbModel {
  int id;
  String title;
  List<TaskModel> tasks;
  bool didArchive ;

  TaskColumnModel({required this.id, required this.title, required this.tasks, this.didArchive = false});

  factory TaskColumnModel.fromMap(Map<String, dynamic> map) => TaskColumnModel(
        id: map["id"],
        title: map["title"],
        tasks: (map["tasks"] as List<dynamic>).map((e) => TaskModel.fromMap(e)).toList(),
    didArchive: map["did_archive"]
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "tasks": tasks.map((e) => e.toMap()).toList(),
      "did_archive": didArchive
    };
  }

  @override
  DbModel? fromMap(Map<String, dynamic> map)=>  TaskColumnModel.fromMap(map);


}
