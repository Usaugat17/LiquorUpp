part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

// update
class HistorySalesUpdated extends HistoryState {}

class HistoryAdditionsUpdated extends HistoryState {}

// insight
class HistoryInsightCarousalChange extends HistoryState {
  int index;
  HistoryInsightCarousalChange(this.index);
}

class HistoryInsightUpdated extends HistoryState {
  Insights insights;
  HistoryInsightUpdated(this.insights);
}

// date selector
class HistoryDateSelectorUpdated extends HistoryState {}

class HistoryDateSelected extends HistoryState {}
