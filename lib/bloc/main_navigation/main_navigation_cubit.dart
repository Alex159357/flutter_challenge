import 'package:bloc/bloc.dart';

import 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit() : super(MainScreenMainView());

  void navigateToMainView() => emit(MainScreenMainView());

  void navigateToHistory() => emit(MainScreenHistory());

  void navigateToProfile() => emit(MainScreenProfile());
}
