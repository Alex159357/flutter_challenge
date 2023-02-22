import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:flutter_challenge/ui/widgets/state_less_wrapper.dart';

import '../../../bloc/history/history_bloc.dart';
import '../../../bloc/history/history_event.dart';
import '../../../bloc/history/history_state.dart';
import '../../widgets/cards/history_task_item.dart';

class HistoryView extends StateLessWrapper {
  late HistoryBloc bloc;

  HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc = context.read<HistoryBloc>();
    bloc.add(InitEvent());
    return Scaffold(
      appBar: AppBar(
        title: _getSearchBar,
      ),
      body: _getList,
    );
  }

  Widget get _getSearchBar => BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, state) {
          return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.shade50,
                  ),
                  child: TextFormField(
                    // initialValue: state.taskName,
                    onFieldSubmitted: (v) async {
                      // onSubmitted!.call(v);
                    },
                    // onChanged: (v) => bloc.add(OnTaskNameChanged(v)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).primaryColor),
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.5)),
                        hintText: "Search"),
                  ),
                ),
              ));
        },
      );

  Widget get _getList => BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, state) {
          return ListView.builder(
            itemCount: state.historyList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = state.historyList[index];
              return HistoryItem(historyModel: item);
            },
          );
        },
      );
}
