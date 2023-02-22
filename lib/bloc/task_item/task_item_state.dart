class TaskItemState {

  final String expandedTaskId;


  TaskItemState({ this.expandedTaskId = ""});

  TaskItemState init() {
    return TaskItemState();
  }

  TaskItemState clone({String? expandedTaskId}) {
    return TaskItemState(
        expandedTaskId: expandedTaskId ?? this.expandedTaskId
    );
  }
}
