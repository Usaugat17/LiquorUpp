part of 'inventory_cubit.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

// data updation
class InventoryItemsUpdated extends InventoryState {}

class InventoryCategoryUpdated extends InventoryState {}

// sort
class InventoryItemSort extends InventoryState {}

class InventorySortPatameterSelected extends InventoryState {}

class InventorySortAscending extends InventoryState {}

class InventorySortDecending extends InventoryState {}

// search
class InventoryItemSearch extends InventoryState {}

// add category
class InvetoryItemAddCategory extends InventoryState {}

class InvetoryItemCategoryAdded extends InventoryState {}

// page
class InventoryPageItems extends InventoryState {}

class InventoryPageCategories extends InventoryState {}

// addItemToggle

class InventoryExpandableToggle extends InventoryState {
  bool toggle;
  InventoryExpandableToggle(this.toggle);
}
