class VideoModel {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creater;
  final int likes;
  final int comments;
  final int createdAt;
  final String creatorUid;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.likes,
    required this.creater,
    required this.comments,
    required this.createdAt,
    required this.creatorUid,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "likes": likes,
      "creater": creater,
      "comments": comments,
      "creatorUid": creatorUid,
      "createdAt": createdAt,
    };
  }

  //fromJson constructure
  VideoModel.fromJson(
      {required Map<String, dynamic> json, required String videoId})
      : id = videoId,
        title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        likes = json["likes"],
        creater = json["creater"],
        comments = json["comments"],
        creatorUid = json["creatorUid"],
        createdAt = json["createdAt"];
}
