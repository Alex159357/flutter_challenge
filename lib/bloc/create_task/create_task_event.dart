import 'create_screen_state.dart';

abstract class CreateTaskEvent {}

class CreateInitEvent extends CreateTaskEvent {}

class OnTaskColumnChanged extends CreateTaskEvent{
  final int id;

  OnTaskColumnChanged(this.id);
}
class OnTaskPriorityChanged extends CreateTaskEvent{
  final int id;

  OnTaskPriorityChanged(this.id);
}

class OnDescriptionChanged extends CreateTaskEvent{
  final String description;

  OnDescriptionChanged(this.description);
}

class OnTaskNameChanged extends CreateTaskEvent{
  final String taskName;

  OnTaskNameChanged(this.taskName);
}

class OnDateChanged extends CreateTaskEvent{
  final int dateMills;

  OnDateChanged(this.dateMills);
}

class OnSaveButtonClicked extends CreateTaskEvent{}

class OnCreateNewColumnClicked extends CreateTaskEvent{
  final String ColumnName;

  OnCreateNewColumnClicked(this.ColumnName);
}

class OnCreateScreenStateChanged extends CreateTaskEvent{
  final CreateScreenState screenState;

  OnCreateScreenStateChanged(this.screenState);
}