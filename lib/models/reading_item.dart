class ReadingItem {
  final String id;
  final String title;
  final String category;
  final String level;
  final String author;
  final int minutes;
  final String summary;
  final String assetPath;
  final String content;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;

  const ReadingItem({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.author,
    required this.minutes,
    required this.summary,
    required this.assetPath,
    this.content = '',
    this.imageUrl = '',
    this.sourceName = '',
    this.publishedAt = '',
  });

  factory ReadingItem.fromJson(Map<String, dynamic> json) {
    return ReadingItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      level: (json['level'] ?? '').toString(),
      author: (json['author'] ?? '').toString(),
      minutes: int.tryParse((json['minutes'] ?? '0').toString()) ?? 0,
      summary: (json['summary'] ?? '').toString(),
      assetPath: (json['assetPath'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      sourceName: (json['sourceName'] ?? '').toString(),
      publishedAt: (json['publishedAt'] ?? '').toString(),
    );
  }
}
