import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/ui/screens/main_screen/main_screen.dart';

import 'bloc/main_navigation/main_navigation_cubit.dart';
import 'bloc/task_bloc/task_bloc_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainNavigationCubit>(
          create: (BuildContext context) => MainNavigationCubit(),
        ),
        BlocProvider<TaskBlocBloc>(
          create: (BuildContext context) => TaskBlocBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
//
// class HomePage extends StatelessWidget {
//   final List<int> _items = List<int>.generate(50, (int index) => index);
//
//   HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ConstrainedBox(
//       constraints: const BoxConstraints(
//         maxHeight: 250,
//       ),
//       child: ReorderableListView(
//         padding: EdgeInsets.only(bottom: 100),
//         scrollDirection: Axis.horizontal,
//         onReorder: _update,
//         children: [
//           for (int i = 0; i < 50; i++)
//             Container(
//               key: ValueKey(i),
//               height: 100,
//               width: 100,
//               margin: EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                   color: Colors.blueGrey,
//                   border: Border.all(
//                     color: Colors.black,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black,
//                       blurRadius: 4,
//                     ),
//                   ]),
//               child: Center(
//                 child: Text('Item $i'),
//               ),
//             ),
//         ],
//       ),
//     ));
//   }
//
//
// }
