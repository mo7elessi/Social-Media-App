class CommentModel {
  String? userId;
  String? postId;
  String? userImage;
  String? userName;
  String? dateTime;
  String? text;

  CommentModel({
    required this.userId,
    required this.userImage,
    required this.dateTime,
    required this.text,
    required this.postId,
    required this.userName,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userImage = json['userImage'];
    dateTime = json['dateTime'];
    text = json['text'];
    postId = json['postId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userImage': userImage,
      'dateTime': dateTime,
      'text': text,
      'postId': postId,
      'userName': userName,
    };
  }
}
