import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> popularRates = {};
  Map<String, double> popularChanges = {};
  String? lastUpdated;

  Map<String, Map<String, dynamic>> allCurrencies = {
    "USD/TRY": {"name": "Amerikan Doları", "buy": 38.734, "sell": 38.801, "change": -0.05},
    "EUR/TRY": {"name": "Euro", "buy": 42.794, "sell": 42.968, "change": -1.51},
    "USD/EUR": {"name": "EUR/USD", "buy": 1.1048, "sell": 1.1074, "change": -1.46},
    "GBP/TRY": {"name": "İngiliz Sterlini", "buy": 50.707, "sell": 51.012, "change": -1.00},
    "CHF/TRY": {"name": "İsviçre Frangı", "buy": 45.330, "sell": 45.821, "change": -1.75},
    "AUD/TRY": {"name": "Avustralya Doları", "buy": 23.868, "sell": 24.616, "change": -0.78},
    "CAD/TRY": {"name": "Kanada Doları", "buy": 27.157, "sell": 27.923, "change": -0.58},
    "SAR/TRY": {"name": "Suudi Arabistan Riyali", "buy": 10.180, "sell": 10.487, "change": -0.05},
    "JPY/TRY": {"name": "Japon Yeni", "buy": 0.257, "sell": 0.261, "change": -2.21},
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await CurrencyService.fetchPopularRates();
      if (!mounted) return;
      setState(() {
        for (final entry in result.entries) {
          final code = entry.key;
          popularRates[code] = entry.value['sell']!;
          popularChanges[code] = entry.value['change']!;
        }
        lastUpdated = DateTime.now().toIso8601String();
      });
    } catch (e) {
      print('Hata oluştu: $e');
      if (!mounted) return;
      setState(() {
        lastUpdated = DateTime.now().toIso8601String();
      });
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
        backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
        title: const Text("FXSwift"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Popüler Kurlar",
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
                      buildRateColumn(
                        "USD/TRY",
                        popularRates["USD/TRY"] ?? allCurrencies["USD/TRY"]?["sell"],
                        popularChanges["USD/TRY"] ?? allCurrencies["USD/TRY"]?["change"],
                      ),
                      buildRateColumn(
                        "EUR/TRY",
                        popularRates["EUR/TRY"] ?? allCurrencies["EUR/TRY"]?["sell"],
                        popularChanges["EUR/TRY"] ?? allCurrencies["EUR/TRY"]?["change"],
                      ),
                      buildRateColumn(
                        "USD/EUR",
                        popularRates["USD/EUR"] ?? allCurrencies["USD/EUR"]?["sell"],
                        popularChanges["USD/EUR"] ?? allCurrencies["USD/EUR"]?["change"],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      lastUpdated != null
                          ? "Son Güncelleme: ${formatTime(lastUpdated!)}"
                          : "Güncelleniyor...",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Birim",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Alış",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Satış",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...allCurrencies.entries.map((entry) {
                      final code = entry.key;
                      final name = entry.value['name'];
                      final isLive = popularRates.containsKey(code);
                      final buy = isLive ? popularRates[code]! - 0.05 : entry.value['buy'];
                      final sell = isLive ? popularRates[code]! : entry.value['sell'];
                      final change = isLive
                          ? (popularChanges[code] ?? 0)
                          : entry.value['change'];

                      return buildCurrencyListItem(
                        currencyCode: code,
                        currencyName: name,
                        buyRate: buy,
                        sellRate: sell,
                        changePercent: change,
                        lastUpdate: lastUpdated != null ? formatTime(lastUpdated!) : "20:26",
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRateColumn(String label, double? value, double? changePercent) {
    final color = (changePercent ?? 0) < 0 ? Colors.red : Colors.green;
    final changeText = changePercent != null ? "${changePercent.toStringAsFixed(2)}%" : "-";

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value != null ? value.toStringAsFixed(4) : '-'),
        Text(
          changeText,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget buildCurrencyListItem({
    required String currencyCode,
    required String currencyName,
    required double buyRate,
    required double sellRate,
    required double changePercent,
    required String lastUpdate,
  }) {
    final bool hasValue = buyRate > 0 && sellRate > 0;
    final String changeText = changePercent.toString();
    final Color changeColor = changePercent < 0 ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currencyCode,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyName,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),
              if (hasValue) ...[
                Expanded(
                  flex: 2,
                  child: Text(
                    buyRate.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        sellRate.toStringAsFixed(3),
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "%$changeText",
                        style: TextStyle(color: changeColor, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const Expanded(
                  flex: 2,
                  child: Text(
                    "-",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    "-",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade700, size: 12),
                const SizedBox(width: 4),
                Text(
                  lastUpdate,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
