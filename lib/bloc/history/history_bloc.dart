import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_challenge/models/histary_model.dart';
import 'package:flutter_challenge/models/task_column_model.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../db/controller/history_controller/HistoryDbImpl.dart';
import '../../db/controller/history_controller/history_controller.dart';
import '../../db/controller/task_db/task_column_db_controller.dart';
import '../../db/controller/task_db/task_column_db_controller_impl.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryDb _historyDb = HistoryDbImpl();

  HistoryBloc() : super(HistoryState().init()) {
    on<InitEvent>(_init);
    on<OnSearchChanged>(_onSearchChanged);
  }

  void _init(InitEvent event, Emitter<HistoryState> emit) async {
    List<HistoryModel>? tasksList = await _historyDb.loadHistory();
    emit(state.clone(historyList: tasksList ?? []));
  }

  FutureOr<void> _onSearchChanged(OnSearchChanged event,
      Emitter<HistoryState> emit) {
    List<HistoryModel> tasksList = state.historyList;
    tasksList.where((element) {
      return element.eventName.contains(event.searchQuery) ||
          element.eventDescription.contains(event.searchQuery);
    }).toList();

    emit(state.clone(historyList: tasksList));
  }
}
