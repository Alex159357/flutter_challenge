

import 'package:flutter/material.dart';

class BottomAppBarItem{

  Widget getItem(
      {required Widget icon,
        required String caption,
        required bool isActive,
        required VoidCallback onPress}) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [icon, Text(caption)],
        ),
      ),
    );
  }

}