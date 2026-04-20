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
  /// // Convertit le format JSON (Map) venant d'Internet en un objet Dart utilisable.
  // C'est ici qu'on "traduit" les données brutes pour l'application.
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
