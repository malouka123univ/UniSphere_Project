class AnnouncementModel {
  final int id;
  final String title;
  final String body;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
  });

  /// JSON (Map) → Object
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Object → JSON (Map)
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body};
  }
}
