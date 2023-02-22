import '../../models/task_column_model.dart';
import 'create_screen_state.dart';

class CreateTaskState {
  final String taskName;
  final List<TaskColumnModel> columnList;
  final int selectedColumnId;
  final int endTime;
  final String description;
  final CreateScreenState screenState;
  final int priority;

  bool get didFieldsValid => taskName.isNotEmpty && description.isNotEmpty && selectedColumnId  >=0;

  CreateTaskState(
      {this.taskName = "",
      this.columnList = const [],
      this.selectedColumnId = -1,
      this.endTime = 0,
      this.description = "",
      this.screenState = const InitialCreateScreenState(),
      this.priority = 0});

  CreateTaskState clone(
      {String? taskName,
      int? columnId,
      List<TaskColumnModel>? columnList,
      int? selectedColumnId,
      int? endTime,
      String? description,
      CreateScreenState? screenState,
      int? priority}) {
    return CreateTaskState(
        taskName: taskName ?? this.taskName,
        columnList: columnList ?? this.columnList,
        selectedColumnId: selectedColumnId ?? this.selectedColumnId,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
        screenState: screenState ?? this.screenState,
        priority: priority ?? this.priority);
  }

  CreateTaskState init() {
    return CreateTaskState();
  }
}
