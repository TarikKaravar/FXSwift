import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'YOUR_API_KEY'; // Buraya kendi API key'ini koy

  static Future<Map<String, double>> fetchPopularRates(String base) async {
    final url = Uri.parse(
      'https://api.currencyapi.com/v3/latest?apikey=$_apiKey&base_currency=$base',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'] as Map<String, dynamic>;

      Map<String, double> rates = {};
      data.forEach((code, value) {
        rates[code] = (value['value'] as num).toDouble();
      });

      return rates;
    } else {
      throw Exception('Failed to fetch popular rates');
    }
  }

  static Future<Map<DateTime, double>> fetchHistory(String pair) async {
    final base = pair.split('/')[0];
    final target = pair.split('/')[1];

    final now = DateTime.now();
    final start = now.subtract(Duration(days: 7));

    final url = Uri.parse(
      'https://api.currencyapi.com/v3/historical?apikey=$_apiKey&base_currency=$base&currencies=$target&date_from=${start.toIso8601String().substring(0, 10)}&date_to=${now.toIso8601String().substring(0, 10)}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'] as Map<String, dynamic>;

        Map<DateTime, double> history = {};
        data.forEach((dateStr, entry) {
          final rate = entry[target]?['value'];
          if (rate != null) {
            history[DateTime.parse(dateStr)] = (rate as num).toDouble();
          }
        });

        return history;
      } else {
        print('Hata (history): ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Geçmiş kurlar alınamadı.');
      }
    } catch (e) {
      print('fetchHistory hatası: $e');
      rethrow;
    }
  }
}
