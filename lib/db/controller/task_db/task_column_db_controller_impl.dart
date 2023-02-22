import 'package:flutter_challenge/db/controller/task_db/task_column_db_controller.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/task_column_model.dart';
import '../../../models/task_model.dart';
import '../general_controller/general_db_controller.dart';

class TaskDbControllerImpl extends GeneralDbController<TaskColumnModel>
    implements TaskDbController {
  final int archiveColumnId = 9999;

  TaskDbControllerImpl() : super(key: "TASKS_LIST");

  @override
  Future<void> deleteTable() async {
    delete();
  }

  @override
  Future<List<TaskColumnModel>?> loadTasks() async {
    List<TaskColumnModel> normalizedList = [];
    final list = await readList();
    if (list != null) {
      normalizedList.addAll(list.map((e) => e!));
    }
    if(normalizedList.firstWhereOrNull((element) => element.didArchive) == null) {
      List<TaskModel> tasks = [];
      for (var element in normalizedList) {
        tasks.addAll(element.tasks.where((element) => element.columnId == archiveColumnId));
      }
      normalizedList.add(
          TaskColumnModel(didArchive: true, id: 0, title: "Done", tasks: tasks));
    }
    return normalizedList;
  }


  @override
  Future<List<TaskColumnModel>> moveTaskInLists({required int oldItemIndex,
    required int oldListIndex,
    required int newItemIndex,
    required int newListIndex}) async {
    List<TaskColumnModel> _tmpList = await loadTasks() ?? [];
    final oldList = _tmpList[oldListIndex];
    final movingItem = oldList.tasks[oldItemIndex];
    movingItem.columnId = _tmpList[newListIndex].id;
    _tmpList[oldListIndex].tasks.removeAt(oldItemIndex);
    _tmpList[newListIndex].tasks.insert(newItemIndex, movingItem);
    writeOrUpdateList(_tmpList);
    return _tmpList;
  }

  @override
  Future<List<TaskColumnModel>> reOrderList(
      {required int oldListIndex, required int newListIndex}) async {
    List<TaskColumnModel> _tmpList = await loadTasks() ?? [];
    final movedList = _tmpList.removeAt(oldListIndex);
    _tmpList.insert(newListIndex, movedList);
    writeOrUpdateList(_tmpList);
    return _tmpList;
  }

  @override
  Future<List<TaskColumnModel>?> addNewColumn(TaskColumnModel model) async {
    List<TaskColumnModel> _tmpList = await loadTasks() ?? [];
    _tmpList.add(model);
    await writeOrUpdateList(_tmpList);
    return _tmpList;
  }

  @override
  Future<bool> addTask(int id, TaskModel taskModel) async {
    try {
      List<TaskColumnModel> _tmpList = await loadTasks() ?? [];
      if (_tmpList.isNotEmpty) {
        _tmpList
            .firstWhere((element) => element.id == id)
            .tasks
            .add(taskModel);
        await writeOrUpdateList(_tmpList);
        return Future.value(true);
      }
      return Future.value(false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<List<TaskColumnModel>?> onTaskActionChanged(int columnId, int taskId) async {

    return await loadTasks() ?? [];
  }

  @override
  Future<bool> deleteColumn({required int columnId}) async {
    List<TaskColumnModel>? tmpList = await loadTasks();
    if(tmpList != null){
      tmpList.removeWhere((element) => element.id == columnId);
      await writeOrUpdateList(tmpList);
      return true;
    }else{
      return false;
    }
  }

  @override
  Future<bool> deleteTask({required int columnId, required int taskId}) async{
    List<TaskColumnModel>? tmpList = await loadTasks();
    if(tmpList != null){
      final column = tmpList.firstWhereOrNull((element) => element.id == columnId);
      if(column != null) {
        final columnIndex = tmpList.indexOf(column);
        column.tasks.removeWhere((element) => element.id == taskId);
        tmpList.removeAt(columnIndex);
        tmpList.insert(columnIndex, column);
        await writeOrUpdateList(tmpList);
      }
    }
    return true;
  }

  @override
  Future<List<TaskColumnModel>?> updateTask(TaskModel taskModel) async {
    List<TaskColumnModel>? tmpList = await loadTasks();
    if(tmpList != null){
      final curColumnIndex = tmpList.indexWhere((element) => element.id == taskModel.columnId);
      final curTaskIndex = tmpList[curColumnIndex].tasks.indexWhere((element) => element.id == taskModel.id);
      tmpList[curColumnIndex].tasks.removeWhere((element) => element.id == taskModel.id);
      tmpList[curColumnIndex].tasks.insert(curTaskIndex, taskModel);
      await writeOrUpdateList(tmpList);

      return tmpList;
    }
    return null;
  }

  @override
  Future<void> updateColumnList(List<TaskColumnModel> list) async {
    await writeOrUpdateList(list);
  }


}
