import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/common.dart';

class DateSelector extends StatefulWidget {
  final parentContext;
  final controller;
  const DateSelector(this.parentContext, this.controller, {Key? key})
      : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  static List<String> months = [
    "All",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  static List<String> years = [
    "2022",
    "2021",
    "2020",
  ];
  final history = UserModel.instance.history;
  String _selectedMonth = months[0];
  String _selectedYear = years[0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Month and Year in History",
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Palette.primaryRed,
            ),
          ),
          verticalSpacing(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              monthSelector(),
              yearSelector(),
            ],
          ),
          verticalSpacing(10),
          primaryButton(context, () {
            widget.controller.animateToStart();
            BlocProvider.of<HistoryCubit>(widget.parentContext)
                .dateUpdated(widget.parentContext);
          }, "Set Date", double.infinity),
          verticalSpacing(5),
          hrDividerRed,
        ],
      ),
    );
  }

  Widget monthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Month",
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        verticalSpacing(5),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 40,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Palette.lightGrey, width: 1.0),
          ),
          child: DropdownButton(
            value: months[history.month],
            underline: Container(),
            isExpanded: true,
            style: GoogleFonts.raleway(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
            onChanged: (month) {
              history.month = months.indexOf(month.toString());
              BlocProvider.of<HistoryCubit>(widget.parentContext)
                  .selectedDateUpdated(widget.parentContext);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Palette.lightGrey,
            ),
            items: months.map((String categoryName) {
              return DropdownMenuItem<String>(
                value: categoryName,
                child: Text(categoryName),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget yearSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Year",
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        verticalSpacing(5),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 40,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Palette.lightGrey, width: 1.0),
          ),
          child: DropdownButton(
            value: history.year.toString(),
            underline: Container(),
            isExpanded: true,
            style: GoogleFonts.raleway(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
            onChanged: (year) {
              history.year = int.parse(year.toString());
              BlocProvider.of<HistoryCubit>(widget.parentContext)
                  .selectedDateUpdated(widget.parentContext);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Palette.lightGrey,
            ),
            items: years.map((String categoryName) {
              return DropdownMenuItem<String>(
                value: categoryName,
                child: Text(categoryName),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
