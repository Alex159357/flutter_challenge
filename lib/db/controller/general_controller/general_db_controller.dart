import 'dart:convert';

import 'package:sembast/sembast.dart';

import '../../../helpers/mapper/db_mapper.dart';
import '../../../main.dart';
import '../../../models/db_model.dart';

class GeneralDbController<T extends DbModel> with DbMapper<T> {
  final _store = StoreRef.main();

  final String key;

  GeneralDbController({required this.key});

  Future<void> writeOrUpdate(DbModel val) async {
    try {
      await _store.record(key).add(database, val.toMap());
      print("DB_LOG -> Write ${val.toMap()}");
    } catch (e) {
      print("DB_LOG -> Write ERROR -> ${e.toString()}");
    }
  }

  Future<void> writeOrUpdateList(List<DbModel> list) async {
    try {
      if (await readList() != null) {
        await _store
            .record(key)
            .update(database, list.map((e) => e.toMap()).toList());
      } else {
        await _store
            .record(key)
            .put(database, list.map((e) => e.toMap()).toList());
      }
    } catch (e) {
      print("DB_LOG -> Write ERROR -> ${e.toString()}");
    }
  }

  Future<List<T?>?> readList() async {
    try {
      var records = await _store.record(key).get(database);
      print("DB_LOG -> READ -> ${records}");
      return fromMapList(records as List?);
    } catch (e) {
      print("DB_LOG -> Read ERROR $e");
    }
    return null;
  }

  void delete() async {
    await _store.record(key).delete(database);
  }

  void deleteAll() async {
    await _store.delete(database);
  }
}
