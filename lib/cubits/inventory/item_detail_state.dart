part of 'item_detail_cubit.dart';

@immutable
abstract class ItemDetailState {}

class ItemDetailInitial extends ItemDetailState {}

// updated
class ItemDetailItemUpdated extends ItemDetailState {}

// edit
class ItemDetailEditItem extends ItemDetailState {}
