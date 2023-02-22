import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/db/controller/task_db/task_column_db_controller_impl.dart';
import 'package:flutter_challenge/helpers/constains/priority_types.dart';
import 'package:flutter_challenge/models/histary_model.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:collection/collection.dart';
import '../../db/controller/history_controller/HistoryDbImpl.dart';
import '../../db/controller/history_controller/history_controller.dart';
import '../../db/controller/task_db/task_column_db_controller.dart';
import '../../models/task_column_model.dart';
import 'create_screen_state.dart';
import 'create_task_event.dart';
import 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  TaskDbController taskDbController = TaskDbControllerImpl();
  final HistoryDb _historyDb = HistoryDbImpl();

  CreateTaskBloc() : super(CreateTaskState().init()) {
    on<CreateInitEvent>(_init);
    on<OnTaskNameChanged>(_onTaskNameChanged);
    on<OnDateChanged>(_onDateChanged);
    on<OnSaveButtonClicked>(_onSaveClicked);
    on<OnDescriptionChanged>(_onDescriptionChanged);
    on<OnCreateNewColumnClicked>(_onCreateNewColumnClicked);
    on<OnTaskColumnChanged>(_onTaskColumnChanged);
    on<OnCreateScreenStateChanged>(_onCreateScreenStateChanged);
    on<OnTaskPriorityChanged>(_onTaskPriorityChanged);
  }

  void _init(CreateInitEvent event, Emitter<CreateTaskState> emit) async {
    final List<TaskColumnModel?>? taskList = await taskDbController.loadTasks();
    if (taskList != null && taskList.isNotEmpty) {
      final fList = taskList.map((e) => e!).toList();
      fList.removeWhere((element) => element.didArchive);
      emit(state.clone(
          selectedColumnId: fList.first.id,
          columnList: fList,
          endTime: DateTime.now().millisecondsSinceEpoch));
    } else {
      emit(state.clone(
          selectedColumnId: -1,
          columnList: [],
          endTime: DateTime.now().millisecondsSinceEpoch));
    }
  }

  FutureOr<void> _onTaskColumnChanged(
      OnTaskColumnChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(selectedColumnId: event.id));
  }

  FutureOr<void> _onTaskNameChanged(
      OnTaskNameChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(taskName: event.taskName));
  }

  FutureOr<void> _onDateChanged(
      OnDateChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(endTime: event.dateMills));
  }

  FutureOr<void> _onDescriptionChanged(
      OnDescriptionChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(description: event.description));
  }

  FutureOr<void> _onSaveClicked(
      OnSaveButtonClicked event, Emitter<CreateTaskState> emit) async {
    add(OnCreateScreenStateChanged(LoadingCreateScreenState()));
    final List<TaskColumnModel?>? taskList = await taskDbController.loadTasks();
    if (taskList != null && taskList.isNotEmpty) {
      TaskColumnModel? column = taskList
          .firstWhereOrNull((element) => element!.id == state.selectedColumnId);
      if (column != null) {
        TaskModel taskModel = TaskModel(
          id: column.tasks.length+1,
          title: state.taskName,
          description: state.description,
          createDate: DateTime.now(),
          endTime: DateTime.fromMillisecondsSinceEpoch(state.endTime),
          priority: state.priority,
          spentTime: 0,
          columnId: column.id,
          didActive: false,
          didDone: false,
        );
        bool result =
            await taskDbController.addTask(state.selectedColumnId, taskModel);
        if (result) {
          _historyDb.putHistory(HistoryModel(
            eventName: "Create task",
            eventDescription:
                "Task ${state.taskName}, created to column ${column.title}\n"
                "with priority ${PriorityTypes.fromId(state.priority)}",
            eventDateTime: DateTime.now(),
          ));
          await Future.delayed(const Duration(milliseconds: 500));
          add(OnCreateScreenStateChanged(CloseCreateScreenState()));
        } else {
          add(OnCreateScreenStateChanged(OnErrorCreateScreenState("")));
        }
      }
    }
  }

  FutureOr<void> _onCreateNewColumnClicked(
      OnCreateNewColumnClicked event, Emitter<CreateTaskState> emit) async {
    add(OnCreateScreenStateChanged(LoadingCreateScreenState()));
    final List<TaskColumnModel?>? taskList = await taskDbController.loadTasks();
    TaskColumnModel taskColumnModel = TaskColumnModel(
        id: taskList != null ? taskList.length + 1 : 0,
        title: event.ColumnName,
        tasks: []);

    final result = await taskDbController.addNewColumn(taskColumnModel);
    if (result != null) {
      add(CreateInitEvent());
      _historyDb.putHistory(HistoryModel(
        eventName: "Create column",
        eventDescription: "Column ${taskColumnModel.title}, created to column",
        eventDateTime: DateTime.now(),
      ));
    } else {
      Fluttertoast.showToast(
          msg: "Error while adding new column",
          backgroundColor: Colors.redAccent,
          timeInSecForIosWeb: 3);
    }
    add(OnCreateScreenStateChanged(const InitialCreateScreenState()));
  }

  FutureOr<void> _onCreateScreenStateChanged(
      OnCreateScreenStateChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(screenState: event.screenState));
  }

  FutureOr<void> _onTaskPriorityChanged(
      OnTaskPriorityChanged event, Emitter<CreateTaskState> emit) {
    emit(state.clone(priority: event.id));
  }
}
