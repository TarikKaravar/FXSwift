import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'cur_live_wvOypY485gHCZ5b6pCBf37D3pWQpvLQnXQL0yV0d';
  static const String _latestUrl = 'https://api.currencyapi.com/v3/latest';
  static const String _rangeUrl = 'https://api.currencyapi.com/v3/range';

  static const List<String> popularPairs = [
    'USD/TRY',
    'EUR/TRY',
    'USD/EUR',
  ];

  /// Anlık oranlar
  static Future<Map<String, dynamic>> fetchPopularRates() async {
    final currencies = popularPairs.map((pair) => pair.split('/')[1]).toSet().join(',');
    const base = 'USD';
    final url = Uri.parse('$_latestUrl?apikey=$_apiKey&base_currency=$base&currencies=$currencies');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      final lastUpdated = jsonBody['meta']['last_updated_at'];

      Map<String, double> rates = {};

      for (var pair in popularPairs) {
        final baseCode = pair.split('/')[0];
        final targetCode = pair.split('/')[1];

        if (baseCode == base && data[targetCode] != null) {
          final rate = (data[targetCode]['value'] as num).toDouble();
          rates[pair] = rate;
        } else if (baseCode != base && data[baseCode] != null && data[targetCode] != null) {
          final baseVal = (data[baseCode]['value'] as num).toDouble();
          final targetVal = (data[targetCode]['value'] as num).toDouble();
          rates[pair] = targetVal / baseVal;
        }
      }

      return {
        'rates': rates,
        'last_updated': lastUpdated,
      };
    } else {
      throw Exception('Döviz kurları alınamadı: ${response.statusCode}');
    }
  }

  /// Canlı + % değişim hesaplayan versiyon
  static Future<Map<String, Map<String, double>>> fetchPopularRatesWithChange() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final todayStr = now.toIso8601String().split('T').first;
    final yesterdayStr = yesterday.toIso8601String().split('T').first;

    final results = <String, Map<String, double>>{};

    for (var pair in popularPairs) {
      final baseCode = pair.split('/')[0];
      final targetCode = pair.split('/')[1];

      final url = Uri.parse(
        '$_rangeUrl?apikey=$_apiKey&base_currency=$baseCode&currencies=$targetCode&start_date=$yesterdayStr&end_date=$todayStr',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];

        final double? current = data[todayStr]?[targetCode]?.toDouble();
        final double? previous = data[yesterdayStr]?[targetCode]?.toDouble();

        if (current != null && previous != null && previous != 0) {
          final change = ((current - previous) / previous) * 100;
          results[pair] = {
            'sell': current,
            'change': change,
          };
        }
      } else {
        print('Hata (range): $pair -> ${response.statusCode}');
      }
    }

    return results;
  }
}
