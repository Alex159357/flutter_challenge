
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/task_column_model.dart';
import 'package:flutter_challenge/models/task_model.dart';

@immutable
abstract class DetailsScreenState{
  const DetailsScreenState();
}

class InitialDetailsScreenState extends DetailsScreenState{
  const InitialDetailsScreenState();
}

class LoadingDetailsScreenState extends DetailsScreenState{
}

class LoadedDetailsScreenState extends DetailsScreenState{
  TaskModel taskModel;
  TaskColumnModel taskColumnModel;
  List<TaskColumnModel> list;

  LoadedDetailsScreenState({required this.taskModel, required this.taskColumnModel, required this.list});
}

class ErrorDetailsScreenState extends DetailsScreenState{
  String msg;

  ErrorDetailsScreenState(this.msg);
}

class TaskDeletedDetailsScreenState extends DetailsScreenState{}