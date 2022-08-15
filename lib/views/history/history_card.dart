import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/models/Base/Transaction.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/string_extension.dart';
import 'package:intl/intl.dart';
import 'package:liquor_inventory/utils/utils.dart';

class ItemHistoryCard extends StatelessWidget {
  final Transaction tx;
  final isItemSold;

  const ItemHistoryCard({
    Key? key,
    required this.tx,
    required this.isItemSold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.12;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: cardHeight,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Palette.primaryRed),
          borderRadius: BorderRadius.circular(10),
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
            itemDescriptionSection(context),
          ],
        ),
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
          tag: tx.item.itemCode + tx.item.itemName,
          child: Utils.gtImage(tx.item.picLoc, Utils.PLACEHOLDER_LIQOUR,
              height: cardHeight, width: 150, fit: BoxFit.cover)),
    );
  }

  Widget itemDescriptionSection(BuildContext context) {
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
                    tx.item.itemName.capitalize(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        // minTime: DateTime(2018, 3, 5),
                        maxTime: DateTime.now(), onChanged: (date) {
                      print('change $date');
                      // BlocProvider.of<HistoryCubit>(context)
                      //     .editDateTime(context, tx, date);
                    }, onConfirm: (date) {
                      BlocProvider.of<HistoryCubit>(context)
                          .editDateTime(context, tx, date);
                    },
                        currentTime:
                            DateFormat(Utils.TIME_STAMP_FORMAT).parse(tx.date),
                        locale: LocaleType.en,
                        theme: const DatePickerTheme(
                            doneStyle: TextStyle(color: Palette.primaryRed)));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              isItemSold
                  ? "Quantity Sold: " + tx.quantity.toString()
                  : "Quantity Added: " + tx.quantity.toString(),
              style: GoogleFonts.raleway(color: Colors.white, fontSize: 14.0),
            ),
            Text(
              tx.date,
              style: GoogleFonts.raleway(color: Colors.white, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
