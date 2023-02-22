import 'details_screen_state.dart';

class TaskDetailState {

  final DetailsScreenState detailsScreenState;
  final int selectedColumnId;


  TaskDetailState({this.detailsScreenState = const InitialDetailsScreenState(), this.selectedColumnId = -1});

  TaskDetailState init() {
    return TaskDetailState();
  }

  TaskDetailState clone({DetailsScreenState? detailsScreenState, int? selectedColumnId})=> TaskDetailState(
    detailsScreenState: detailsScreenState ?? this.detailsScreenState,
      selectedColumnId: selectedColumnId ?? this.selectedColumnId
  );
}
