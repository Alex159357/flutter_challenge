

import 'package:flutter/material.dart';

abstract class StateLessWrapper extends StatelessWidget{
  const StateLessWrapper({super.key});


  Future<T?> dialogBuilder<T>({
    required BuildContext context,
    required Widget title,
    required Widget body,
    required Widget positiveBtn,
    required Widget negativeBtn
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: body,
          ),
          actions: <Widget>[
            positiveBtn,
            negativeBtn
          ],
        );
      },
    );
  }

}