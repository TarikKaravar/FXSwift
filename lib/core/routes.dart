import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/settings_screen.dart';
import 'package:flutter_app/screens/swap_screen.dart';
import 'package:flutter_app/screens/news_screen.dart';
import 'package:flutter_app/screens/theme_screen.dart';
import 'package:flutter_app/widgets/bottom_menu.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/swap',
          name: 'swap',
          builder: (context, state) => const SwapScreen(),
        ),
        GoRoute(
          path: '/news',
          name: 'news',
          builder: (context, state) => const NewsScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/theme',
          name: 'theme',
          builder: (context, state) => const ThemeScreen(),
        ),
      ],
    ),
  ],
);

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
