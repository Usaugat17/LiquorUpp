import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/models/History/history.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/views/history/history.dart';
import 'package:liquor_inventory/views/history/date_selector.dart';
import 'package:animate_icons/animate_icons.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int additionsPageIndex = 0, salesPageIndex = 1;
  PageController pageController = PageController(initialPage: 0);
  bool _selectDate = false;
  int _page = 0;

  late AnimateIconController categoryAddController;
  @override
  void initState() {
    categoryAddController = AnimateIconController();
    UserModel.instance.init(context, onlyInventory: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryDateSelected) {
          _selectDate = false;
          return buildHistoryPage(context);
        } else if (state is HistoryInsightCarousalChange) {
          return buildHistoryPage(context, carousalIndex: state.index);
        } else if (state is HistoryInsightUpdated) {
          return buildHistoryPage(context, insights: state.insights);
        }
        return buildHistoryPage(context);
      },
      listener: (context, state) {},
    );
  }

  Widget buildHistoryPage(BuildContext context,
      {carousalIndex = 0, Insights? insights}) {
    final history = UserModel.instance.history;
    return Column(
      children: [
        mainAppBar(context, "History Page"),
        navigationButtons(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${_page == 0 ? "Additions" : "Sales"} - ${history.monthText}, ${history.year.toString()}",
                style: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  color: Palette.primaryRed,
                ),
              ),
            ),
            AnimateIcons(
              startIcon: Icons.sort,
              endIcon: Icons.close,
              onStartIconPress: () {
                _selectDate = true;
                BlocProvider.of<HistoryCubit>(context)
                    .selectedDateUpdated(context);
                return true;
              },
              onEndIconPress: () {
                _selectDate = false;
                BlocProvider.of<HistoryCubit>(context)
                    .selectedDateUpdated(context);
                return true;
              },
              duration: const Duration(milliseconds: 250),
              controller: categoryAddController,
            ),
          ],
        ),
        Visibility(
          visible: _selectDate,
          child: DateSelector(context, categoryAddController),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            controller: pageController,
            children: [
              additionsPage(context,
                  insights: insights, curIndex: carousalIndex),
              salesPage(context, insights: insights, curIndex: carousalIndex),
            ],
          ),
        ),
      ],
    );
  }

  Widget additionsPage(BuildContext context,
      {required Insights? insights, required curIndex}) {
    insights = insights ?? UserModel.instance.history.additionInsights;

    List<Widget> items = [
      salesInsights(context, curIndex, insights, 'Additions', 'Added'),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Transactions History",
          style: GoogleFonts.readexPro(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            color: Palette.primaryRed,
          ),
        ),
      ),
    ];
    items.addAll(addedItems());
    return ListView(
      scrollDirection: Axis.vertical,
      children: items,
    );
  }

  Widget salesPage(BuildContext context,
      {required Insights? insights, required curIndex}) {
    insights = insights ?? UserModel.instance.history.salesInsights;
    List<Widget> items = [
      salesInsights(context, curIndex, insights, 'Sales', 'Sold'),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Transactions History",
          style: GoogleFonts.readexPro(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            color: Palette.primaryRed,
          ),
        ),
      ),
    ];
    items.addAll(soldItems());

    return ListView(
      scrollDirection: Axis.vertical,
      children: items,
    );
  }

  List<Widget> soldItems() {
    final ret = UserModel.instance.history.catDateSales.entries
        .toList()
        .map((e) => itemSalesWidget(e.key, e.value))
        .toList();
    // print(ret);
    return ret;
  }

  List<Widget> addedItems() {
    return UserModel.instance.history.catDateAddition.entries
        .toList()
        .map((e) => itemAdditionWidget(e.key, e.value))
        .toList();
  }

  final _navTextStyle = GoogleFonts.raleway(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  Widget navigationButtons() {
    return Container(
      decoration: const BoxDecoration(
        color: Palette.accentedRed,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {
              pageController.animateToPage(
                additionsPageIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
            },
            child: Text(
              "Additions",
              style: _navTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              pageController.animateToPage(
                salesPageIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
            },
            child: Text(
              "Sales",
              style: _navTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
