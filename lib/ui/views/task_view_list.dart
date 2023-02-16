

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/ui/widgets/lists/tasks_wrapper_list.dart';

import '../../bloc/task_bloc/TaskListState.dart';
import '../../bloc/task_bloc/task_bloc_bloc.dart';
import '../../bloc/task_bloc/task_bloc_state.dart';

class TaskView extends StatelessWidget {
  late TaskBlocBloc bloc;
  TaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          _getTaskSheet
        ],
      ),
    );
  }


  Widget get _getTaskSheet => BlocBuilder<TaskBlocBloc, TaskBlocState>(builder: (BuildContext context, state) {
    if(state.taskListState is LoadingTaskListState){
      return const Center(child:  CircularProgressIndicator(),);
    }else if(state.taskListState is LoadErrorTaskListState){
      return Text((state.taskListState as LoadErrorTaskListState).message);
    }else {
      return TasksWrapperList();
    }
  },);

}
