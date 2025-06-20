import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app/screens/home_screen.dart';

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

    
    _loadAppData();
  }

  
  Future<void> _loadAppData() async {
    
    
    await Future.delayed(const Duration(seconds: 5));
    
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      
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
                color: Color(0xFFFFD700), 
              ),
            ),
            const SizedBox(height: 20),
            
            
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/motions/loading.lottie', 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  
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