import 'package:liquor_inventory/models/Base/Transaction.dart';
import 'package:liquor_inventory/models/History/addition_model.dart';
import 'package:liquor_inventory/models/History/sales_model.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:intl/intl.dart';

// an access hub for the History Page
// basically it houses all the essential datamodels and business logic for History page
class History {
  Insights get salesInsights => gtInsight(filteredSales);
  Insights get additionInsights => gtInsight(filteredAdditions);

  int month = 0;
  int year = Utils.gtCurrenDate(string: false).year;

  String get monthText =>
      month == 0 ? "Year" : DateFormat("MMMM").format(DateTime(0, month));

// access
  List<Sales> sales = [];
  List<Addition> additions = [];

  // getters
  List<Sales> get filteredSales => sales
      .where((e) => Utils.same(
          date: e.date, year: year, month: month == 0 ? null : month))
      .toList();

  List<Addition> get filteredAdditions => additions
      .where((e) => Utils.same(
          date: e.date, year: year, month: month == 0 ? null : month))
      .toList();

// pages
  Map<String, List<Sales>> get catDateSales {
    final dates = sales.map((e) => Utils.extractDate(e.date)).toSet().toList();
    dates.sort((a, b) => Utils.compareDate(b, a));
    Map<String, List<Sales>> ret = {};
    for (String date in dates) {
      ret[date] =
          sales.where((e) => Utils.extractDate(e.date) == date).toList();
    }
    return ret;
  }

  Map<String, List<Addition>> get catDateAddition {
    final dates =
        additions.map((e) => Utils.extractDate(e.date)).toSet().toList();
    dates.sort((a, b) => Utils.compareDate(b, a));
    Map<String, List<Addition>> ret = {};
    for (String date in dates) {
      ret[date] =
          additions.where((e) => Utils.extractDate(e.date) == date).toList();
    }

    return ret;
  }

  /*---------------------------Construction---------------------------*/
  static History instance = History._();
  History._();

  void load({salesLoaded, additionsLoaded}) async {
    // Addition(
    //   itemCode: UserModel.instance.inventory.items[0].itemCode,
    //   quantity: 32,
    // ).save();
    Sales().all((List sales) {
      salesLoaded(sales
          .map((e) => Sales.deserialize(Map<String, dynamic>.from(e)))
          .toList());
    });

    Addition().all((List additions) {
      additionsLoaded(additions
          .map((e) => Addition.deserialize(Map<String, dynamic>.from(e)))
          .toList());
    });
  }

  /*------------------------------------------------------*/
  gtDate(Transaction t, {format = Utils.DATE_FORMAT}) => month == 0
      ? DateFormat(format).parse(t.date).month
      : DateFormat(format).parse(t.date).day;

  Map<int, num> amtPerDate(List<Transaction> transactions) {
    final days = transactions.map(gtDate).toSet().toList();
    days.sort((a, b) => a.compareTo(b));
    Map<int, num> amts = {};
    days.forEach((d) {
      amts[d] = transactions
          .where((e) => gtDate(e) == d)
          .map((e) => e.quantity * e.item.price)
          .reduce((value, element) => value + element);
    });
    return amts;
  }

  Map<String, num> amtPerCatgory(List<Transaction> transactions) {
    final cats = transactions.map((e) => e.item.category).toSet();
    Map<String, num> amts = {};
    cats.forEach((c) {
      amts[c] = transactions
          .where((e) => e.item.category == c)
          .map((e) => e.quantity * e.item.price)
          .reduce((value, element) => value + element);
    });
    return amts;
  }

  totalAmount(List<Transaction> transactions) => transactions
      .map((e) => e.quantity * e.item.price)
      .reduce((value, element) => value + element);

  avgAmount(List<Transaction> transactions) =>
      totalAmount(transactions) / month == 0 ? 365 : 30;

  Insights gtInsight(List<Transaction> transactions) {
    final ret = Insights();
    if (transactions.isNotEmpty) {
      ret.totalItem = transactions
          .map((e) => e.quantity)
          .reduce((value, element) => value + element);
      ret.totalAmt = totalAmount(transactions);
      ret.avgAmt = avgAmount(transactions);
      final perDate = amtPerDate(transactions);
      final perCat = amtPerCatgory(transactions);
      ret.maxVal = perDate.keys.toList()[0];
      ret.piedata = perCat.entries.map((e) => PieData(e.key, e.value)).toList();
      ret.lineData = perDate.entries
          .map((e) => LineData(e.key.toString(), e.value))
          .toList();
    }
    return ret;
  }

/*---------------------------Utils---------------------------*/

  void addItem(Item item, {int quantity = 1}) {
    final addition = additions
        .firstWhere((e) => e.itemCode == item.itemCode && Utils.ofToday(e.date),
            orElse: () {
      final ret = Addition(itemCode: item.itemCode);
      additions.add(ret);
      return ret;
    });
    addition.quantity += quantity;
    addition.save();
  }

  void sellItem(Item item, {int quantity = 1}) {
    final sale = sales
        .firstWhere((e) => e.itemCode == item.itemCode && Utils.ofToday(e.date),
            orElse: () {
      final ret = Sales(itemCode: item.itemCode);
      sales.add(ret);

      return ret;
    });
    sale.quantity += quantity;
    print("Sale qyt ${sale.quantity} $quantity");
    sale.save();
    
  }
}

class Insights {
  int totalItem = 0;
  num totalAmt = 0;
  int maxVal = 1;
  num avgAmt = 0.0;
  String get maxOn {
    switch (maxVal) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${maxVal}th';
    }
  }

  List<PieData> piedata = [];
  List<LineData> lineData = [];
}

class PieData {
  String xVal;
  num yVal;
  String label;
  PieData(this.xVal, this.yVal, {this.label = ''}) {
    if (label == '') {
      label = xVal;
    }
  }
}

class LineData {
  String date;
  num quantity;
  LineData(this.date, this.quantity);
}
