

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/ui/widgets/lists/tasks_wrapper_list.dart';
import '../../../../bloc/task_bloc/TaskListState.dart';
import '../../../../bloc/task_bloc/task_bloc.dart';
import '../../../../bloc/task_bloc/task_bloc_event.dart';
import '../../../../bloc/task_bloc/task_bloc_state.dart';
import '../../../widgets/state_less_wrapper.dart';

class TaskView extends StateLessWrapper {
  late TaskBloc bloc;
  TaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc = context.read<TaskBloc>();
    bloc.add(InitTaskEvent());
    return Scaffold(
      body: SafeArea(child: _getTaskSheet),

    );
  }


  Widget get _getTaskSheet => BlocBuilder<TaskBloc, TaskBlocState>(builder: (BuildContext context, state) {
    if(state.taskListState is LoadingTaskListState){
      return const Center(child:  CircularProgressIndicator(),);
    }else if(state.taskListState is LoadErrorTaskListState){
      return Text((state.taskListState as LoadErrorTaskListState).message);
    }else {
      return TasksWrapperList();
    }
  },);

}
