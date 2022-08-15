import 'dart:ffi';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/models/History/addition_model.dart';
import 'package:liquor_inventory/models/History/history.dart';
import 'package:liquor_inventory/models/History/sales_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/string_extension.dart';
import 'package:liquor_inventory/views/history/history_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget itemSalesWidget(String date, List<Sales> sales) {
  // print(date);
  // print(sales);
  return Column(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Text(
          date,
          style: GoogleFonts.readexPro(
            color: Palette.accentedRed,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Column(
        children: sales
            .map((e) => ItemHistoryCard(
                  tx: e,
                  isItemSold: true,
                ))
            .toList(),
      ),
    ],
  );
}

Widget itemAdditionWidget(String date, List<Addition> additions) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Text(
          date,
          style: GoogleFonts.readexPro(
            color: Palette.darkRed,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Column(
        children: additions
            .map((e) => ItemHistoryCard(
                  tx: e,
                  isItemSold: false,
                ))
            .toList(),
      ),
    ],
  );
}

Widget salesInsights(BuildContext context, curIndex, Insights insights,
    String title, String action) {
  return Card(
    margin: const EdgeInsets.all(10),
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    BlocProvider.of<HistoryCubit>(context)
                        .carousalAction(context, index);
                  },
                ),
                items: [
                  Center(
                    child: SfCircularChart(
                      title: ChartTitle(
                          text: '${title.capitalize()} by category.'),
                      legend: Legend(isVisible: true),
                      series: <PieSeries<PieData, String>>[
                        PieSeries<PieData, String>(
                            explode: true,
                            explodeIndex: 0,
                            dataSource: insights.piedata,
                            xValueMapper: (PieData data, _) => data.xVal,
                            yValueMapper: (PieData data, _) => data.yVal,
                            dataLabelMapper: (PieData data, _) => data.label,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true)),
                      ],
                    ),
                  ),
                  SfCartesianChart(
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: '${title.capitalize()} by date.'),

                    series: <LineSeries<LineData, String>>[
                      LineSeries<LineData, String>(
                          // Bind data source
                          dataSource: insights.lineData,
                          xValueMapper: (LineData data, _) => data.date,
                          yValueMapper: (LineData data, _) => data.quantity)
                    ],
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2].map((urlOfItem) {
                int index = [1, 2].indexOf(urlOfItem);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: curIndex == index
                        ? Palette.primaryRed
                        : const Color.fromARGB(62, 242, 14, 14),
                  ),
                );
              }).toList(),
            )
          ],
        ),
        Card(
          margin: const EdgeInsets.all(10.0),
          elevation: 1,
          shadowColor: Palette.darkRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Item $action',
                            style: GoogleFonts.raleway(
                                color: Colors.black, fontSize: 16.0),
                          ),
                          Text(
                            "${insights.totalItem}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                              color: Palette.primaryRed,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Total $title',
                            style: GoogleFonts.raleway(
                                color: Colors.black, fontSize: 16.0),
                          ),
                          Text(
                            "\$${insights.totalAmt}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                              color: Palette.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Max. $title On',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.raleway(
                                color: Colors.black, fontSize: 16.0),
                          ),
                          Text(
                            insights.maxOn,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                              color: Palette.primaryRed,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Avg $title /day',
                            style: GoogleFonts.raleway(
                                color: Colors.black, fontSize: 16.0),
                          ),
                          Text(
                            "\$${insights.avgAmt}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                              color: Palette.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
