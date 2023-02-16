import 'package:bloc/bloc.dart';

import 'task_bloc_event.dart';
import 'task_bloc_state.dart';

class TaskBlocBloc extends Bloc<TaskBlocEvent, TaskBlocState> {
  TaskBlocBloc() : super(TaskBlocState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<TaskBlocState> emit) async {
    emit(state.clone());
  }
}
