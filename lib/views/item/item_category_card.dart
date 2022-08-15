import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/string_extension.dart';

class ItemCategoryCard extends StatelessWidget {
  final Category category;
  const ItemCategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.12;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.primaryRed),
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage("assets/images/category-card-bg.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: itemDescriptionSection(context),
    );
  }

  Widget itemDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              category.name.capitalize(),
              style: GoogleFonts.readexPro(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<InventoryCubit>(context)
                          .editCategory(context, category);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<InventoryCubit>(context)
                            .deleteCat(context, category);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      )),
                ]),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Unique Items: ${category.uniqueItems.abs()}",
          style: GoogleFonts.raleway(
              fontSize: 16,
              color: Colors.grey[100],
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          "Total Items: ${category.totalItems.abs()}",
          style: GoogleFonts.raleway(
              fontSize: 16,
              color: Colors.grey[100],
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
