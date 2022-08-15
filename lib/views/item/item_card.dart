import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/string_extension.dart';
import 'package:liquor_inventory/utils/utils.dart';

class LiquorItemCard extends StatelessWidget {
  final Item liquorItem;
  const LiquorItemCard({Key? key, required this.liquorItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.20;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRouter.itemRoute, arguments: [liquorItem, context]);
      },
      child: BlocConsumer<InventoryCubit, InventoryState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: cardHeight,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.primaryRed, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage("assets/images/card-bg-1.png"),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                imageSection(cardHeight),
                itemDescriptionSection(context, cardHeight),
              ],
            ),
          );
        },
        listener: (c, s) {},
      ),
    );
  }

  Widget imageSection(double cardHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      ),
      child: Hero(
          tag: liquorItem.itemCode + liquorItem.itemName,
          child: Utils.gtImage(liquorItem.picLoc, Utils.PLACEHOLDER_LIQOUR,
              height: cardHeight, width: 150, fit: BoxFit.cover)),
    );
  }

  Widget itemDescriptionSection(BuildContext context, double cardHeight) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    liquorItem.itemName.capitalize(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<InventoryCubit>(context)
                          .deleteItem(context, liquorItem);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Qty: " +
                  liquorItem.quantity.toString() +
                  " | \$" +
                  liquorItem.price.toString() +
                  " | " +
                  liquorItem.category,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            liquorItem.sold
                ? GestureDetector(
                    onTap: () {
                      BlocProvider.of<InventoryCubit>(context)
                          .soldDetail(context, liquorItem);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<InventoryCubit>(context)
                                  .soldDetail(context, liquorItem);
                            },
                            icon: const Icon(
                              Icons.sell,
                              color: Palette.darkRed,
                            )),
                        Text(
                          "sold",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            color: Palette.darkRed,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
