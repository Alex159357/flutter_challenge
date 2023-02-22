import '../../../models/db_model.dart';

abstract class GeneralDb{
  Future<void> deleteTable();

  // Future<List<DbModel?>?> read();
}