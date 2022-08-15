import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/notificaion_uitls.dart';
import 'package:liquor_inventory/views/inventory/inventory_add_category.dart';
import 'package:liquor_inventory/views/inventory/inventory_search.dart';
import 'package:liquor_inventory/views/inventory/inventory_sort.dart';
import 'package:liquor_inventory/views/item/item_card.dart';
import 'package:liquor_inventory/utils/common.dart';
import 'package:liquor_inventory/views/item/item_category_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final int _inventoryPageIndex = 0, _categoriesPageIndex = 1;
  PageController pageController = PageController(initialPage: 0);
  bool _searchActive = false, _sortActive = false, _addCategory = false;

  late AnimateIconController searchIconController,
      sortIconController,
      categoryAddController;

  @override
  Widget build(BuildContext context) {
    UserModel.instance.init(context);
    NotificationUitls.init(context);
    searchIconController = AnimateIconController();

    sortIconController = AnimateIconController();
    categoryAddController = AnimateIconController();
    return BlocConsumer<InventoryCubit, InventoryState>(
        builder: (context, state) {
          if (state is InventoryCategoryUpdated) {
            return buildInvetoryPage(context,
                catsUpdated: true,
                cats: UserModel.instance.inventory.categories);
          } else if (state is InventoryItemsUpdated) {
            return buildInvetoryPage(context,
                itemUpdated: true,
                items: UserModel.instance.inventory.tempItems);
          }
          return buildInvetoryPage(context);
        },
        listener: (context, state) {});
  }

  Widget buildInvetoryPage(BuildContext context,
      {itemUpdated = false, catsUpdated = false, items, cats}) {
    return Column(
      children: [
        mainAppBar(context, "Inventory"),
        navigationButtons(),
        Expanded(
          child: PageView(
              controller: pageController,
              children: List<Widget>.from(
                [
                  inventoryPage(
                    itemUpdated
                        ? items
                        : UserModel.instance.inventory.tempItems,
                  ),
                  categoryPage(catsUpdated
                      ? cats
                      : UserModel.instance.inventory.categories),
                ],
              )),
        ),
      ],
    );
  }

  Widget _pageTitleText(String pageTitle) {
    return Text(
      pageTitle,
      style: GoogleFonts.readexPro(
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
        color: Palette.primaryRed,
      ),
    );
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
                _inventoryPageIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
            },
            child: Text(
              "Items",
              style: _navTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              pageController.animateToPage(
                _categoriesPageIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
            },
            child: Text(
              "Categories",
              style: _navTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryPage(cats) {
    // print(cats);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _pageTitleText("Item Categories"),
            ),
            AnimateIcons(
              startIcon: Icons.add,
              endIcon: Icons.close,
              onStartIconPress: () {
                setState(() {
                  _addCategory = true;
                });
                return true;
              },
              onEndIconPress: () {
                setState(() {
                  _addCategory = false;
                });
                return true;
              },
              duration: const Duration(milliseconds: 250),
              controller: categoryAddController,
            ),
          ],
        ),
        addCategorySpace(),
        allCategories(cats),
      ],
    );
  }

  Widget addCategorySpace() {
    return Visibility(
      child: AddCategory(),
      visible: _addCategory,
    );
  }

  Widget inventoryPage(items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerBar(),
        searchSpace(),
        sortSpace(),
        allInventoryItems(items),
      ],
    );
  }

  Widget searchSpace() {
    return Visibility(
      visible: _searchActive && !_sortActive,
      child: const InventorySearch(),
    );
  }

  Widget sortSpace() {
    return Visibility(
      visible: !_searchActive && _sortActive,
      child: const InventorySort(),
    );
  }

  Widget headerBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pageTitleText("Inventory Items"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // search
              AnimateIcons(
                startIcon: Icons.search,
                endIcon: Icons.close,
                endTooltip: "Search",
                onStartIconPress: () {
                  setState(() {
                    sortIconController.animateToStart();
                    _sortActive = false;
                    _searchActive = true;
                  });
                  return true;
                },
                onEndIconPress: () {
                  setState(() {
                    _sortActive = false;
                    _searchActive = false;
                  });
                  return true;
                },
                duration: const Duration(milliseconds: 250),
                controller: searchIconController,
              ),
              // sort icon
              AnimateIcons(
                startIcon: Icons.sort,
                endIcon: Icons.close,
                onStartIconPress: () {
                  setState(() {
                    searchIconController.animateToStart();
                    _sortActive = true;
                    _searchActive = false;
                  });
                  return true;
                },
                onEndIconPress: () {
                  setState(() {
                    _sortActive = false;
                    _searchActive = false;
                  });
                  return true;
                },
                duration: const Duration(milliseconds: 250),
                controller: sortIconController,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget allCategories(cats) {
    // print(cats);

    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: List<Widget>.from(cats
            .map((category) => ItemCategoryCard(category: category))
            .toList()),
      ),
    );
  }

  Widget allInventoryItems(List<Item> items) {
    // print(items);
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: items
            .map(
              (item) => LiquorItemCard(
                  key: ValueKey(item.itemName + "-" + item.category),
                  liquorItem: item),
            )
            .toList(),
      ),
    );
  }
}
