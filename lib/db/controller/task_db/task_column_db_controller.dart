import 'package:flutter_challenge/models/task_model.dart';

import '../../../models/task_column_model.dart';
import '../general_controller/general_db.dart';

abstract class TaskDbController implements GeneralDb{

  Future<List<TaskColumnModel>?> loadTasks();

  Future<List<TaskColumnModel>?> updateTask(TaskModel taskModel);

  Future<void> updateColumnList(List<TaskColumnModel> list);

  Future<List<TaskColumnModel>> reOrderList({required int oldListIndex, required int newListIndex});

  Future<List<TaskColumnModel>> moveTaskInLists(
      {required int oldItemIndex,
        required int oldListIndex,
        required int newItemIndex,
        required int newListIndex});

  Future<bool> deleteTask({required int columnId, required int taskId});

  Future<bool> deleteColumn({required int columnId});

  Future<List<TaskColumnModel>?> addNewColumn(TaskColumnModel model);

  Future<List<TaskColumnModel>?> onTaskActionChanged(int columnId, int taskId);

  Future<bool> addTask(int id, TaskModel taskModel);

}