import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';

// Profil ekranı - Giriş Ekranı
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  
  // Şifre güvenliği değişkenleri
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Kaydedilmiş bilgileri yükle
  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe && savedUsername != null) {
      setState(() {
        _usernameController.text = savedUsername;
        _rememberMe = true;
      });
    }
  }

  // Bilgileri kaydet veya temizle
  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_rememberMe) {
      await prefs.setString('saved_username', _usernameController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
      await prefs.setBool('remember_me', false);
    }
  }

  // Şifre gücünü kontrol et
  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.red;

    if (password.isEmpty) {
      strength = 0.0;
      strengthText = '';
    } else if (password.length < 4) {
      strength = 0.25;
      strengthText = 'Çok Zayıf';
      strengthColor = Colors.red;
    } else if (password.length < 6) {
      strength = 0.5;
      strengthText = 'Zayıf';
      strengthColor = Colors.orange;
    } else if (password.length < 8) {
      strength = 0.75;
      strengthText = 'Orta';
      strengthColor = Colors.yellow[700]!;
    } else {
      // Güçlü şifre kontrolü
      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters) {
        strength = 1.0;
        strengthText = 'Çok Güçlü';
        strengthColor = Colors.green;
      } else if ((hasUppercase || hasLowercase) && hasDigits) {
        strength = 0.9;
        strengthText = 'Güçlü';
        strengthColor = Colors.lightGreen;
      } else {
        strength = 0.75;
        strengthText = 'Orta';
        strengthColor = Colors.yellow[700]!;
      }
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  void _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    // Bilgileri kaydet (await kaldırıldı)
    _saveCredentials();

    // Giriş işlemi simülasyonu (2 saniye bekleme)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Başarılı giriş mesajı
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hoş geldiniz, ${_usernameController.text}!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Ana profil ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(username: _usernameController.text),
        ),
      );
    }
  }
}


  void _register() {
    // Kayıt ol işlevi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt işlemi henüz mevcut değil'),
        backgroundColor: Colors.orange,
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
              'Profil',
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
            padding: const EdgeInsets.all(30),
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // FXSwift başlığı
                      Text(
                        'FXSwift',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Kullanıcı adı alanı
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? const Color(0xFF525252) : Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? const Color(0xFF404040) : Colors.white,
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Kullanıcı Adı',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kullanıcı adı gerekli';
                            }
                            if (value.length < 3) {
                              return 'Kullanıcı adı en az 3 karakter olmalı';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Şifre alanı
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? const Color(0xFF525252) : Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? const Color(0xFF404040) : Colors.white,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Şifre',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: isDark ? Colors.grey[400] : Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Şifre gerekli';
                            }
                            if (value.length < 6) {
                              return 'Şifre en az 6 karakter olmalı';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Şifre güç göstergesi
                      if (_passwordController.text.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Şifre Gücü',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                  if (_passwordStrengthText.isNotEmpty)
                                    Text(
                                      _passwordStrengthText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _passwordStrengthColor,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isDark 
                                    ? const Color(0xFF404040) 
                                    : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: LinearProgressIndicator(
                                  value: _passwordStrength,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _passwordStrengthColor,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Beni Hatırla seçeneği
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? const Color(0xFF525252) : Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark 
                            ? const Color(0xFF404040).withOpacity(0.3)
                            : Colors.grey[50],
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            'Beni Hatırla',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Kullanıcı adınız kaydedilir',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: isDark 
                            ? const Color(0xFF6366F1) 
                            : const Color.fromRGBO(255, 193, 7, 1),
                          checkColor: isDark ? Colors.white : Colors.black,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Giriş Yap butonu
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark 
                              ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                              : [const Color.fromRGBO(255, 193, 7, 1), const Color(0xFFF59E0B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF5B21B6) : Colors.black,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                ? const Color(0xFF6366F1).withOpacity(0.3)
                                : const Color.fromRGBO(255, 193, 7, 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'GİRİŞ YAP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Kayıt Ol butonu
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF404040) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF525252) : Colors.black,
                            width: 2,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFF404040) : Colors.white,
                            foregroundColor: isDark ? Colors.white : Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'KAYIT OL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Giriş yaptıktan sonra gösterilecek kullanıcı profil ekranı
class UserProfileScreen extends StatelessWidget {
  final String username;

  const UserProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Profil',
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark 
                            ? const Color(0xFF6366F1) 
                            : const Color.fromRGBO(255, 193, 7, 1)).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark 
                        ? const Color(0xFF6366F1) 
                        : const Color.fromRGBO(255, 193, 7, 1),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hoş geldiniz!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? const Color(0xFF6366F1).withOpacity(0.2)
                        : const Color.fromRGBO(255, 193, 7, 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark 
                          ? const Color(0xFF6366F1).withOpacity(0.3)
                          : const Color.fromRGBO(255, 193, 7, 0.3),
                      ),
                    ),
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                          ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                          : [const Color.fromRGBO(255, 193, 7, 1), const Color.fromRGBO(255, 235, 59, 1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark 
                            ? const Color(0xFF6366F1) 
                            : const Color.fromRGBO(255, 193, 7, 1)).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Profil düzenleme sayfasına git
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil düzenleme özelliği yakında eklenecek'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: isDark ? Colors.white : Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Profili Düzenle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Ek bilgi kartı
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? const Color(0xFF404040).withOpacity(0.5)
                        : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark 
                          ? const Color(0xFF525252)
                          : Colors.grey.shade200,
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
                            'Profil düzenleme ve diğer özellikler yakında eklenecek.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark 
                                ? Colors.grey[300]
                                : Colors.grey[600],
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