import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'cur_live_dCxfh6SNLbDySljdEYEQv2WQPmehhRN8ZKObcxEK';

  /// Güncel kurları çeker
  static Future<Map<String, double>> fetchPopularRates(String base) async {
    final url = Uri.parse(
      'https://api.currencyapi.com/v3/latest?apikey=$_apiKey&base_currency=$base',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'] as Map<String, dynamic>;

      Map<String, double> rates = {};
      for (var entry in data.entries) {
        final code = entry.key;
        final value = entry.value['value'];
        if (value != null) {
          rates[code] = (value as num).toDouble();
        }
      }

      return rates;
    } else {
      print('fetchPopularRates error: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Kur bilgileri alınamadı.');
    }
  }

  /// Geçmiş kurları çeker (örnek: "USD/TRY")
  static Future<Map<DateTime, double>> fetchHistory(String pair) async {
    final base = pair.split('/')[0];
    final target = pair.split('/')[1];

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));

    final url = Uri.parse(
      'https://api.currencyapi.com/v3/historical?apikey=$_apiKey&base_currency=$base&currencies=$target&date_from=${start.toIso8601String().substring(0, 10)}&date_to=${now.toIso8601String().substring(0, 10)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'] as Map<String, dynamic>;

      Map<DateTime, double> history = {};
      for (var entry in data.entries) {
        final date = DateTime.parse(entry.key);
        final rate = entry.value[target]?['value'];
        if (rate != null) {
          history[date] = (rate as num).toDouble();
        }
      }

      return history;
    } else {
      print('fetchHistory error: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Geçmiş veriler alınamadı.');
    }
  }
}
