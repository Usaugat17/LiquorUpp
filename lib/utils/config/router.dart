import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/auth/auth_cubit.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/cubits/inventory/item_detail_cubit.dart';
import 'package:liquor_inventory/cubits/miscell/settings_cubit.dart';
import 'package:liquor_inventory/cubits/scan/item_form_cubit.dart';
import 'package:liquor_inventory/views/auth/login.dart';
import 'package:liquor_inventory/views/home/home.dart';
import 'package:liquor_inventory/views/item/item_add_form.dart';
import 'package:liquor_inventory/views/item/item_detail.dart';
import 'package:liquor_inventory/views/item/item_edit_form.dart';
import 'package:liquor_inventory/views/settings/setttings.dart';
import 'package:liquor_inventory/views/splash_screen.dart';

class AppRouter {
  static const String settingsRoute = '/settings';
  static const String rootRoute = '/';
  static const String itemRoute = '/item';
  static const String loginRoute = '/login';
  static const String additemRoute = '/add';
  static const String edititemRoute = '/edit';
  static const String signupRoute = '/signup';
  static const String splash = '/splash';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case rootRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => InventoryCubit(),
                  child: const AppHomePage(title: 'Liquor Inventory App'),
                ));
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case settingsRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SettingsCubit(),
                  child: SettingsPage(),
                ));

      case loginRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (_) => AuthCubit(),
                  child: const LoginPage(),
                ));
      case additemRoute:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => ItemFormCubit(),
              child: ItemAddForm(
                barCodeScanValue: args,
              ),
            ),
          );
        }
        return _invalidRoute();
      case itemRoute:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => BlocProvider(
                  create: (context) => ItemDetailCubit(),
                  child: ItemDetailPage(
                      liquorItem: args[0], parentContext: args[1])));
        }
        return _invalidRoute();
      case edititemRoute:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => BlocProvider(
                  create: (context) => ItemFormCubit(),
                  child: ItemEditForm(
                    liquorItem: args[0],
                    parentContext: args[1],
                  )));
        }
        return _invalidRoute();
      default:
        return _invalidRoute();
    }
  }

  static Route<dynamic> _invalidRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
