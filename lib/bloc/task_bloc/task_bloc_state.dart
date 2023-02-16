import 'TaskListState.dart';

class TaskBlocState {
  final TaskListState taskListState;


  TaskBlocState({this.taskListState = const LoadingTaskListState()});

  TaskBlocState init() {
    return TaskBlocState();
  }

  TaskBlocState clone({TaskListState? taskListState}) {
    return TaskBlocState(
      taskListState: taskListState ?? this.taskListState
    );
  }
}
