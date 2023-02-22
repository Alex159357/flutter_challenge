import '../../models/db_model.dart';
import '../../models/histary_model.dart';
import '../../models/task_column_model.dart';
import '../../models/task_model.dart';
import '../../ui/widgets/cards/history_task_item.dart';

class DbMapper<T extends DbModel> {
  T? fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      switch (T) {
        case TaskColumnModel:
          return TaskColumnModel.fromMap(map) as T;
        case TaskModel:
          return TaskModel.fromMap(map) as T;
      }
    }
    return null;
  }

  List<T?>? fromMapList(List<dynamic>? list) {
    if (list != null) {
      switch (T) {
        case TaskColumnModel:
          TaskColumnModel.fromMap(list[0]);
          return list.map((e) => TaskColumnModel.fromMap(e)).toList() as List<T>;
        case HistoryModel:
          return list.map((e) => HistoryModel.fromMap(e)).toList() as List<T>;
      }
    }
    return null;
  }
}
