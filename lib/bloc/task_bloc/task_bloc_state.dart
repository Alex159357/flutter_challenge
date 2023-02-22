import 'package:flutter_challenge/bloc/task_bloc/single_task_state.dart';

import 'TaskListState.dart';

class TaskBlocState {
  final TaskListState taskListState;
  final SingleTaskState singleTaskState;
  final int activeTaskId;


  TaskBlocState({this.taskListState = const LoadingTaskListState(), this.singleTaskState = const InitialTaskState(), this.activeTaskId = -1});

  TaskBlocState init() {
    return TaskBlocState();
  }

  TaskBlocState clone({TaskListState? taskListState, String? expandedTaskId, SingleTaskState? singleTaskState, int? activeTaskId}) {
    return TaskBlocState(
      taskListState: taskListState ?? this.taskListState,
        singleTaskState: singleTaskState ?? this.singleTaskState,
        activeTaskId: activeTaskId ?? this.activeTaskId
    );
  }
}
