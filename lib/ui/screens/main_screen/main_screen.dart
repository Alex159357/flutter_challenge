import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/bloc/main_navigation/main_navigation_state.dart';

import '../../../bloc/main_navigation/main_navigation_cubit.dart';
import '../../views/task_view_list.dart';
import '../../widgets/bottom_app_bar_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainNavigationCubit _navCubit;

  @override
  Widget build(BuildContext context) {
    _navCubit = context.read<MainNavigationCubit>();
    return Scaffold(
      body: _getBody,
      bottomNavigationBar: _getBottomNavBar,
    );
  }

  Widget get _getBottomNavBar =>
      BlocBuilder<MainNavigationCubit, MainNavigationState>(
        builder: (BuildContext context, state) {
          BottomAppBarItem item = BottomAppBarItem();
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  item.getItem(
                      icon: const Icon(Icons.table_chart),
                      caption: 'Tasks',
                      onPress: () => _navCubit.navigateToMainView(),
                      isActive: state is MainScreenMainView),
                  item.getItem(
                      icon: const Icon(Icons.history),
                      caption: 'History',
                      onPress: () => _navCubit.navigateToHistory(),
                      isActive: state is MainScreenHistory),
                  item.getItem(
                      icon: const Icon(Icons.account_circle),
                      caption: 'Profile',
                      onPress: () => _navCubit.navigateToProfile(),
                      isActive: state is MainScreenProfile),
                ],
              ),
            ),
          );
        },
      );

  Widget get _getBody => BlocBuilder<MainNavigationCubit, MainNavigationState>(
          builder: (BuildContext context, state) {
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _getPage(state),
        );
      });

  _getPage(MainNavigationState state) {
    switch (state.runtimeType) {
      case MainScreenMainView:
        return TaskView();
      case MainScreenHistory:
        return Container(
          color: Colors.green,
        );
      case MainScreenProfile:
        return Container(
          color: Colors.amberAccent,
        );
      default:
        return Container();
    }
  }


}
