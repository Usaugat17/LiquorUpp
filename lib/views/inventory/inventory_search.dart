import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:liquor_inventory/utils/utils.dart';

enum ParamType { string, number, bool }

enum ImageExists { yes, no }

class InventorySearch extends StatefulWidget {
  const InventorySearch({Key? key}) : super(key: key);

  @override
  _InnvetorySearchState createState() => _InnvetorySearchState();
}

class _InnvetorySearchState extends State<InventorySearch> {
  static final searchOptions = {
    Utils.NAME: ParamType.string,
    Utils.SIZE: ParamType.number,
    Utils.PRICE: ParamType.number,
    Utils.DISTILLERY: ParamType.string,
    Utils.LOCATION: ParamType.string,
    Utils.AGE: ParamType.number,
    Utils.QUANTITY: ParamType.number,
  };
  static final searchOptionsList = searchOptions.keys.toList();

  String selectedParameter = searchOptionsList[0];
  num arg1 = 0, arg2 = double.infinity;
  ParamType? selectedParamType = searchOptions.values.toList()[0];
  ImageExists? _sortingOrder = ImageExists.yes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Query",
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Palette.primaryRed,
            ),
          ),
          verticalSpacing(5),
          searchParameterSelector(),
          searchInputField(),
          verticalSpacing(5),
          primaryButton(context, () {}, "Search", double.infinity),
          verticalSpacing(5),
          hrDividerRed,
        ],
      ),
    );
  }

  Widget searchInputField() {
    switch (selectedParamType) {
      case ParamType.string:
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: stringSearchWidget(context),
        );
      case ParamType.bool:
        return imageSearchWidget();
      case ParamType.number:
        return numberSearchWidget(context);
      default:
        return stringSearchWidget(context);
    }
  }

  Widget integerField(onChange) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 40,
      width: MediaQuery.of(context).size.width / 3,
      child: TextFormField(
        onChanged: (v) => onChange(num.parse(v)),
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorStyle: TextStyle(color: Palette.accentedRed),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Palette.accentedRed),
          ),
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(12, 10, 0, 10),
        ),
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
    );
  }

  Widget numberSearchWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        integerField((v) {
          arg1 = v;

          BlocProvider.of<InventoryCubit>(context)
              .searchItem(context, selectedParameter, arg1: arg1, arg2: arg2);
        }),
        Text(
          "to",
          style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        integerField((v) {
          arg2 = v;
          BlocProvider.of<InventoryCubit>(context)
              .searchItem(context, selectedParameter, arg1: arg1, arg2: arg2);
        }),
      ],
    );
  }

  Widget stringSearchWidget(BuildContext context) {
    return TextFormField(
      onChanged: (v) {
        BlocProvider.of<InventoryCubit>(context)
            .searchItem(context, selectedParameter, arg1: v);
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Palette.accentedRed),
        ),
        errorStyle: TextStyle(color: Palette.accentedRed),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Palette.accentedRed),
        ),
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(12, 10, 0, 10),
      ),
    );
  }

  Widget imageSearchWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text(
              'With image',
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: Radio<ImageExists>(
              value: ImageExists.yes,
              groupValue: _sortingOrder,
              activeColor: Palette.primaryRed,
              onChanged: (ImageExists? value) {
                setState(() {
                  _sortingOrder = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              'No image',
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: Radio<ImageExists>(
              value: ImageExists.no,
              groupValue: _sortingOrder,
              activeColor: Palette.primaryRed,
              onChanged: (ImageExists? value) {
                setState(() {
                  _sortingOrder = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget searchParameterSelector() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Palette.lightGrey, width: 1.0),
      ),
      child: DropdownButton(
        value: selectedParameter,
        underline: Container(),
        isExpanded: true,
        style: GoogleFonts.raleway(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        onChanged: (selectedChoice) {
          setState(() {
            selectedParameter = selectedChoice.toString();
            selectedParamType = searchOptions[selectedChoice.toString()];
          });
        },
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Palette.lightGrey,
        ),
        items: searchOptionsList.map((String categoryName) {
          return DropdownMenuItem<String>(
            value: categoryName,
            child: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
