import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/inventory/item_detail_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:liquor_inventory/utils/widgets.dart';
import 'package:liquor_inventory/views/item/item_detail_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import "package:liquor_inventory/utils/string_extension.dart";

class ItemDetailPage extends StatefulWidget {
  final Item liquorItem;
  final BuildContext parentContext;

  const ItemDetailPage(
      {Key? key, required this.liquorItem, required this.parentContext})
      : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final panelController = PanelController();

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
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: MediaQuery.of(context).size.height * 0.1,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          body: BlocConsumer<ItemDetailCubit, ItemDetailState>(
            builder: (context, state) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  _topHeader(),
                  _itemImage(),
                  verticalSpacing(10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        horizontalSpacing(30),
                        _actionButton(Icons.add, () {
                          BlocProvider.of<ItemDetailCubit>(context)
                              .addQuantity(context, widget.liquorItem);
                        }),
                        _rowItemDetail(
                          "Quantity",
                          widget.liquorItem.quantity.toString(),
                          align: TextAlign.center,
                        ),
                        _actionButton(Icons.remove, () {
                          BlocProvider.of<ItemDetailCubit>(context)
                              .subQuantity(context, widget.liquorItem);
                        }),
                        horizontalSpacing(30),
                      ],
                    ),
                  )
                ],
              );
            },
            listener: (c, s) {},
          ),
          panelBuilder: (controller) => ItemAdditionalDetailPanel(
            controller: controller,
            panelController: panelController,
            liquorItem: widget.liquorItem,
          ),
        ),
      ),
    );
  }

  Widget _topHeader() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _itemTitle(),
          Padding(
              padding: const EdgeInsets.all(3),
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  BlocProvider.of<ItemDetailCubit>(context)
                      .editItem(context, widget.liquorItem);
                },
                iconSize: 32,
                color: Palette.primaryRed,
              )),
          Padding(
              padding: const EdgeInsets.all(3),
              child: IconButton(
                icon: widget.liquorItem.sold
                    ? const Icon(Icons.sell)
                    : const Icon(Icons.sell_outlined),
                onPressed: () {
                  BlocProvider.of<ItemDetailCubit>(context)
                      .itemSold(context, widget.liquorItem);
                },
                iconSize: 32,
                color: Palette.primaryRed,
              )),
          Padding(
              padding: const EdgeInsets.all(3),
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  BlocProvider.of<ItemDetailCubit>(context).deleteItem(
                      context, widget.parentContext, widget.liquorItem);
                },
                iconSize: 32,
                color: Palette.primaryRed,
              )),
        ],
      ),
    );
  }

  Widget _itemTitle() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        widget.liquorItem.itemName.capitalize(),
        style: GoogleFonts.readexPro(
          color: Palette.primaryRed,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  Widget _itemImage() {
    return Card(
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
    );
  }

  Widget _rowItemDetail(String itemDetailName, String itemDetailValue,
      {TextAlign align = TextAlign.left}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          itemDetailName,
          textAlign: align,
          style: GoogleFonts.raleway(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          itemDetailValue,
          textAlign: align,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Palette.primaryRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _saveOrCancelBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "|",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Cancel",
              style: GoogleFonts.raleway(
                color: Palette.primaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData buttonIcon, Function onPress) {
    return IconButton(
      onPressed: () {
        onPress();
      },
      iconSize: 40,
      icon: Icon(buttonIcon),
      color: Palette.primaryRed,
    );
  }
}
