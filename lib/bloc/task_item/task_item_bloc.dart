import 'dart:async';

import 'package:bloc/bloc.dart';

import 'task_item_event.dart';
import 'task_item_state.dart';

class TaskItemBloc extends Bloc<TaskItemEvent, TaskItemState> {
  TaskItemBloc() : super(TaskItemState().init()) {
    on<InitTaskItemEvent>(_init);
    on<OnExpandedTaskClicked>(_onExpandedStateChanged);
  }

  void _init(InitTaskItemEvent event, Emitter<TaskItemState> emit) async {
    emit(state.init());
  }

  FutureOr<void> _onExpandedStateChanged(OnExpandedTaskClicked event, Emitter<TaskItemState> emit) {
    emit(state.clone(expandedTaskId: event.taskId != state.expandedTaskId? event.taskId: ""));
  }
}
