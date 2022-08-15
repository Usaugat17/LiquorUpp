import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/inventory/item_detail_cubit.dart';
import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/models/Inventory/inventory.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:meta/meta.dart';

part 'item_form_state.dart';

class ItemFormCubit extends Cubit<ItemFormState> {
  ItemFormCubit() : super(ItemFormInitial());

  void catSelect(BuildContext context, String cat) {
    emit(ItemFormCatSelected());
  }

  //image
  void selectImage(BuildContext context) {
    emit(ItemFormSelectImage());
  }

  void imageSelected(BuildContext context, String imagePath, Item item) {
    item.picLoc = imagePath;
    emit(ItemFormImageSelected());
    imageUpload(context, imagePath, item);
  }

  void imageUpload(BuildContext context, String photoLoc, Item item) {
    FirebaseUtils.uploadPhoto(
        photoLoc,
        StatusCallback(
          onSuccess: (v) {
            // print(v);
            item.picLoc = v;
            item.save();
            emit(ItemFormImageUploaded());
          },
          onFailure: (v) {
            // print(v);
            Utils.toast("Error Uploading Picture");
          },
        ));
  }

  //image
  void submitItem(BuildContext context, Item item) {
    // print(item.serialize());
    item.save();
    Navigator.popAndPushNamed(context, AppRouter.additemRoute, arguments: "");
  }

  void submitEditedItem(
      BuildContext context, BuildContext parentContext, Item item) {
    // print(item.serialize());
    item.save();
    BlocProvider.of<ItemDetailCubit>(parentContext).updateItem(context, item);
    Navigator.pop(context);
  }
}
