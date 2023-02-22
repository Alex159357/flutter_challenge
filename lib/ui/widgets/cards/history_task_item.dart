

import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/task_model.dart';
import 'package:intl/intl.dart';

import '../../../models/histary_model.dart';
import '../state_less_wrapper.dart';

class HistoryItem extends StateLessWrapper {
  final HistoryModel historyModel;
  const HistoryItem({Key? key, required this.historyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(historyModel.eventDateTime)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(historyModel.eventName, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(historyModel.eventDescription))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Time"),
                  Text(DateFormat('HH:mm').format(historyModel.eventDateTime))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
