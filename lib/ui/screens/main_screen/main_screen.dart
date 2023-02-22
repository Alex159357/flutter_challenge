import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/bloc/main_navigation/main_navigation_state.dart';
import 'package:flutter_challenge/bloc/task_bloc/task_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/main_navigation/main_navigation_cubit.dart';
import '../../../bloc/task_bloc/single_task_state.dart';
import '../../../bloc/task_bloc/task_bloc_event.dart';
import '../../../bloc/task_bloc/task_bloc_state.dart';
import '../../../helpers/constains/values.dart';
import '../../../helpers/create_screen_type.dart';
import '../../../helpers/timer_controller.dart';
import '../../views/task/task_sheet/task_view_list.dart';
import '../../widgets/bottom_app_bar_item.dart';
import '../create_screen/create_screen.dart';
import '../history_screen/history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainNavigationCubit _navCubit;
  final TimerController _timerController = TimerController();

  @override
  Widget build(BuildContext context) {
    _navCubit = context.read<MainNavigationCubit>();
    return Scaffold(
      body: _getBody,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _getBottomNavBar,
    );
  }

  Widget get _getBottomNavBar =>
      BlocBuilder<MainNavigationCubit, MainNavigationState>(
        builder: (BuildContext context, state) {
          BottomAppBarItem item = BottomAppBarItem();
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              margin: EdgeInsets.all(0),
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
                  // item.getItem(
                  //     icon: const Icon(Icons.account_circle),
                  //     caption: 'Profile',
                  //     onPress: () => _navCubit.navigateToProfile(),
                  //     isActive: state is MainScreenProfile),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: OpenContainer(
                        transitionDuration: const Duration(
                            milliseconds: animationDuration),
                        transitionType: ContainerTransitionType.fade,
                        openBuilder: (BuildContext context, VoidCallback _) {
                          return const CreateScreen();
                        },
                        closedElevation: 6.0,
                        closedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        onClosed: (v) {
                          context.read<TaskBloc>().add(InitTaskEvent());
                        },
                        closedBuilder: (BuildContext context,
                            VoidCallback openContainer) {
                          return InkWell(
                            onTap: openContainer,
                            child: Container(
                              color: Colors.deepPurple.shade100.withOpacity(.8),
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.add),
                              ),
                            ),
                          );
                        },
                      )
                  )
                ],
              ),
            ),
          );
        },
      );

  Widget get _getBody =>
      BlocBuilder<MainNavigationCubit, MainNavigationState>(
          builder: (BuildContext context, state) {
            return PageTransitionSwitcher(
              duration: const Duration(milliseconds: animationDuration),
              transitionBuilder: (Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,) {
                return FadeThroughTransition(
                  fillColor: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
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
        return const HistoryScreen();
      case MainScreenProfile:
        return Container(
          color: Colors.amberAccent,
        );
      default:
        return Container();
    }
  }


}
