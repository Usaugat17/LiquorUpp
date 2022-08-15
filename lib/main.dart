import 'package:flutter/material.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/config/theme.dart';
import 'package:liquor_inventory/utils/fire_utils.dart';
import 'package:liquor_inventory/utils/notificaion_uitls.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.init();
  // NotificationUitls.init(context);
  runApp(LiquorInventoryApp());
}

class LiquorInventoryApp extends StatelessWidget {
  final theme = AppTheme.light();

  LiquorInventoryApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // NotificationUitls.init(context);

    return MaterialApp(
      title: 'Liquor Inventory App',
      theme: theme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
