import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsItem> newsItems = [];

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=e6a8c508c4244878a227b1b572537191'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> articles = jsonData['articles'];
      List<NewsItem> items = [];
      for (var article in articles) {
        final String title = article['title'];
        final String description = article['description'];
        final String url = article['url'];

        items.add(NewsItem(title: title, description: description, url: url));
      }

      setState(() {
        newsItems = items;
      });
    } else {
      throw Exception('Failed to fetch news data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final item = newsItems[index];
          return ListTile(
            leading: Icon(Icons.article),
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () {
              // Abrir el enlace de la noticia original
              // Puedes usar el paquete `url_launcher` para abrir el enlace en el navegador
            },
          );
        },
      ),
    );
  }
}

class NewsItem {
  final String title;
  final String description;
  final String url;

  NewsItem({
    required this.title,
    required this.description,
    required this.url,
  });
}