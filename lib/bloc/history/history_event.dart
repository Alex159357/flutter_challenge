abstract class HistoryEvent {}

class InitEvent extends HistoryEvent {}

class OnSearchChanged extends HistoryEvent{
  final String searchQuery;

  OnSearchChanged(this.searchQuery);
}