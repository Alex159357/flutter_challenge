import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/task_column_model.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../db/controller/task_db/task_column_db_controller.dart';
import '../../db/controller/task_db/task_column_db_controller_impl.dart';
import 'details_screen_state.dart';
import 'task_detail_event.dart';
import 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskDbController _tasksDb = TaskDbControllerImpl();

  TaskDetailBloc() : super(TaskDetailState().init()) {
    on<InitTaskDetailEvent>(_init);
    on<OnColumnSelectedTaskDetailEvent>(_onColumnSelectedTaskDetailEvent);
    on<DeleteTaskTaskDetailEvent>(_deleteTaskTaskDetailEvent);
  }

  void _init(InitTaskDetailEvent event, Emitter<TaskDetailState> emit) async {
      List<TaskColumnModel> taskList = await _tasksDb.loadTasks() ?? [];

      TaskColumnModel column = taskList.firstWhere((element) => element.id == event.columnId);

      TaskModel taskModel =
          column.tasks.firstWhere((element) => element.id == event.taskId);
      emit(state.clone(
          detailsScreenState: LoadedDetailsScreenState(
              taskModel: taskModel, taskColumnModel: column, list: taskList), selectedColumnId: taskModel.columnId));
  }

  FutureOr<void> _onColumnSelectedTaskDetailEvent(
      OnColumnSelectedTaskDetailEvent event,
      Emitter<TaskDetailState> emit) async {
    var loadedState = (state.detailsScreenState as LoadedDetailsScreenState);
    TaskModel task = loadedState.taskModel;
    List<TaskColumnModel> list = loadedState.list;
    final oldColumnIndex =
        list.indexWhere((element) => element.id == task.columnId);
    final oldTaskIndex = list[oldColumnIndex]
        .tasks
        .indexWhere((element) => element.id == task.id);
    final newColumnIndex =
        list.indexWhere((element) => element.id == event.columnId);
    list = await _tasksDb.moveTaskInLists(
        oldItemIndex: oldTaskIndex,
        oldListIndex: oldColumnIndex,
        newItemIndex: 0,
        newListIndex: newColumnIndex);
    emit(state.clone(selectedColumnId: event.columnId));
  }

  FutureOr<void> _deleteTaskTaskDetailEvent(DeleteTaskTaskDetailEvent event, Emitter<TaskDetailState> emit) async {
    final reuslt = await _tasksDb.deleteTask(columnId: event.columnId, taskId: event.taskId);
    if(reuslt) {
      emit(state.clone(detailsScreenState: TaskDeletedDetailsScreenState()));
    }
  }
}
