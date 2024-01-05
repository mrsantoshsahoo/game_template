import 'package:flutter/material.dart';
import 'package:game_template/main.dart';
import 'package:go_router/go_router.dart';
class AppRouter{
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DemoScreen(key: Key('main menu')),
      ),
    ],
  );
}

