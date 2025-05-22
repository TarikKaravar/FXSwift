import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  final String _apiKey = 'bf98c58b17e80ffa6e6d4a0cbe5e709c';
  final String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> fetchCurrencyNews({String query = 'dolar'}) async {
    final url = Uri.parse("$_baseUrl?q=$query&language=tr&sortBy=publishedAt&apiKey=$_apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Haber verisi alınamadı');
    }
  }
}
