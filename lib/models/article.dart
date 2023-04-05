class ArticleModel {
  final String title, link, description, content, image_url, source_id, language;
  final List? category, country, creator, keywords;
  final String? video_url;
  final DateTime pubDate;

  ArticleModel(
      {required this.title,
        required this.link,
        required this.description,
        required this.content,
        required this.image_url,
        required this.source_id,
        required this.language,
        required this.category,
        required this.country,
        required this.creator,
        required this.keywords,
        this.video_url,
        required this.pubDate});
}