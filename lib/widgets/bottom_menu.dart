import 'package:flutter/material.dart';
import 'package:flutter_app/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/swap')) return 1;
    if (location.startsWith('/news')) return 2;
    if (location.startsWith('/settings')) return 3;
    if (location.startsWith('/theme')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/swap');
        break;
      case 2:
        context.go('/news');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onTap(context, index),
      selectedItemColor: isDark ? const Color(0xFF6366F1) : const Color(0xFFF59E0B),
      unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
      backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.money),
          label: "Döviz",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz),
          label: "Çevirici",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: "Haberler",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Ayarlar",
        ),
      ],
    );
  }
}
