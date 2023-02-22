import 'package:animations/animations.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/helpers/constains/values.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../bloc/task_bloc/TaskListState.dart';
import '../../../bloc/task_bloc/task_bloc.dart';
import '../../../bloc/task_bloc/task_bloc_event.dart';
import '../../../bloc/task_bloc/task_bloc_state.dart';
import '../../../bloc/task_item/task_item_bloc.dart';
import '../../../bloc/task_item/task_item_event.dart';
import '../../../models/task_column_model.dart';
import '../../../models/task_model.dart';
import '../../views/task/task_details/task_details_view.dart';
import '../cards/task_card.dart';
import '../state_less_wrapper.dart';

class TasksWrapperList extends StateLessWrapper {
  late List<DragAndDropList> lists;
  late TaskBloc bloc;

  TasksWrapperList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc = context.read<TaskBloc>();
    return BlocProvider(
        create: (BuildContext context) =>
            TaskItemBloc()..add(InitTaskItemEvent()),
        child: _columnList);
  }

  Widget get _columnList => BlocBuilder<TaskBloc, TaskBlocState>(
        builder: (BuildContext context, state) {
          double screen = MediaQuery.of(context).size.shortestSide;
          if (state.taskListState is LoadedTaskListState) {
            var taskState = state.taskListState as LoadedTaskListState;
            if (taskState.taskList.isNotEmpty) {
              lists = taskState.taskList.map((e)=>buildList(e, context)).toList();
              return DragAndDropLists(
                  addLastItemTargetHeightToTop: true,
                  axis: Axis.horizontal,
                  listWidth: screen < 600 ? screen - 50 : 400,
                  listDraggingWidth: screen < 600 ? screen - 50 : 400,
                  listSizeAnimationDurationMilliseconds: animationDuration,
                  listPadding: const EdgeInsets.all(8),
                  listInnerDecoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: lists,
                  itemDecorationWhileDragging: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  listDragHandle: buildDragHandle(isList: true),
                  itemDragHandle: buildDragHandle(),
                  onItemReorder: _onReorderListItem,
                  onListReorder: _onReorderList,
                  constrainDraggingAxis: true);
            } else
              return Text("No items yet");
          } else {
            return Text("Error");
          }
        },
      );

  DragAndDropList buildList(TaskColumnModel list, BuildContext context) => DragAndDropList(
        header: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade200,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Row(
              children: [
                list.didArchive? Container(width: 0, height: 50,):
                IconButton(
                  color: Colors.redAccent,
                    onPressed: () => dialogBuilder(context: context, title: const Text('Remove column'), body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Are you sure?\n'),
                        Text("If you delete column, all tasks inside will be deleted to")
                      ],
                    ), positiveBtn: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ), negativeBtn: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.redAccent),),
                      onPressed: () {
                        bloc.add(DeleteColumn(list.id));
                        Navigator.of(context).pop();
                      },
                    ),
                    ),
                    icon: Icon(Icons.delete_outline_outlined)),
                Text(
                  "${list.title} : ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "${list.tasks.length}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
        children: list.tasks
            .map((item) => DragAndDropItem(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getSingleTaskItem(item),
                )))
            .toList(),
      );



  Widget _getSingleTaskItem(TaskModel taskModel) {
    return BlocBuilder<TaskBloc, TaskBlocState>(
  builder: (context, state) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: animationDuration),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return TaskDetailsView(
          columnId: taskModel.columnId,
          taskId: taskModel.id,
        );
      },
      closedElevation: 6.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      openColor: Colors.white,
      closedColor: Colors.white,
      onClosed: (v){
        bloc.add(InitTaskEvent());
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return TaskCard(
          taskModel: taskModel,
          onActionBtnClicked: () {
            bloc.add(OnTaskActionClicked(activeId: taskModel.id, columnId: taskModel.columnId));
          }, didActive: state.activeTaskId == taskModel.id,
        );
      },
    );
  },
);
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.top;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        margin: isList
            ? EdgeInsets.only(top: 15)
            : EdgeInsets.only(top: 20, right: 12),
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  void _onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    bloc.add(OnListReorderTaskEvent(
        oldListIndex: oldListIndex, newListIndex: newListIndex));
  }

  void _onReorderListItem(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    bloc.add(OnTaskItemMoved(
        oldItemIndex: oldItemIndex,
        oldListIndex: oldListIndex,
        newItemIndex: newItemIndex,
        newListIndex: newListIndex));
  }
}
