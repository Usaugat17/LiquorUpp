import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddCategory extends StatefulWidget {
  AddCategory({Key? key}) : super(key: key);
  Category cat = Category();

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Category Name",
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Palette.primaryRed,
            ),
          ),
          verticalSpacing(5),
          BlocConsumer<InventoryCubit, InventoryState>(
            builder: (context, state) {
              return stringSearchWidget();
            },
            listener: (context, state) {},
          ),
          verticalSpacing(10),
          primaryButton(context, () {
            BlocProvider.of<InventoryCubit>(context)
                .addCat(context, widget.cat);
          }, "Add Category", double.infinity),
          verticalSpacing(5),
          hrDividerRed,
        ],
      ),
    );
  }

  Widget stringSearchWidget() {
    return TextFormField(
      onChanged: (v) {
        widget.cat.name = v;
      },
      onFieldSubmitted: (v) {
        widget.cat.name = v;
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
}
