abstract class TaskDetailEvent {}

class InitTaskDetailEvent extends TaskDetailEvent {
  final int columnId;
  final int taskId;

  InitTaskDetailEvent({required this.columnId, required this.taskId});
}

class OnColumnSelectedTaskDetailEvent extends TaskDetailEvent{
  final int columnId;

  OnColumnSelectedTaskDetailEvent(this.columnId);
}

class DeleteTaskTaskDetailEvent extends TaskDetailEvent{
  final int columnId;
  final int taskId;

  DeleteTaskTaskDetailEvent({required this.columnId, required this.taskId});
}