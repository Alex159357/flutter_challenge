import 'db_model.dart';

class HistoryModel implements DbModel {
  String eventName;
  String eventDescription;
  DateTime eventDateTime;

  HistoryModel(
      {required this.eventName,
      required this.eventDescription,
      required this.eventDateTime});

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
        eventName: map["event_name"],
        eventDescription: map["event_description"],
        eventDateTime:
            DateTime.fromMillisecondsSinceEpoch(map["event_date_time"]));
  }

  @override
  DbModel? fromMap(Map<String, dynamic> map) => HistoryModel.fromMap(map);

  @override
  Map<String, dynamic> toMap() => {
        "event_name": eventName,
        "event_description": eventDescription,
        "event_date_time": eventDateTime.millisecondsSinceEpoch
      };
}
