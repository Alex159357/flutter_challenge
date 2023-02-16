
import 'package:flutter/material.dart';

import '../../models/task_column_model.dart';

@immutable
abstract class TaskListState{
  const TaskListState();
}

class LoadingTaskListState extends TaskListState{
  const LoadingTaskListState();
}

class LoadedTaskListState extends TaskListState{
  final List<TaskColumnModel> taskList;

  const LoadedTaskListState(this.taskList);
}

class LoadErrorTaskListState extends TaskListState{
  final String message;

  const LoadErrorTaskListState(this.message);
}