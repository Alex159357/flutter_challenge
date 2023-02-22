import '../../models/task_column_model.dart';
import '../../models/task_model.dart';

abstract class TaskBlocEvent {}

class InitTaskEvent extends TaskBlocEvent {}

class OnListReorderTaskEvent extends TaskBlocEvent {
  final int oldListIndex;
  final int newListIndex;

  OnListReorderTaskEvent(
      {required this.oldListIndex, required this.newListIndex});
}

class OnTaskItemMoved extends TaskBlocEvent {
  final int oldItemIndex;
  final int oldListIndex;
  final int newItemIndex;
  final int newListIndex;

  OnTaskItemMoved(
      {required this.oldItemIndex,
      required this.oldListIndex,
      required this.newItemIndex,
      required this.newListIndex});
}

class OnTaskActionClicked extends TaskBlocEvent{
  final int activeId;
  final int columnId;

  OnTaskActionClicked({required this.activeId, required this.columnId});
}

class DeleteColumn extends TaskBlocEvent{
  final int columnId;

  DeleteColumn(this.columnId);
}

class OnSpentTimeChangedEvent extends TaskBlocEvent{
  int columnId;
  int taskId;
  int sec;
  OnSpentTimeChangedEvent({required this.sec, required this.columnId, required this.taskId});
}

class OnTaskProgressChanged extends TaskBlocEvent{
  List<TaskColumnModel> list;

  OnTaskProgressChanged(this.list);
}