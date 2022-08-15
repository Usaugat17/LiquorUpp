import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:liquor_inventory/models/History/history.dart';
import 'package:liquor_inventory/models/Base/Transaction.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:intl/intl.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

// updated
  void salesUpdated(BuildContext context) {
    emit(HistorySalesUpdated());
  }

  void additionUpdated(BuildContext context) {
    emit(HistoryAdditionsUpdated());
  }

// insights
  void carousalAction(BuildContext context, int index) {
    emit(HistoryInsightCarousalChange(index));
  }

  void updateInsigts(BuildContext context, Insights insights) {
    emit(HistoryInsightUpdated(insights));
  }

  // date select
  void selectedDateUpdated(BuildContext context) {
    emit(HistoryDateSelectorUpdated());
  }

  void dateUpdated(BuildContext context) {
    emit(HistoryDateSelected());
  }

  //edit

  void editDateTime(BuildContext context, Transaction tx, DateTime date) {
    tx.date = DateFormat(Utils.TIME_STAMP_FORMAT).format(date);
    tx.save();
    emit(HistoryInitial());
  }
}
