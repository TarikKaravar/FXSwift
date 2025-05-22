import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'profile_screen.dart';
import 'theme_screen.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          body: Column(
            children: [
              // Üst başlık bölümü
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
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
                child: Column(
                  children: [
                    // App logo/icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark 
                            ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                            : [const Color.fromRGBO(255, 193, 7, 1), const Color(0xFFF59E0B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isDark 
                              ? const Color(0xFF6366F1).withOpacity(0.3)
                              : const Color.fromRGBO(255, 193, 7, 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.currency_exchange,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FXSwift',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Döviz Çevirici',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Ana ayarlar bölümü
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
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
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ayarlar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uygulama tercihlerinizi buradan yönetebilirsiniz',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      _buildSettingsButton(
                        context,
                        'Profil',
                        Icons.person_outline,
                        () => _navigateToProfile(context),
                        isDark,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildSettingsButton(
                        context,
                        'Uygulama Teması',
                        isDark ? Icons.nightlight_round : Icons.wb_sunny,
                        () => _navigateToTheme(context),
                        isDark,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildSettingsButton(
                        context,
                        'Dil Seçenekleri',
                        Icons.language_outlined,
                        () => _navigateToLanguage(context),
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Alt bilgi
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Sürüm 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsButton(
    BuildContext context, 
    String text, 
    IconData icon, 
    VoidCallback onPressed,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
            : [const Color.fromRGBO(255, 193, 7, 1), const Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? const Color(0xFF6366F1).withOpacity(0.3)
              : const Color.fromRGBO(255, 193, 7, 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void _navigateToTheme(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ThemeScreen(),
      ),
    );
  }

  void _navigateToLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageScreen(),
      ),
    );
  }
}
