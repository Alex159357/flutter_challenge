import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/histary_model.dart';
import '../general_controller/general_db_controller.dart';
import 'history_controller.dart';

class HistoryDbImpl extends GeneralDbController<HistoryModel> implements HistoryDb{
  HistoryDbImpl() : super(key: "HISTORY_LIST");

  @override
  Future<void> deleteTable() async {
    delete();
  }

  @override
  Future<List<HistoryModel>?>? loadHistory() async{
    final list = await readList();
    if(list != null){
      return list.map((e) => e!).toList()..sort((a,b) => a.eventDateTime.compareTo(b.eventDateTime));
    }
    return null;
  }

  @override
  Future<List<HistoryModel>?> putHistory(HistoryModel historyModel) async{
    List<HistoryModel> list = await loadHistory() ?? [];
    list.add(historyModel);
    await writeOrUpdateList(list);
    return await loadHistory();
  }

}