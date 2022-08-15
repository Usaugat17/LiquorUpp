part of 'item_form_cubit.dart';

@immutable
abstract class ItemFormState {}

/*---------------------------Add Form---------------------------*/
class ItemFormInitial extends ItemFormState {}

class ItemFormCatSelected extends ItemFormState {}

// image
class ItemFormSelectImage extends ItemFormState {}

class ItemFormImageSelected extends ItemFormState {}

class ItemFormImageUploaded extends ItemFormState {}

// submit
class ItemFromSubmit extends ItemFormState {}
