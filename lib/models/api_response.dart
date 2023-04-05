import 'article.dart';

class APIResponse {
  late String status;
  late int totalResults;
  final List<ArticleModel> results = [];

  APIResponse.fromJson(Map<String, dynamic> jsonResponse) {
    status = jsonResponse['status'];
    totalResults = int.parse(jsonResponse['totalResults'].toString());
    final articles = jsonResponse['results'] as List;
    for (var element in articles) {
      results.add(ArticleModel(
          title: element['title'],
          link: element['link'],
          description: element['description'],
          content: element['content'],
          image_url: element['image_url'].toString(),
          source_id: element['source_id'],
          language: element['language'],
          category: element['category'],
          country: element['country'],
          creator: element['creator'],
          keywords: element['keywords'],
          pubDate: DateTime.parse(element['pubDate'])));
    }
  }
}
