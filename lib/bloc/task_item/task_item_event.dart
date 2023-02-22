abstract class TaskItemEvent {}

class InitTaskItemEvent extends TaskItemEvent {}

class OnExpandedTaskClicked extends TaskItemEvent{
  final String taskId;

  OnExpandedTaskClicked(this.taskId);
}