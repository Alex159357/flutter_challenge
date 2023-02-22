
import 'package:flutter_challenge/models/histary_model.dart';

import '../general_controller/general_db.dart';

abstract class HistoryDb implements GeneralDb{

  Future<List<HistoryModel>?>? loadHistory();

  Future<List<HistoryModel>?>? putHistory(HistoryModel historyModel);

}