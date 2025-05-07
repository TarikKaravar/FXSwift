// Gerekli importlar
import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> popularRates = {};
  String? lastUpdated;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await CurrencyService.fetchPopularRates();
      setState(() {
        popularRates = Map<String, double>.from(result['rates']);
        lastUpdated = result['last_updated'];
      });
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  String formatTime(String datetime) {
    final parsed = DateTime.parse(datetime).toLocal();
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("FXSwift"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ayarlar sayfasına yönlendirme vs.
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Canlı Kurlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F0F9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildRateColumn("USD/TRY", popularRates["USD/TRY"]),
                    buildRateColumn("EUR/TRY", popularRates["EUR/TRY"]),
                    buildRateColumn("GBP/TRY", popularRates["GBP/TRY"]),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    lastUpdated != null
                        ? "Son Güncelleme: ${formatTime(lastUpdated!)}"
                        : "Güncelleniyor...",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // 🔽 Diğer bölümler (Döviz çevirici, popüler kurlar vs.) BURADA DEVAM ETSİN
          const SizedBox(height: 16),

          // Diğer içerikler burada yer almaya devam edecek...
        ],
      ),
    );
  }

  Widget buildRateColumn(String label, double? value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value != null ? value.toStringAsFixed(4) : '-'),
        const Text(
          '+0.80%',
          style: TextStyle(color: Colors.green),
        ),
      ],
    );
  }
}