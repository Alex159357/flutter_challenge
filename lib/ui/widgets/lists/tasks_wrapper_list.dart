

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksWrapperList extends StatelessWidget {
  const TasksWrapperList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ReorderableListView(
        padding: EdgeInsets.only(bottom: 100),
        scrollDirection: Axis.horizontal,
        onReorder: _update,
        children: [
          for (int i = 0; i < 50; i++)
            Container(
              key: ValueKey(i),
              height: 100,
              width: 100,
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),
                  ]),
              child: Center(
                child: Text('Item $i'),
              ),
            ),
        ],
      ),
    );
  }

  // Widget get _columnList => BlocBuilder(builder: (BuildContext context, state) {
  //
  // },);

  void _update(int oldIndex, int newIndex) {}

}
