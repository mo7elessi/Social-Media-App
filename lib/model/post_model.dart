class PostModel {
  late String id;
  late String username;
  late String userImage;
  late String text;
  late String image;
  late String dateTime;
  late int likes;
  late int comments;

  PostModel({
    required this.id,
    required this.username,
    required this.userImage,
    required this.text,
    required this.image,
    required this.dateTime,
    required this.likes,
    required this.comments,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    username = json['username'];
    userImage = json['userImage'];
    text = json['text'];
    image = json['image'];
    dateTime = json['dateTime'];
    likes = json['likes'];
    comments = json['comments'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userImage': userImage,
      'text': text,
      'image': image,
      'dateTime': dateTime,
      'like': likes,
      'comment': comments,
    };
  }
}
