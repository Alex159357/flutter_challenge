import 'package:flutter_challenge/models/task_model.dart';
import 'package:intl/intl.dart';

extension OnTaskModel on TaskModel {
  String get getSpentTime {
    Duration myDuration = Duration(milliseconds: spentTime);
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return "$hours : $minutes : $seconds";
  }
}
