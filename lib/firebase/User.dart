class ChatUser {
  String uid;
  String name;
  String email;
  String photo;
  bool verified;
  bool online;
  ChatUser(
      {this.email,
      this.name,
      this.photo,
      this.uid,
      this.verified,
      this.online});

  ChatUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    photo = json['photoUrl'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'photoUrl': photo,
        'name': name,
      };
}
