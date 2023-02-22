import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../bloc/create_task/create_screen_state.dart';
import '../../../../bloc/create_task/create_task_bloc.dart';
import '../../../../bloc/create_task/create_task_event.dart';
import '../../../../bloc/create_task/create_task_state.dart';
import '../../../../helpers/constains/priority_types.dart';
import '../../../../helpers/constains/values.dart';
import 'package:collection/collection.dart';
import '../../../../models/task_column_model.dart';
import '../../../widgets/state_less_wrapper.dart';
import '../../loading/loading_view.dart';

class CreatetaskView extends StateLessWrapper {
  late CreateTaskBloc bloc;

  CreatetaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc = context.read<CreateTaskBloc>();
    bloc.add(CreateInitEvent());
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios),
            ),
            title: const Text("New task"),
            actions: [_getSaveButton],
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _getTaskColumnSelect,
                const Divider(
                  endIndent: 16,
                  indent: 16,
                ),
                _getPrioritySelect,
                const Divider(
                  endIndent: 16,
                  indent: 16,
                ),
                _getEndTime,
                const Divider(
                  endIndent: 16,
                  indent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Text("Enter task title"),
                    ],
                  ),
                ),
                _getTaskNameField,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Text("Enter description of task"),
                    ],
                  ),
                ),
                _getDescriptionField
              ],
            ),
          ),
        ),
        _getLoadingView
      ],
    );
  }

  Widget get _getLoadingView =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          if (state.screenState is LoadingCreateScreenState) {
            return const LoadingView();
          } else if (state.screenState is CloseCreateScreenState) {
            return Container(
              width: double.infinity,
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Cool you done it!",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  ),
                  Text(
                      "Your task ${state.taskName}, was successfully created!"),
                  Text(
                      "${state.taskName}, was added to column ${state.columnList
                          .firstWhereIndexedOrNull((index, element) =>
                      element.id == state.selectedColumnId)!.title}"),
                  Container(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("To sheet"),
                      ))
                ],
              ),
            );
          } else if (state.screenState is OnErrorCreateScreenState) {
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yay! A SnackBar!'),));
            return const SizedBox(
              width: 0,
              height: 0,
            );
          } else {
            return const SizedBox(
              width: 0,
              height: 0,
            );
          }
        },
      );

  Widget get _getTaskNameField =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.deepPurple.shade50,
              ),
              child: TextFormField(
                initialValue: state.taskName,
                onFieldSubmitted: (v) async {
                  // onSubmitted!.call(v);
                },
                onChanged: (v) => bloc.add(OnTaskNameChanged(v)),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme
                    .of(context)
                    .primaryColor),
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    hintStyle: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(
                        color: Theme
                            .of(context)
                            .primaryColor
                            .withOpacity(.5)),
                    hintText: "Task title"),
              ),
            ),
          );
        },
      );

  Widget get _getTaskColumnSelect =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          if (state.columnList.isNotEmpty) {
            final initialValue = state.columnList.firstWhereOrNull((
                element) => element.id == state.selectedColumnId);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select column"),
                  const Spacer(),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.deepPurple.shade50,
                          ),
                          child: DropdownButton<TaskColumnModel>(
                            value: initialValue ?? state.columnList.first,
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            elevation: 16,
                            borderRadius: BorderRadius.circular(8),
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(),
                            onChanged: (TaskColumnModel? value) {
                              if (value != null) {
                                bloc.add(OnTaskColumnChanged(value.id));
                              }
                            },
                            items: state.columnList
                                .map<DropdownMenuItem<TaskColumnModel>>(
                                    (TaskColumnModel value) {
                                  return DropdownMenuItem<TaskColumnModel>(
                                    value: value,
                                    child: Text(value.title),
                                  );
                                }).toList(),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 16, bottom: 16),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade100,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(100))),
                              child: IconButton(
                                  onPressed: () {
                                    _dialogBuilder(context)
                                        .then((String? value) {
                                      if (value != null) {
                                        bloc.add(
                                            OnCreateNewColumnClicked(value));
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("No any column yet created"),
                  ElevatedButton(
                      onPressed: () {
                        _dialogBuilder(context).then((String? value) {
                          if (value != null) {
                            bloc.add(OnCreateNewColumnClicked(value));
                          }
                        });
                      },
                      child: const Text("Create"))
                ],
              ),
            );
          }
        },
      );

  Widget get _getEndTime =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          final date = DateFormat('yyyy-MM-dd')
              .format(DateTime.fromMillisecondsSinceEpoch(state.endTime));
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select deadline time"),
                TextButton(
                    onPressed: () {
                      _datePickerRoute(context, state.endTime).then(
                              (DateTime? value) =>
                              bloc.add(
                                  OnDateChanged(
                                      value!.millisecondsSinceEpoch)));
                    },
                    child: Text(
                      date,
                    ))
              ],
            ),
          );
        },
      );

  Widget get _getPrioritySelect =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select task priority"),
                const Spacer(),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.shade50,
                        ),
                        child: DropdownButton<PriorityTypes>(
                            value: PriorityTypes.fromId(state.priority),
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            elevation: 16,
                            borderRadius: BorderRadius.circular(8),
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(),
                            onChanged: (PriorityTypes? value) {
                              if (value != null) {
                                bloc.add(OnTaskPriorityChanged(value.getId()));
                              }
                            },
                            items: [
                              for (PriorityTypes priority
                              in PriorityTypes.values)
                                DropdownMenuItem<PriorityTypes>(
                                  value: priority,
                                  child: Text(priority.getName()),
                                )
                            ]
                          // PriorityTypes.values.map<DropdownMenuItem<PriorityTypes>>((PriorityTypes value) {
                          //     return DropdownMenuItem<PriorityTypes>(
                          //       value: value,
                          //       child: Text(value.toString()),
                          //     );
                          //   },
                          // ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget get _getDescriptionField =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.deepPurple.shade50,
              ),
              child: TextFormField(
                initialValue: state.taskName,
                onFieldSubmitted: (v) async {
                  // onSubmitted!.call(v);
                },
                onChanged: (v) => bloc.add(OnDescriptionChanged(v)),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme
                    .of(context)
                    .primaryColor),
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    hintStyle: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(
                        color: Theme
                            .of(context)
                            .primaryColor
                            .withOpacity(.5)),
                    hintText: "Task description"),
              ),
            ),
          );
        },
      );

  Widget get _getSaveButton =>
      BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (BuildContext context, state) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: animationDuration),
              child: state.didFieldsValid
                  ? TextButton(
                  onPressed: () => bloc.add(OnSaveButtonClicked()),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.deepPurple),
                  ))
                  : Container());
        },
      );

  Future<DateTime?> _datePickerRoute(BuildContext context,
      int arguments,) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.fromMillisecondsSinceEpoch(arguments),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
  }

  Future<String?> _dialogBuilder(BuildContext context) {
    String columnName = "";
    return dialogBuilder<String>(context: context,
      title: Container(),//const Text('Add new task column'),
      body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Any task need to be in column\n'),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurple.shade50,
            ),
            child: TextFormField(
              initialValue: columnName,
              onFieldSubmitted: (v) async {
                Navigator.of(context).pop(v);
              },
              onChanged: (v) => columnName = v,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme
                  .of(context)
                  .primaryColor),
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  hintStyle: Theme
                      .of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor
                          .withOpacity(.5)),
                  hintText: "Column title"),
            ),
          ),
        )
      ],
    ),
    positiveBtn: Container(
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge,
        ),
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    negativeBtn: Container(
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: const Text('Add'),
        onPressed: () {
          Navigator.of(context).pop(columnName);
        },
      ),
    )
    );

  }
}
