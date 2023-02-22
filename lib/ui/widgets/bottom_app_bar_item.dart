

import 'package:flutter/material.dart';

import '../../helpers/constains/values.dart';

class BottomAppBarItem{

  Widget getItem(
      {required Widget icon,
        required String caption,
        required bool isActive,
        required VoidCallback onPress}) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onPress,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: animationDuration),
        opacity: isActive? 1: .5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [icon, Text(caption)],
          ),
        ),
      ),
    );
  }

}