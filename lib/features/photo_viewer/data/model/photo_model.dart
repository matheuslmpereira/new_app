class PhotoModel {
  final String id;
  final String url;
  final String description;

  PhotoModel({
    required this.id,
    required this.url,
    required this.description,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      url: json['urls']['small'] as String,
      description: json['description'] as String? ?? 'No Description',
    );
  }
}
