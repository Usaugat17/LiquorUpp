import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/utils.dart';

enum SortOrder { ascending, descending }

class InventorySort extends StatefulWidget {
  const InventorySort({Key? key}) : super(key: key);

  @override
  _InvetorySortState createState() => _InvetorySortState();
}

class _InvetorySortState extends State<InventorySort> {
  static final sortOptions = [
    Utils.NAME,
    Utils.SIZE,
    Utils.PRICE,
    Utils.DISTILLERY,
    Utils.LOCATION,
    Utils.AGE,
    Utils.QUANTITY,
  ];
  String _selectedParameter = sortOptions[0];
  SortOrder? _sortingOrder = SortOrder.ascending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort By",
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Palette.primaryRed,
            ),
          ),
          verticalSpacing(5),
          sortParameterSelector(),
          orderSelector(),
          primaryButton(context, () {}, "Sort", double.infinity),
          verticalSpacing(5),
          hrDividerRed,
        ],
      ),
    );
  }

  Widget orderSelector() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text(
              'Ascending',
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: Radio<SortOrder>(
              value: SortOrder.ascending,
              groupValue: _sortingOrder,
              activeColor: Palette.primaryRed,
              onChanged: (SortOrder? value) {
                setState(() {
                  _sortingOrder = value;
                  BlocProvider.of<InventoryCubit>(context)
                      .sortAccend(context, _selectedParameter.toString());
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              'Descending',
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            leading: Radio<SortOrder>(
              value: SortOrder.descending,
              groupValue: _sortingOrder,
              activeColor: Palette.primaryRed,
              onChanged: (SortOrder? value) {
                setState(() {
                  _sortingOrder = value;
                  BlocProvider.of<InventoryCubit>(context)
                      .sortDescend(context, _selectedParameter.toString());
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget sortParameterSelector() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Palette.lightGrey, width: 1.0),
      ),
      child: DropdownButton(
        value: _selectedParameter,
        underline: Container(),
        isExpanded: true,
        style: GoogleFonts.raleway(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        onChanged: (selectedChoice) {
          _selectedParameter = selectedChoice.toString();
          BlocProvider.of<InventoryCubit>(context)
              .sortBy(context, selectedChoice.toString());
        },
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Palette.lightGrey,
        ),
        items: sortOptions.map((String categoryName) {
          return DropdownMenuItem<String>(
            value: categoryName,
            child: Text(categoryName),
          );
        }).toList(),
      ),
    );
  }
}
