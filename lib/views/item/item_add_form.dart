import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/scan/item_form_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:liquor_inventory/utils/widgets.dart';

final _formLabelStyle = GoogleFonts.readexPro(
  fontWeight: FontWeight.w500,
  color: Palette.primaryRed,
  fontSize: 16.0,
);

const _formFieldStyle = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  errorStyle: TextStyle(color: Palette.accentedRed),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Palette.accentedRed),
  ),
  contentPadding: EdgeInsets.fromLTRB(12, 2, 0, 2),
);

Widget generalTextInputWrapper(String label,
    TextEditingController fieldController, bool isRequired, onChange) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
          child: Text(
            label,
            style: _formLabelStyle,
            textAlign: TextAlign.left,
          ),
        ),
        _generalTextFormInput(fieldController, isRequired, onChange)
      ],
    ),
  );
}

Widget _generalTextFormInput(
  TextEditingController fieldController,
  bool isRequired,
  onChange,
) {
  return TextFormField(
    onChanged: (v) => onChange(v),
    // onFieldSubmitted: (v) => onChange(v),
    style: const TextStyle(color: Colors.black),
    decoration: _formFieldStyle,
    validator: (value) {
      if (value == null || value.isEmpty && isRequired) {
        return 'This field is required!';
      }
      return null;
    },
    controller: fieldController,
  );
}

class ItemAddForm extends StatefulWidget {
  final String barCodeScanValue;
  final Item item = Item();
  ItemAddForm({Key? key, required this.barCodeScanValue}) : super(key: key) {
    item.itemCode = barCodeScanValue == Utils.NOT_AVAILABLE
        ? Utils.genCrpytoKey(length: 12)
        : barCodeScanValue;
  }

  @override
  _ItemAddFormState createState() => _ItemAddFormState();
}

class _ItemAddFormState extends State<ItemAddForm> {
  final _formKey = GlobalKey<FormState>();

  final itemCats =
      UserModel.instance.inventory.categories.map((e) => e.name).toSet();
  String selectedCategory = "";

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemAgeController = TextEditingController();
  TextEditingController itemVolumeController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDistilleryController = TextEditingController();
  TextEditingController itemLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Widgets.backButton(context),
          actions: [const SizedBox(width: 20)],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocConsumer<ItemFormCubit, ItemFormState>(
                builder: (context, state) {
                  if (state is ItemFormImageSelected) {
                    return buildForm(context, local: true);
                  } else if (state is ItemFormImageUploaded) {
                    return buildForm(context, remote: true);
                  }
                  return buildForm(context);
                },
                listener: (context, state) {},
              )),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context, {remote: false, local: false}) {
    if (itemCats.isNotEmpty) {
      widget.item.category = itemCats.toList()[0];
    }
    return ListView(
      children: [
        pageHeader(context, "Add Item Details"),
        verticalSpacing(20.0),
        _uploadImage((v) {
          BlocProvider.of<ItemFormCubit>(context)
              .imageSelected(context, v, widget.item);
        }, remote: remote, local: local),
        itemCodeWidget(widget.item.itemCode, (v) {
          widget.item.itemCode = v;
        }),
        generalTextInputWrapper("Name:", itemNameController, true, (v) {
          widget.item.itemName = v;
          print('This is name ${widget.item.itemName}');
        }),
        UserModel.instance.inventory.categories.isNotEmpty
            ? _itemCategoryWidget((v) {
                widget.item.category = v;
                BlocProvider.of<ItemFormCubit>(context).catSelect(context, v);
              })
            : const SizedBox(height: 0),
        _doubleField("Price:", itemPriceController, (v) {
          widget.item.price = v;
        }),
        _integerField("Quantity:", (v) {
          widget.item.quantity = v;
        }),
        _doubleField("Volume:", itemVolumeController, (v) {
          widget.item.size = v;
        }),
        _doubleField("Age:", itemAgeController, (v) {
          widget.item.age = v;
        }),
        generalTextInputWrapper("Distillery:", itemDistilleryController, true,
            (v) {
          widget.item.distillery = v;
        }),
        generalTextInputWrapper("Location:", itemLocationController, true, (v) {
          widget.item.location = v;
          // print("Called");
        }),
        primaryButton(
            context, () => _formSubmission(widget.item), "Add Item", 100.0),
      ],
    );
  }

  bool _formSubmission(item) {
    if (_formKey.currentState == null) {
      return false;
    }
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ItemFormCubit>(context).submitItem(context, item);
      return true;
    }
    return false;
  }

  Widget _uploadImage(onChange, {remote = false, local = false}) {
    return GestureDetector(
      onTap: () {
        Utils.imagePicker(context, onChange);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * .45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: remote
                ? Utils.gtImage(widget.item.picLoc, Utils.PLACEHOLDER_ADDIMAGE,
                    fit: BoxFit.cover, fitOr: BoxFit.scaleDown)
                : local
                    ? Image.file(File(widget.item.picLoc), fit: BoxFit.cover)
                    : Image.asset(
                        Utils.PLACEHOLDER_ADDIMAGE,
                        fit: BoxFit.scaleDown,
                        height: 100,
                      ),
          ),
        ),
      ),
    );
  }

  Widget _doubleField(
      String labelText, TextEditingController controller, onChange) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            child: Text(
              labelText,
              style: _formLabelStyle,
            ),
          ),
          TextFormField(
            // onFieldSubmitted: (v) => onChange(double.parse(v)),
            style: const TextStyle(color: Colors.black),
            decoration: _formFieldStyle,
            onChanged: (value) {
              onChange(double.parse(value));
            },
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[-+*,]')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field is required!";
              }

              return null;
            },
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _integerField(String labelText, onChange) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: _formLabelStyle,
          ),
          TextFormField(
            // onFieldSubmitted: (v) => onChange(int.parse(v)),
            onChanged: (v) => onChange(int.parse(v)),
            style: const TextStyle(color: Colors.black),
            decoration: _formFieldStyle,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[-+*,.]')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              if (int.parse(value) == 0) {
                return 'Can not enter 0 as quantity!';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _itemCategoryWidget(onChange) {
    print(itemCats);
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            child: Text(
              "Item Category",
              style: _formLabelStyle,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Palette.lightGrey, width: 1.0),
            ),
            child: DropdownButton(
              value: itemCats.toList()[0],
              underline: Container(),
              isExpanded: true,
              onChanged: (selectedChoice) {
                onChange(selectedChoice.toString());
                setState(() {
                  selectedCategory = selectedChoice.toString();
                });
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Palette.lightGrey,
              ),
              items: itemCats.map((String cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget itemCodeWidget(String barCode, onChange) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "Item Code:",
              style: _formLabelStyle,
            ),
          ),
          TextFormField(
            onFieldSubmitted: (v) => onChange(v),
            style: const TextStyle(color: Palette.lightGrey),
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorStyle: TextStyle(color: Palette.accentedRed),
            ),
            enabled: false,
            initialValue: barCode == "" ? "-" : barCode,
          ),
        ],
      ),
    );
  }
}
