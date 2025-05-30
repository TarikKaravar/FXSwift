import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  final String _apiKey = 'a3eb0a4320754fe88816781f9ae75560';
  final String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> fetchCurrencyNews({String query = 'dolar'}) async {
    final url = Uri.parse("$_baseUrl?q=$query&language=tr&sortBy=publishedAt&apiKey=$_apiKey");
    print("🔗 Fetching news from: $url");

    final response = await http.get(url);
    print("📡 Status code: ${response.statusCode}");
    print("📄 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        throw Exception('API Hatası: ${data['message']}');
      }
      final List articles = data['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Haber verisi alınamadı: ${response.statusCode}');
    }
  }
}
