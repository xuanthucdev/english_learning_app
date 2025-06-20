class FileResponse {
  final String id;
  final String filename;
  final String originalFilename;
  final String contentType;
  final int size;
  final String url;

  FileResponse({
    required this.id,
    required this.filename,
    required this.originalFilename,
    required this.contentType,
    required this.size,
    required this.url,
  });

  factory FileResponse.fromJson(Map<String, dynamic> json) {
    return FileResponse(
      id: json['id'].toString(),
      filename: json['filename'],
      originalFilename: json['originalFilename'],
      contentType: json['contentType'],
      size: json['size'],
      url: json['url'],
    );
  }
}
