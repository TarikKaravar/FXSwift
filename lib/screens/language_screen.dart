import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String selectedLanguage = 'Türkçe';

  final List<Map<String, String>> languages = [
    {'name': 'Türkçe', 'code': 'TR', 'flag': '🇹🇷'},
    {'name': 'İngilizce', 'code': 'EN', 'flag': '🇺🇸'},
    {'name': 'Almanca', 'code': 'DE', 'flag': '🇩🇪'},
    {'name': 'Arapça', 'code': 'AR', 'flag': '🇸🇦'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _loadSelectedLanguage();
  }

  // Kaydedilmiş dili yükle
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language') ?? 'Türkçe';
    setState(() {
      selectedLanguage = savedLanguage;
    });
  }

  // Seçilen dili kaydet
  Future<void> _saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectLanguage(String language) async {
    setState(() {
      selectedLanguage = language;
    });
    
    // Dili kaydet
    await _saveSelectedLanguage(language);
    
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$language seçildi ve kaydedildi'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Dil Seçenekleri',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark 
              ? const Color(0xFF2D2D2D) 
              : const Color.fromRGBO(255, 193, 7, 1),
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            elevation: isDark ? 0 : 2,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Başlık ve açıklama
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Icon(
                        Icons.language,
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
                  'Dil Ayarları',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Uygulama dilini aşağıdaki seçeneklerden birini seçerek değiştirebilirsiniz.\nBu ayar tüm uygulama sayfalarında geçerli olacaktır.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[300] : Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Dil seçenekleri
                ...languages.map((language) {
                  final isSelected = selectedLanguage == language['name'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectLanguage(language['name']!),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                              ? (isDark 
                                  ? const Color(0xFF6366F1).withOpacity(0.2)
                                  : const Color(0xFFF59E0B).withOpacity(0.1))
                              : (isDark ? const Color(0xFF404040) : Colors.grey[50]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                ? (isDark 
                                    ? const Color(0xFF6366F1)
                                    : const Color(0xFFF59E0B))
                                : (isDark 
                                    ? const Color(0xFF525252) 
                                    : Colors.grey.shade200),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Bayrak emoji
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                    ? (isDark 
                                        ? const Color(0xFF6366F1).withOpacity(0.3)
                                        : const Color(0xFFF59E0B).withOpacity(0.2))
                                    : (isDark 
                                        ? const Color(0xFF525252)
                                        : Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  language['flag']!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Dil bilgileri
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['name']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                          ? (isDark 
                                              ? const Color(0xFF6366F1)
                                              : const Color(0xFFF59E0B))
                                          : (isDark ? Colors.white : Colors.black),
                                      ),
                                    ),
                                    Text(
                                      language['code']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Seçim göstergesi
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark 
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFFF59E0B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
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
                }).toList(),
                

              ],
            ),
          ),
        );
      },
    );
  }
}
