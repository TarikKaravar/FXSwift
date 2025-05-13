import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'cur_live_wvOypY485gHCZ5b6pCBf37D3pWQpvLQnXQL0yV0d';
  static const String _latestUrl = 'https://api.currencyapi.com/v3/latest';

  static const List<String> popularPairs = [
    'USD/TRY',
    'EUR/TRY',
    'USD/EUR',
  ];

  static Future<Map<String, dynamic>> fetchPopularRates() async {
    final base = 'USD';
    final currencies = popularPairs
        .map((pair) => pair.split('/')[1])
        .toSet()
        .join(',');

    final url = Uri.parse(
      '$_latestUrl?apikey=$_apiKey&base_currency=$base&currencies=$currencies',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        final lastUpdated = jsonBody['meta']['last_updated_at'];

        Map<String, double> rates = {};

        for (var pair in popularPairs) {
          final baseCode = pair.split('/')[0];
          final targetCode = pair.split('/')[1];

          final targetData = data[targetCode];
          final baseData = data[baseCode];

          if (baseCode == base && targetData != null && targetData['value'] != null) {
            final rate = (targetData['value'] as num).toDouble();
            rates[pair] = rate;
          } else if (baseCode != base &&
              baseData != null && baseData['value'] != null &&
              targetData != null && targetData['value'] != null) {
            final baseVal = (baseData['value'] as num).toDouble();
            final targetVal = (targetData['value'] as num).toDouble();
            rates[pair] = targetVal / baseVal;
          } else {
            print("⚠️ Veri eksik veya null geldi: $pair");
          }
        }

        return {
          'rates': rates,
          'last_updated': lastUpdated,
        };
      } else {
        print('Hata (latest): ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Döviz kurları alınamadı.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      rethrow;
    }
  }
}
