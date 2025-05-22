import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news_service.dart';
import '../theme_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsArticle>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = NewsService().fetchCurrencyNews();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Döviz Haberleri',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark 
              ? const Color(0xFF2D2D2D) 
              : const Color.fromRGBO(255, 193, 7, 1),
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            elevation: isDark ? 0 : 2,
          ),
          body: FutureBuilder<List<NewsArticle>>(
            future: _futureNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: isDark 
                      ? const Color(0xFF6366F1) 
                      : const Color.fromRGBO(255, 193, 7, 1),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF404040) : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: isDark 
                            ? const Color(0xFFEF4444) 
                            : Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Haber yüklenirken hata oluştu",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureNews = NewsService().fetchCurrencyNews();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark 
                              ? const Color(0xFF6366F1) 
                              : const Color.fromRGBO(255, 193, 7, 1),
                            foregroundColor: isDark ? Colors.white : Colors.black,
                          ),
                          child: const Text('Tekrar Dene'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final newsList = snapshot.data ?? [];

              if (newsList.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF404040) : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Hiç haber bulunamadı",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Şu anda gösterilecek haber bulunmuyor.",
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                color: isDark 
                  ? const Color(0xFF6366F1) 
                  : const Color.fromRGBO(255, 193, 7, 1),
                onRefresh: () async {
                  setState(() {
                    _futureNews = NewsService().fetchCurrencyNews();
                  });
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: isDark 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.grey.withOpacity(0.1),
                          highlightColor: isDark 
                            ? Colors.white.withOpacity(0.05) 
                            : Colors.grey.withOpacity(0.05),
                          onTap: () async {
                            final uri = Uri.parse(news.url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Link açılamıyor."),
                                  backgroundColor: isDark 
                                    ? const Color(0xFFEF4444) 
                                    : Colors.red,
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDark 
                                          ? const Color(0xFF6366F1).withOpacity(0.2)
                                          : const Color.fromRGBO(255, 193, 7, 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.article,
                                        color: isDark 
                                          ? const Color(0xFF6366F1)
                                          : const Color.fromRGBO(255, 193, 7, 1),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.white : Colors.black,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8, 
                                              vertical: 4
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark 
                                                ? const Color(0xFF404040) 
                                                : Colors.grey[100],
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              news.source,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark 
                                                  ? Colors.grey[300] 
                                                  : Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.open_in_new,
                                      color: isDark 
                                        ? Colors.grey[400] 
                                        : Colors.grey[600],
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: isDark 
                                        ? Colors.grey[400] 
                                        : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Şimdi",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark 
                                          ? Colors.grey[400] 
                                          : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}