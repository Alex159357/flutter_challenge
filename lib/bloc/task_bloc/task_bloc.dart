import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/bloc/task_bloc/single_task_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../db/controller/history_controller/HistoryDbImpl.dart';
import '../../db/controller/history_controller/history_controller.dart';
import '../../db/controller/task_db/task_column_db_controller.dart';
import '../../db/controller/task_db/task_column_db_controller_impl.dart';
import '../../db/tasks_db.dart';
import '../../helpers/timer_controller.dart';
import '../../models/histary_model.dart';
import '../../models/task_column_model.dart';
import '../../models/task_model.dart';
import 'TaskListState.dart';
import 'task_bloc_event.dart';
import 'task_bloc_state.dart';

class TaskBloc extends Bloc<TaskBlocEvent, TaskBlocState> {
  final TaskDbController _tasksDb = TaskDbControllerImpl();
  final HistoryDb _historyDb = HistoryDbImpl();
  final TimerController _timerController = TimerController();

  TaskBloc() : super(TaskBlocState().init()) {
    on<InitTaskEvent>(_init);
    on<OnListReorderTaskEvent>(_onListReorder);
    on<OnTaskItemMoved>(_onTaskItemMoved);
    on<OnTaskActionClicked>(_onTaskActionClicked);
    on<DeleteColumn>(_deleteColumn);
    on<OnSpentTimeChangedEvent>(_onSpentTimeChangedEvent);
    on<OnTaskProgressChanged>(_onTaskProgressChanged);
  }

  void _init(InitTaskEvent event, Emitter<TaskBlocState> emit) async {
    List<TaskColumnModel?>? taskList = await _tasksDb.loadTasks();
    if (taskList != null) {
      emit(state.clone(
          taskListState: LoadedTaskListState(
              taskList.whereType<TaskColumnModel>().toList())));
    }
  }

  FutureOr<void> _onListReorder(
      OnListReorderTaskEvent event, Emitter<TaskBlocState> emit) async {
    final newList = await _tasksDb.reOrderList(
        oldListIndex: event.oldListIndex, newListIndex: event.newListIndex);
    List<TaskColumnModel>? tasList = await _tasksDb.loadTasks();
    if (tasList != null) {
      _historyDb.putHistory(HistoryModel(
        eventName: "Item moved",
        eventDescription: "Task ${tasList[event.oldListIndex].title},"
            "on position ${event.newListIndex + 1}",
        eventDateTime: DateTime.now(),
      ));
    }
    emit(state.clone(taskListState: LoadedTaskListState(newList)));
  }

  FutureOr<void> _onTaskItemMoved(
      OnTaskItemMoved event, Emitter<TaskBlocState> emit) async {
    List<TaskColumnModel>? tasList = await _tasksDb.loadTasks();
    if (tasList != null) {
      _historyDb.putHistory(HistoryModel(
        eventName: "Item moved",
        eventDescription:
            "Task ${tasList[event.oldListIndex].tasks[event.oldItemIndex].title},"
            "moved from column ${tasList[event.oldListIndex].title} to ${tasList[event.newListIndex]}"
            "on position ${event.newItemIndex + 1}",
        eventDateTime: DateTime.now(),
      ));
    }
    final newList = await _tasksDb.moveTaskInLists(
        oldItemIndex: event.oldItemIndex,
        oldListIndex: event.oldListIndex,
        newItemIndex: event.newItemIndex,
        newListIndex: event.newListIndex);
    emit(state.clone(taskListState: LoadedTaskListState(newList)));
  }

  FutureOr<void> _onTaskActionClicked(
      OnTaskActionClicked event, Emitter<TaskBlocState> emit) async {
    List<TaskColumnModel>? tasList = await _tasksDb.loadTasks();
    if(tasList != null){
     final columnIndex = tasList.indexWhere((element) => element.id == event.columnId);
     final taskIndex = tasList[columnIndex].tasks.indexWhere((element) => element.id == event.activeId);
     final task = tasList[columnIndex].tasks[taskIndex];
     if(state.activeTaskId != event.activeId) {
       _historyDb.putHistory(HistoryModel(
         eventName: "Start task $task state changed",
         eventDescription:
         "$task has changed its status to in progress",
         eventDateTime: DateTime.now(),
       ));
       emit(state.clone(activeTaskId: event.activeId));
        _timerController.startTimer(
            startTime: task.spentTime,
            onTimeChanged: (time) {
              task.spentTime = Duration(minutes: time).inMilliseconds;
              tasList[columnIndex].tasks.removeAt(taskIndex);
              tasList[columnIndex].tasks.insert(taskIndex, task);
              add(OnTaskProgressChanged(tasList));
            });
      }else{
       _historyDb.putHistory(HistoryModel(
         eventName: "Start task $task state changed",
         eventDescription:
         "$task has changed its status to paused",
         eventDateTime: DateTime.now(),
       ));
       emit(state.clone(activeTaskId: -1));
       _timerController.stopTimer(onTimerStopped: (){
         add(OnTaskProgressChanged(tasList));
       });
     }

    }
  }

  FutureOr<void> _onTaskProgressChanged(
      OnTaskProgressChanged event, Emitter<TaskBlocState> emit) {
    _tasksDb.updateColumnList(event.list);
    emit(state.clone(taskListState: LoadedTaskListState(event.list)));
  }

  FutureOr<void> _deleteColumn(
      DeleteColumn event, Emitter<TaskBlocState> emit) async {
    final result = await _tasksDb.deleteColumn(columnId: event.columnId);
    add(InitTaskEvent());
  }

  FutureOr<void> _onSpentTimeChangedEvent(
      OnSpentTimeChangedEvent event, Emitter<TaskBlocState> emit) async {
    List<TaskColumnModel> newList =
        (state.taskListState as LoadedTaskListState).taskList;
    // TaskModel taskModel = newList
    //     .firstWhere((element) => element.id == event.columnId)
    //     .tasks
    //     .firstWhere((element) => element.id == event.taskId);
    // taskModel.didActive = true;
    // taskModel.spentTime = Duration(seconds: event.sec).inMilliseconds;
    // final list =  await _tasksDb.updateTask(taskModel);
    // emit(state.clone(taskListState: LoadedTaskListState(list!), singleTaskState: TaskTimerActive(task: taskModel)));
  }
}
