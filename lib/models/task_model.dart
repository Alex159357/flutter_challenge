import 'db_model.dart';

class TaskModel implements DbModel {
  int id;
  String title;
  String description;
  DateTime createDate;
  DateTime endTime;
  int priority;
  int spentTime;
  int columnId;
  bool didActive;
  bool didDone;
  DateTime? startTime;
  DateTime? stopTime;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.createDate,
      required this.endTime,
      required this.priority,
      required this.spentTime,
      required this.columnId,
      required this.didActive,
      required this.didDone,
      this.startTime,
      this.stopTime});

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      createDate: DateTime.fromMillisecondsSinceEpoch(map["create_date"]),
      endTime: DateTime.fromMillisecondsSinceEpoch(map["deadline_date"]),
      priority: map["priority"],
      spentTime: map["spent_time"],
      columnId: map["column_id"],
      didActive: map["did_active"],
      didDone: map["did_done"],
      startTime: map["start_time"] != null? DateTime.fromMillisecondsSinceEpoch(map["start_time"]) : null,
      stopTime: map["stop_time"]!=null? DateTime.fromMillisecondsSinceEpoch(map["stop_time"]): null
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "create_date": createDate.millisecondsSinceEpoch,
      "deadline_date": endTime.millisecondsSinceEpoch,
      "priority": priority,
      "spent_time": spentTime,
      "column_id": columnId,
      "did_active": didActive,
      "did_done": didDone,
      "start_time": startTime != null? startTime!.millisecondsSinceEpoch: null,
      "stop_time": stopTime!= null? stopTime!.millisecondsSinceEpoch: null
    };
  }

  @override
  DbModel? fromMap(Map<String, dynamic> map) => TaskModel.fromMap(map);
}
