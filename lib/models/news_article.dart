class NewsArticle {
  final String title;
  final String url;
  final String source;

  NewsArticle({
    required this.title,
    required this.url,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      source: json['source']?['name'] ?? 'Bilinmeyen',
    );
  }
}
