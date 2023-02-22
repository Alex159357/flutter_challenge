import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/bloc/task_bloc/task_bloc.dart';
import 'package:flutter_challenge/helpers/ext/TaskModelExt.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../bloc/task_bloc/task_bloc_event.dart';
import '../../../bloc/task_bloc/task_bloc_state.dart';
import '../../../bloc/task_item/task_item_bloc.dart';
import '../../../bloc/task_item/task_item_event.dart';
import '../../../bloc/task_item/task_item_state.dart';
import '../../../helpers/constains/priority_types.dart';
import '../../../helpers/constains/values.dart';
import '../state_less_wrapper.dart';

class TaskCard extends StateLessWrapper {
  final TaskModel taskModel;
  final VoidCallback onActionBtnClicked;
  final bool didActive;

  TaskCard({Key? key, required this.taskModel, required this.onActionBtnClicked, required this.didActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getCard(context);
  }

  Widget _getCard(BuildContext context) => Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    taskModel.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Created at"),
                Text(DateFormat('yyyy-MM-dd').format(taskModel.createDate))
              ],
            ),
          ), Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("state"),
                Text(taskModel.columnId.toString())
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.03),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Deadline"),
                  Text(DateFormat('yyyy-MM-dd').format(taskModel.endTime))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Priority"),
                Text(PriorityTypes.fromId(taskModel.priority).getName())
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.03),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Spent time"),
                  Text(taskModel.getSpentTime),
                  taskModel.didDone? Container():
                  IconButton(
                      color: didActive? Colors.redAccent:  Colors.greenAccent,
                      onPressed: ()=> onActionBtnClicked.call(), icon: Icon(didActive? Icons.stop: Icons.play_arrow )),
                ],
              ),
            ),
          ),
        ],
      );
}
