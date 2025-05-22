import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _wasDark = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    _wasDark = isDark;
    if (isDark) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ThemeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    if (_wasDark != isDark) {
      isDark ? _animationController.forward() : _animationController.reverse();
      _wasDark = isDark;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          appBar: AppBar(
            title: Text(
              'Uygulama Teması',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            elevation: 0,
          ),
          body: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              border: Border.all(
                color: isDark ? const Color(0xFF404040) : Colors.grey.shade200,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value * 3.14159,
                        child: Icon(
                          isDark ? Icons.nightlight_round : Icons.wb_sunny,
                          size: 80,
                          color: isDark 
                            ? const Color(0xFF6366F1) 
                            : const Color(0xFFF59E0B),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Tema Ayarları',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Uygulama temasını aşağıdaki düğme ile değiştirebilirsiniz.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[300] : Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF404040) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF525252) : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark 
                                  ? const Color(0xFF6366F1).withOpacity(0.2)
                                  : const Color(0xFFF59E0B).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isDark ? Icons.nightlight_round : Icons.wb_sunny,
                                color: isDark 
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFF59E0B),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Karanlık Mod',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  isDark ? 'Açık' : 'Kapalı',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
  onTap: () {
    themeProvider.toggleTheme(!themeProvider.isDarkMode);
  },
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 60,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: isDark 
        ? const Color(0xFF6366F1)
        : Colors.grey[300],
    ),
    child: Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          left: isDark ? 30 : 2,
          top: 2,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny,
              size: 16,
              color: isDark 
                ? const Color(0xFF6366F1)
                : const Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    ),
  ),
),

                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? const Color(0xFF1E40AF).withOpacity(0.1)
                        : const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark 
                          ? const Color(0xFF1E40AF).withOpacity(0.3)
                          : const Color(0xFF3B82F6).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark 
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF3B82F6),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tema tercihiniz otomatik olarak kaydedilir.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark 
                                ? const Color(0xFF60A5FA)
                                : const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
