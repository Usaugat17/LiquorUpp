import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ItemAdditionalDetailPanel extends StatefulWidget {
  final ScrollController controller;
  final Item liquorItem;
  final PanelController panelController;

  const ItemAdditionalDetailPanel(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.liquorItem})
      : super(key: key);

  @override
  _ItemAdditionDetailPanelState createState() =>
      _ItemAdditionDetailPanelState();
}

class _ItemAdditionDetailPanelState extends State<ItemAdditionalDetailPanel> {
  @override
  Widget build(BuildContext context) {
    return itemDetails();
  }

  Widget _singleDetail(String itemDetailName, String itemDetailValue,
      {TextAlign align = TextAlign.left}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemDetailName,
            textAlign: align,
            style: GoogleFonts.readexPro(
              fontSize: MediaQuery.of(context).size.width * 0.055,
              color: Colors.black,
              fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _rowItemDetail(String itemDetailName, String itemDetailValue,
      {TextAlign align = TextAlign.left}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemDetailName,
          textAlign: align,
          style: GoogleFonts.readexPro(
            fontSize: MediaQuery.of(context).size.width * 0.055,
            color: Colors.black,
            fontWeight: FontWeight.w500,
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

  Widget _buildDragHandle() {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onTap: () {
        widget.panelController.isPanelOpen
            ? widget.panelController.close()
            : widget.panelController.open();
      },
    );
  }

  Widget itemDetails() {
    return ListView(
      controller: widget.controller,
      children: [
        verticalSpacing(10),
        _buildDragHandle(),
        verticalSpacing(5),
        Center(
          child: Text(
            "Item Details",
            style: GoogleFonts.readexPro(
              color: Palette.primaryRed,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacing(30),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item Bar Code",
                      style: GoogleFonts.readexPro(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.liquorItem.itemCode == ""
                          ? "-"
                          : widget.liquorItem.itemCode,
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Palette.primaryRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _rowItemDetail(
                    "Size",
                    widget.liquorItem.size.toString() + "ml",
                  ),
                  _rowItemDetail(
                    "Price",
                    "\$" + widget.liquorItem.price.toString(),
                    align: TextAlign.right,
                  ),
                  _rowItemDetail(
                    "Age",
                    widget.liquorItem.age.toString() + 'yrs',
                  ),
                ],
              ),
              verticalSpacing(10),
              hrDividerRed,
              verticalSpacing(10),
              _singleDetail(
                "Category",
                widget.liquorItem.category,
              ),
              _singleDetail(
                "Distillery",
                widget.liquorItem.distillery,
              ),
              _singleDetail(
                "Location",
                widget.liquorItem.location,
              ),
              verticalSpacing(10),
            ],
          ),
        ),
      ],
    );
  }
}
