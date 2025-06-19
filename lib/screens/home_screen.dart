import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/currency_service.dart';
import 'package:go_router/go_router.dart';
import '../theme_provider.dart';
import '../localization_provider.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> popularRates = {};
  Map<String, double> popularChanges = {};
  String? lastUpdated;

  
  Map<String, String> allCurrencyCodes = {
    "USD/TRY": "usd_try",
    "EUR/TRY": "eur_try", 
    "USD/EUR": "usd_eur",
    "GBP/TRY": "gbp_try",
    "CHF/TRY": "chf_try",
    "AUD/TRY": "aud_try",
    "CAD/TRY": "cad_try",
    "SAR/TRY": "sar_try", 
    "JPY/TRY": "jpy_try",
  };

  Map<String, Map<String, dynamic>> allCurrencies = {
    "USD/TRY": {"buy": 38.734, "sell": 38.801, "change": -0.05},
    "EUR/TRY": {"buy": 42.794, "sell": 42.968, "change": -1.51},
    "USD/EUR": {"buy": 1.1048, "sell": 1.1074, "change": -1.46},
    "GBP/TRY": {"buy": 50.707, "sell": 51.012, "change": -1.00},
    "CHF/TRY": {"buy": 45.330, "sell": 45.821, "change": -1.75},
    "AUD/TRY": {"buy": 23.868, "sell": 24.616, "change": -0.78},
    "CAD/TRY": {"buy": 27.157, "sell": 27.923, "change": -0.58},
    "SAR/TRY": {"buy": 10.180, "sell": 10.487, "change": -0.05},
    "JPY/TRY": {"buy": 0.257, "sell": 0.261, "change": -2.21},
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

Future<void> fetchData() async {
  try {
    final updatedRates = <String, double>{};
    final updatedChanges = <String, double>{};

    for (final pair in allCurrencyCodes.keys) {
      final base = pair.split('/')[0];
      final target = pair.split('/')[1];

      final result = await CurrencyService.fetchPopularRates(base);
      final current = result[target];

      if (current != null) {
        updatedRates[pair] = current;

        final staticSell = allCurrencies[pair]?['sell'];
        if (staticSell != null && staticSell > 0) {
          final changePercent = ((current - staticSell) / staticSell) * 100;
          updatedChanges[pair] = changePercent;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      popularRates = updatedRates;
      popularChanges = updatedChanges;
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
    return Consumer2<ThemeProvider, LocalizationProvider>(
      builder: (context, themeProvider, localizationProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final loc = localizationProvider; 
        
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          appBar: AppBar(
            backgroundColor: isDark 
              ? const Color(0xFF2D2D2D) 
              : const Color.fromRGBO(255, 193, 7, 1),
            title: Text(
              "FXSwift",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: fetchData,
              ),
              const SizedBox(width: 8),
            ],
            elevation: isDark ? 0 : 2,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    loc.t('popular_rates'), 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? const Color(0xFF2D2D2D) 
                      : const Color(0xFFF6F0F9),
                    borderRadius: BorderRadius.circular(16),
                    border: isDark 
                      ? Border.all(color: const Color(0xFF404040), width: 1)
                      : null,
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.shade400,
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
                            isDark,
                          ),
                          buildRateColumn(
                            "EUR/TRY",
                            popularRates["EUR/TRY"] ?? allCurrencies["EUR/TRY"]?["sell"],
                            popularChanges["EUR/TRY"] ?? allCurrencies["EUR/TRY"]?["change"],
                            isDark,
                          ),
                          buildRateColumn(
                            "USD/EUR",
                            popularRates["USD/EUR"] ?? allCurrencies["USD/EUR"]?["sell"],
                            popularChanges["USD/EUR"] ?? allCurrencies["USD/EUR"]?["change"],
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          lastUpdated != null
                              ? "${loc.t('last_updated')}${formatTime(lastUpdated!)}" 
                              : loc.t('updating'), 
                          style: TextStyle(
                            fontSize: 12, 
                            color: isDark ? Colors.grey[300] : Colors.black,
                          ),
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
                      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: isDark 
                        ? Border.all(color: const Color(0xFF404040), width: 1)
                        : null,
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.shade300,
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
                            border: Border(
                              bottom: BorderSide(
                                color: isDark 
                                  ? const Color(0xFF404040) 
                                  : Colors.grey.shade300, 
                                width: 0.5
                              )
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  loc.t('currency_unit'), 
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    loc.t('buy_rate'), 
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    loc.t('sell_rate'), 
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...allCurrencies.entries.map((entry) {
                          final code = entry.key;
                          final currencyNameKey = allCurrencyCodes[code];
                          final name = currencyNameKey != null ? loc.t(currencyNameKey) : code;
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
                            isDark: isDark,
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
      },
    );
  }

  Widget buildRateColumn(String label, double? value, double? changePercent, bool isDark) {
    final color = (changePercent ?? 0) < 0 
      ? (isDark ? const Color(0xFFEF4444) : Colors.red)
      : (isDark ? const Color(0xFF10B981) : Colors.green);
    final changeText = changePercent != null ? "${changePercent.toStringAsFixed(2)}%" : "-";

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Text(
          value != null ? value.toStringAsFixed(4) : '-',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
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
    required bool isDark,
  }) {
    final bool hasValue = buyRate > 0 && sellRate > 0;
    final String changeText = changePercent.toString();
    final Color changeColor = changePercent < 0 
      ? (isDark ? const Color(0xFFEF4444) : Colors.red)
      : (isDark ? const Color(0xFF10B981) : Colors.green);

    return InkWell(
      onTap: () {

        context.push('/currency-detail/$currencyCode', extra: {
          'currencyName': currencyName,
          'buyRate': buyRate,
          'sellRate': sellRate,
          'changePercent': changePercent,
        });
      },
      splashColor: isDark 
        ? Colors.white.withOpacity(0.1) 
        : Colors.grey.withOpacity(0.1),
      highlightColor: isDark 
        ? Colors.white.withOpacity(0.05) 
        : Colors.grey.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark 
                ? const Color(0xFF404040) 
                : Colors.grey.shade300, 
              width: 0.3
            )
          ),
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
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyName,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey.shade700, 
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasValue) ...[
                  Expanded(
                    flex: 2,
                    child: Text(
                      buyRate.toStringAsFixed(3),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black, 
                        fontSize: 18
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          sellRate.toStringAsFixed(3),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black, 
                            fontSize: 18
                          ),
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
                  Expanded(
                    flex: 2,
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black, 
                        fontSize: 18
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black, 
                        fontSize: 18
                      ),
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
                  Icon(
                    Icons.access_time, 
                    color: isDark ? Colors.grey[400] : Colors.grey.shade700, 
                    size: 12
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lastUpdate,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey.shade700, 
                      fontSize: 12
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios, 
                    color: isDark ? Colors.grey[500] : Colors.grey.shade500, 
                    size: 12
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}