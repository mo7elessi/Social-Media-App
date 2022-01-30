class UserModel {
  String? id;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? bio;
  String? image;
  bool? isEmailVerified;

  UserModel(
      {this.id,
      required this.username,
      this.email,
      required this.isEmailVerified,
      this.phone,
      this.address,
      this.bio,
      this.image});


  UserModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    bio = json['bio'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'phone': phone,
      'address': address,
      'bio': bio,
      'image': image,
    };
  }
}
