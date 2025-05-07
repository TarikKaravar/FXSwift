import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app/screens/home_screen.dart'; // HomeScreen'i import edin

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Uygulama verilerini yükle ve ardından ana sayfaya geç
    _loadAppData();
  }

  // Uygulama verilerini yükleme simülasyonu
  Future<void> _loadAppData() async {
    // Gerçek verilerinizi yüklemek için gereken işlemler:
    // API çağrıları, veritabanı işlemleri vs.
    
    // Simülasyon için 5 saniye bekle
    await Future.delayed(const Duration(seconds: 5));
    
    // UI güncelle ve ardından ana sayfaya geç
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // MainScreen yerine HomeScreen'e yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FXSwift',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700), // Altın sarısı
              ),
            ),
            const SizedBox(height: 20),
            
            // Lottie animasyonu
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/motions/loading.lottie', // Lottie dosyanızın yolu
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Animasyon yüklenemezse gösterilecek yedek içerik
                  return Container(
                    color: Colors.black,
                    child: const Icon(
                      Icons.currency_exchange,
                      size: 80,
                      color: Color(0xFFFFD700),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            const Text(
              'YÜKLENİYOR...',
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2,
                color: Color(0xFFFFD700),
              ),
            ),
            
            const SizedBox(height: 30),
            // İlerleme çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade800,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            const SizedBox(height: 30),
            // Para birimi etiketleri
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                CurrencyTag(text: 'USD'),
                CurrencyTag(text: 'EUR'),
                CurrencyTag(text: 'TRY'),
                CurrencyTag(text: 'GBP'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Para birimi etiketleri için widget
class CurrencyTag extends StatelessWidget {
  final String text;
  
  const CurrencyTag({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}