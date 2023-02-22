

import 'package:flutter_challenge/models/task_model.dart';

abstract class SingleTaskState{

  const SingleTaskState();
}

class InitialTaskState extends SingleTaskState{
  const InitialTaskState();
}

class TaskTimerActive extends SingleTaskState{
  final TaskModel task;

  TaskTimerActive({required this.task});
}

class TaskTimerDeActivate extends SingleTaskState{
  final int columnId;
  final int taskId;

  TaskTimerDeActivate({required this.columnId, required this.taskId});
}