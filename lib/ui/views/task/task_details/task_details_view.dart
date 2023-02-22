import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/bloc/task_bloc/task_bloc.dart';
import 'package:flutter_challenge/helpers/ext/TaskModelExt.dart';
import 'package:flutter_challenge/models/task_column_model.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/task_bloc/task_bloc_event.dart';
import '../../../../bloc/task_detail/details_screen_state.dart';
import '../../../../bloc/task_detail/task_detail_bloc.dart';
import '../../../../bloc/task_detail/task_detail_event.dart';
import '../../../../bloc/task_detail/task_detail_state.dart';
import '../../../../helpers/constains/values.dart';
import '../../../screens/create_screen/create_screen.dart';
import '../../../widgets/state_less_wrapper.dart';

class TaskDetailsView extends StateLessWrapper {
  int columnId;
  int taskId;
  late TaskDetailBloc bloc;

  TaskDetailsView({Key? key, required this.columnId, required this.taskId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TaskDetailBloc()
        ..add(InitTaskDetailEvent(columnId: columnId, taskId: taskId)),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    bloc = BlocProvider.of<TaskDetailBloc>(context);

    return BlocListener<TaskDetailBloc, TaskDetailState>(
      listener: (context, state) {
        if (state.detailsScreenState is TaskDeletedDetailsScreenState) {
          context.read<TaskBloc>().add(InitTaskEvent());
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: _getTitle,
          actions: [

            IconButton(
                color: Colors.redAccent,
                onPressed: () {
                  dialogBuilder(
                      context: context,
                      title: const Text("Delete task"),
                      body: Column(
                        children: const [
                          Text('Are you sure, that you want delete task?')
                        ],
                      ),
                      positiveBtn: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            bloc.add(DeleteTaskTaskDetailEvent(
                                taskId: taskId, columnId: columnId));
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.redAccent),
                          )),
                      negativeBtn: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")));
                },
                icon: const Icon(Icons.delete_outline_outlined)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [_getColumnSelect, _getDates, _getDescription],
          ),
        ),
      ),
    );
  }

  Widget get _getTitle => BlocBuilder<TaskDetailBloc, TaskDetailState>(
        builder: (BuildContext context, state) {
          if (state.detailsScreenState is LoadedDetailsScreenState) {
            TaskModel task =
                (state.detailsScreenState as LoadedDetailsScreenState)
                    .taskModel;
            return Text(task.title);
          } else {
            return Container(
              child: Text("Error"),
            );
          }
        },
      );

  Widget get _getColumnSelect => BlocBuilder<TaskDetailBloc, TaskDetailState>(
        builder: (BuildContext context, state) {
          if (state.detailsScreenState is LoadedDetailsScreenState) {
            TaskModel task =
                (state.detailsScreenState as LoadedDetailsScreenState)
                    .taskModel;
            List<TaskColumnModel> list =
                (state.detailsScreenState as LoadedDetailsScreenState).list;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Move to column"),
                Spacer(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: DropdownButton<TaskColumnModel>(
                      value: state.selectedColumnId >= 0
                          ? list.firstWhere(
                              (element) => element.id == state.selectedColumnId)
                          : list[0],
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 16,
                      borderRadius: BorderRadius.circular(8),
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(),
                      onChanged: (TaskColumnModel? value) {
                        if (value != null) {
                          bloc.add(OnColumnSelectedTaskDetailEvent(value.id));
                          context.read<TaskBloc>().add(InitTaskEvent());
                        }
                      },
                      items: list.map<DropdownMenuItem<TaskColumnModel>>(
                          (TaskColumnModel value) {
                        return DropdownMenuItem<TaskColumnModel>(
                          value: value,
                          child: Text(value.title),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );

  Widget get _getDates => BlocBuilder<TaskDetailBloc, TaskDetailState>(
        builder: (BuildContext context, state) {
          if (state.detailsScreenState is LoadedDetailsScreenState) {
            final screenState =
                state.detailsScreenState as LoadedDetailsScreenState;
            return Container(
              margin: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Created date"),
                          Text(DateFormat('yyyy-MM-dd')
                              .format(screenState.taskModel.createDate)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Expire date"),
                          Text(DateFormat('yyyy-MM-dd')
                              .format(screenState.taskModel.endTime)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Spent time"),
                          Text(screenState.taskModel.getSpentTime),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      );

  Widget get _getDescription => BlocBuilder<TaskDetailBloc, TaskDetailState>(
        builder: (BuildContext context, state) {
          if (state.detailsScreenState is LoadedDetailsScreenState) {
            final screenState =
                state.detailsScreenState as LoadedDetailsScreenState;
            return Column(
              children: [
                Row(
                  children: [
                    const Text("Task description"),
                  ],
                ),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: Text(screenState.taskModel.description)),
              ],
            );
          }
          return Container();
        },
      );
}
