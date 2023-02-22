

import '../models/task_column_model.dart';
import '../models/task_model.dart';

class TasksDb{
  static List<TaskColumnModel> _taskList = [];

  Future<List<TaskColumnModel>> loadTasks()async{
    _taskList.clear();
    // await Future.delayed(Duration(milliseconds: 2000));
    // for(int i =0; i< 5; i++){
    //   List<TaskModel> taskList = [];
    //   for(int j= 0; j<10; j++){
    //     taskList.add(TaskModel(id: "$j:$i", title: ''));
    //   }
    //   _taskList.add(TaskColumnModel(id: i, title: "Title$i", tasks: taskList));
    // }

    return _taskList;
  }

  Future<List<TaskColumnModel>> reOrderList({required int oldListIndex, required int newListIndex})async{
    final movedList = _taskList.removeAt(oldListIndex);
    _taskList.insert(newListIndex, movedList);
    return _taskList;
  }

  Future<List<TaskColumnModel>> moveTaskInLists(
      {required int oldItemIndex,
      required int oldListIndex,
      required int newItemIndex,
      required int newListIndex})async{
    final oldList = _taskList[oldListIndex];
    final movingItem = oldList.tasks[oldItemIndex];
    _taskList[oldListIndex].tasks.removeAt(oldItemIndex);
    _taskList[newListIndex].tasks.insert(newItemIndex, movingItem);
    return _taskList;
  }

}