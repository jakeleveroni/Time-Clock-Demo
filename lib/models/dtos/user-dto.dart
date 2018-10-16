import "package:cloud_firestore/cloud_firestore.dart";

class UserDto {
  String userName;
  String email;
  String uid;
  String phoneNumber;
  String profileImageUrl;

  UserDto(this.userName, this.email, this.uid, {String phone = '', String imageUrl = ''}) {
    this.phoneNumber = phone;
    this.profileImageUrl = imageUrl;
  }

  UserDto.fromDocument(DocumentSnapshot snapshot) {
    this.userName = snapshot['userName'];
    this.email = snapshot['email'];
    this.uid = snapshot['uid'];
    this.phoneNumber = snapshot['phoneNumber'];
    this.profileImageUrl = snapshot['profileImageUrl'];
  }

  Map<String, dynamic> toDocument() {
    return {
      'userName': this.userName,
      'email': this.email,
      'uid': this.uid,
      'phoneNumber': this.phoneNumber,
      'profileImageUrl': this.profileImageUrl
    };
  }
}