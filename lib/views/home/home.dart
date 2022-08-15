import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/auth/auth_cubit.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:liquor_inventory/views/home/add_action_button.dart';
import 'package:liquor_inventory/views/inventory/inventory.dart';
import 'package:liquor_inventory/views/history/history_page.dart';
import 'package:liquor_inventory/views/scan/scan_item.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int _currentPage = 0;

  final List<Widget> _pagesList = <Widget>[
    const InventoryPage(),
    const ScanItem(),
    BlocProvider(
      create: (_) => HistoryCubit(),
      child: const HistoryPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocConsumer<InventoryCubit, InventoryState>(
        builder: (context, state) {
          if (state is InventoryExpandableToggle) {
            return _epandableFab(context, state.toggle);
          }

          return _epandableFab(context, false);
        },
        listener: (c, s) {},
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: _pagesList[_currentPage],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Palette.accentedRed,
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentPage,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Palette.primaryRed,
          onTap: (int index) {
            setState(() {
              // skip scan page since we have a floating action button
              if (index != 1) {
                _currentPage = index;
              }
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Inventory',
              icon: Icon(
                Icons.inventory_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.qr_code_scanner_outlined,
                color: Colors.transparent,
              ),
            ),
            BottomNavigationBarItem(
              label: 'History',
              icon: Icon(
                Icons.insights_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _epandableFab(BuildContext context, bool open) {
    return ExpandableFab(
      distance: 100.0,
      initialOpen: open,
      children: [
        const ScanItem(),
        ActionButton(
          onPressed: () {
            BlocProvider.of<InventoryCubit>(context).addItemForm(context);
          },
          icon: const Icon(Icons.post_add),
        ),
      ],
    );
  }
}
