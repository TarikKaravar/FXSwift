import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  // Google Sign-In yapılandırması
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_username', _usernameController.text);
    await prefs.setString('registered_password', _passwordController.text);
    await prefs.setBool('google_user', false); // Normal kayıt
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _saveCredentials();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başarılı, ${_usernameController.text}! Lütfen giriş yapın.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        _usernameController.clear();
        _passwordController.clear();
        Navigator.pop(context);
      }
    }
  }

  Future<void> _registerWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Önce mevcut hesapları temizle
      await _googleSignIn.signOut();
      
      // Google Sign-In yapılandırmasını kontrol et
      print('Google Sign-In starting...');
      print('Google Sign-In configured: ${_googleSignIn.currentUser}');

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account != null) {
        // Hesap bilgilerini logla
        print('Google Account: ${account.email}');
        print('Display Name: ${account.displayName}');
        
        // Authentication token'ı al
        final GoogleSignInAuthentication auth = await account.authentication;
        print('Access Token available: ${auth.accessToken != null}');
        print('ID Token available: ${auth.idToken != null}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('registered_username', account.email);
        await prefs.setString('registered_password', ''); 
        await prefs.setBool('google_user', true); // Google kullanıcısı işareti
        await prefs.setString('user_display_name', account.displayName ?? '');
        await prefs.setString('user_photo_url', account.photoUrl ?? '');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google ile kayıt başarılı: ${account.displayName ?? account.email}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        // Kullanıcı işlemi iptal etti
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google ile kayıt iptal edildi'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } on PlatformException catch (error) {
      print('PlatformException: ${error.code} - ${error.message}');
      print('PlatformException details: ${error.details}');
      
      String errorMessage = 'Google ile kayıt başarısız';
      
      switch (error.code) {
        case 'sign_in_failed':
          errorMessage = 'Google giriş başarısız. SHA-1 fingerprint kontrol edin.';
          break;
        case 'sign_in_canceled':
          errorMessage = 'Google giriş iptal edildi.';
          break;
        case 'network_error':
          errorMessage = 'Ağ bağlantısı hatası. İnternetinizi kontrol edin.';
          break;
        case 'sign_in_required':
          errorMessage = 'Google hesabı gerekli.';
          break;
        default:
          // ApiException 10 özel durumu
          if (error.message?.contains('ApiException: 10') == true) {
            errorMessage = 'Google yapılandırma hatası. SHA-1 fingerprint ve OAuth ayarlarını kontrol edin.';
          } else {
            errorMessage = 'Google ile kayıt başarısız: ${error.message}';
          }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Detay',
              textColor: Colors.white,
              onPressed: () {
                _showErrorDialog(error);
              },
            ),
          ),
        );
      }
    } catch (error) {
      print('General error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Beklenmeyen hata: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(PlatformException error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Google Sign-In Hatası'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hata Kodu: ${error.code}'),
              const SizedBox(height: 8),
              Text('Mesaj: ${error.message}'),
              const SizedBox(height: 16),
              const Text(
                'Çözüm Önerileri:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• Firebase Console\'da SHA-1 fingerprint kontrol edin'),
              const Text('• google-services.json dosyasını güncelleyin'),
              const Text('• Package name\'i kontrol edin'),
              const Text('• Google Sign-In API\'yi etkinleştirin'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
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
              'Kayıt Ol',
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
                      Text(
                        'FXSwift',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Kullanıcı Adı
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      // Şifre Alanı
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                  color: isDark ? const Color(0xFF404040) : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: LinearProgressIndicator(
                                  value: _passwordStrength,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      // Normal Kayıt Ol Butonu
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFF6366F1) : Colors.orange,
                            foregroundColor: Colors.white,
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
                                  'KAYIT OL',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Google ile Kayıt Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _registerWithGoogle,
                          icon: _isLoading 
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Image.asset(
                                  'assets/icons/google_logo.png',
                                  height: 24,
                                  width: 24,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.g_mobiledata,
                                      size: 24,
                                      color: isDark ? Colors.white : Colors.black,
                                    );
                                  },
                                ),
                          label: Text(
                            _isLoading ? 'Google ile Bağlanıyor...' : 'Google ile Kayıt Ol',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: isDark ? Colors.white : Colors.black, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            foregroundColor: isDark ? Colors.white : Colors.black,
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