// currency_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'cur_live_Y5F6IJ04n9niRA8hWctnrDGO9mH0A8QDcXFfE8uc';
  static const String _baseUrl = 'https://api.currencyapi.com/v3/latest';

  static const List<String> popularPairs = [
    'USD/TRY',
    'EUR/TRY',
    'GBP/TRY',
    'USD/EUR',
  ];

  // Belirli kurları ve son güncelleme zamanını çeker
  static Future<Map<String, dynamic>> fetchPopularRates() async {
    final currencies = popularPairs.map((pair) => pair.split('/')[1]).toSet().join(',');
    final base = 'USD';
    final url = Uri.parse('$_baseUrl?apikey=$_apiKey&base_currency=$base&currencies=$currencies');

    print('API URL: $url'); // URL'yi konsola yazdır

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      final lastUpdated = jsonBody['meta']['last_updated_at'];

      print('Veri başarıyla alındı!'); // Başarı mesajı
      print('Son Güncelleme Zamanı: $lastUpdated'); // Son güncelleme zamanını konsola yazdır

      Map<String, double> rates = {};

      for (var pair in popularPairs) {
        final baseCode = pair.split('/')[0];
        final targetCode = pair.split('/')[1];

        if (baseCode == base && data[targetCode] != null) {
          final rate = (data[targetCode]['value'] as num).toDouble();
          rates[pair] = rate;
          print('$pair: $rate'); // Her döviz kuru için değer yazdır
        } else if (baseCode != base && data[baseCode] != null && data[targetCode] != null) {
          double inverse = (data[baseCode]['value'] as num).toDouble();
          double target = (data[targetCode]['value'] as num).toDouble();
          double rate = target / inverse;
          rates[pair] = rate;
          print('$pair: $rate'); // Her döviz kuru için değer yazdır
        }
      }

      return {
        'rates': rates,
        'last_updated': lastUpdated,
      };
    } else {
      print('Hata oluştu: ${response.statusCode}'); // Hata durumunda mesaj yazdır
      throw Exception('Döviz kurları alınamadı: ${response.statusCode}');
    }
  }
}
