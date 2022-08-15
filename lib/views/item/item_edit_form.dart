import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/scan/item_form_cubit.dart';
import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/utils.dart';
import "package:liquor_inventory/utils/string_extension.dart";
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
    TextEditingController fieldController, bool isRequired, onChange) {
  return TextFormField(
    onChanged: (v) => onChange(v),
    onFieldSubmitted: (v) => onChange(v),
    style: GoogleFonts.raleway(color: Colors.black),
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

class ItemEditForm extends StatefulWidget {
  final Item liquorItem;
  final BuildContext parentContext;
  final itemCats =
      UserModel.instance.inventory.categories.map((e) => e.name).toSet();

  ItemEditForm(
      {Key? key, required this.liquorItem, required this.parentContext})
      : super(key: key);

  @override
  _ItemEditFormState createState() => _ItemEditFormState();
}

class _ItemEditFormState extends State<ItemEditForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = " ";

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemAgeController = TextEditingController();
  TextEditingController itemVolumeController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDistilleryController = TextEditingController();
  TextEditingController itemLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    itemNameController =
        TextEditingController(text: widget.liquorItem.itemName);
    itemDistilleryController =
        TextEditingController(text: widget.liquorItem.distillery);
    itemLocationController =
        TextEditingController(text: widget.liquorItem.location);
    itemNameController =
        TextEditingController(text: widget.liquorItem.itemName);
    itemPriceController =
        TextEditingController(text: widget.liquorItem.price.toString());
    itemAgeController =
        TextEditingController(text: widget.liquorItem.age.toString());
    itemQuantityController =
        TextEditingController(text: widget.liquorItem.quantity.toString());
    itemVolumeController =
        TextEditingController(text: widget.liquorItem.size.toString());
  }

  @override
  Widget build(BuildContext context) {
    selectedCategory = widget.liquorItem.category;
    widget.itemCats.add('NA');

    // print("\n\n\nValues " +
    //     UserModel.instance.inventory.categories
    //         .map((e) => e.name)
    //         .toSet()
    //         .toString() +
    //     "\n\nselected: $selectedCategory");

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
            child: BlocConsumer<ItemFormCubit, ItemFormState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      pageHeader(context, "Edit Item"),
                      verticalSpacing(30.0),
                      _changeImage((v) {
                        BlocProvider.of<ItemFormCubit>(context)
                            .imageSelected(context, v, widget.liquorItem);
                      }),
                      Center(
                          child: Text(
                        "Upload New Image",
                        style: GoogleFonts.raleway(fontSize: 16),
                      )),
                      verticalSpacing(20),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            generalTextInputWrapper(
                                "Name", itemNameController, true, (v) {
                              widget.liquorItem.itemName = v;
                            }),
                            UserModel.instance.inventory.categories.isNotEmpty
                                ? _itemCategoryWidget((v) {
                                    selectedCategory = v.toString();
                                    setState(() {});
                                    widget.liquorItem.category = v;
                                  })
                                : const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _doubleField("Price", itemPriceController, (v) {
                                  widget.liquorItem.price = v;
                                }),
                                _integerField(
                                    "Quantity", itemQuantityController, (v) {
                                  widget.liquorItem.quantity = v;
                                }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _doubleField("Age", itemAgeController, (v) {
                                  widget.liquorItem.age = v;
                                }),
                                _doubleField("Volume", itemVolumeController,
                                    (v) {
                                  widget.liquorItem.size = v;
                                }),
                              ],
                            ),
                            generalTextInputWrapper(
                                "Distillery", itemDistilleryController, true,
                                (v) {
                              widget.liquorItem.distillery = v;
                            }),
                            generalTextInputWrapper(
                                "Location", itemLocationController, true, (v) {
                              widget.liquorItem.location = v;
                            }),
                            verticalSpacing(10),
                            primaryButton(context, () {
                              if (_formSubmission()) {
                                BlocProvider.of<ItemFormCubit>(context)
                                    .submitEditedItem(
                                        context,
                                        widget.parentContext,
                                        widget.liquorItem);
                                return true;
                              }
                              return false;
                            }, "Save Item Changes", double.infinity),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              listener: (context, state) {},
            )),
      ),
    );
  }

  bool _formSubmission() {
    if (_formKey.currentState == null) {
      return false;
    }
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Widget _changeImage(onChange) {
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
            child: Utils.gtImage(
                widget.liquorItem.picLoc, Utils.PLACEHOLDER_LIQOUR,
                width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
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
          Text(
            labelText,
            style: _formLabelStyle,
          ),
          TextFormField(
            onChanged: (v) => onChange(double.parse(v)),
            onFieldSubmitted: (v) => onChange(double.parse(v)),
            style: GoogleFonts.raleway(color: Colors.black),
            decoration: _formFieldStyle,
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

  Widget _integerField(
      String labelText, TextEditingController controller, onChange) {
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
            onChanged: (v) => onChange(int.parse(v)),
            onFieldSubmitted: (v) => onChange(int.parse(v)),
            style: GoogleFonts.raleway(color: Colors.black),
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
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _itemCategoryWidget(onChange) {
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
              value: selectedCategory,
              underline: Container(),
              isExpanded: true,
              onChanged: (v) => onChange(v.toString()),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Palette.lightGrey,
              ),
              items: widget.itemCats.map((String categoryName) {
                return DropdownMenuItem<String>(
                  value: categoryName,
                  child: Text(categoryName, style: GoogleFonts.raleway()),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
