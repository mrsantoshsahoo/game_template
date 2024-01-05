import 'package:flutter/material.dart';
import 'package:game_template/src/app_service/app_key/global_keys.dart';
import 'package:game_template/src/app_service/app_lifecycle/app_lifecycle.dart';
import 'package:game_template/src/app_service/app_router/app_router.dart';
import 'package:game_template/src/app_service/app_theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode:   ThemeMode.light,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routerDelegate: AppRouter.router.routerDelegate,
        scaffoldMessengerKey: GlobalKeys.scaFoldMessageKey,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child:  child!,
        ),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

