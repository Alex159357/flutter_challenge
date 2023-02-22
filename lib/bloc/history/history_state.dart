import 'package:flutter_challenge/models/task_model.dart';

import '../../models/histary_model.dart';

class HistoryState {

  final List<HistoryModel> historyList;


  HistoryState({
    this.historyList = const [],
  });

  HistoryState init() {
    return HistoryState();
  }

  HistoryState clone({List<HistoryModel>? historyList}) => HistoryState(
    historyList: historyList ?? this.historyList
  );
}
