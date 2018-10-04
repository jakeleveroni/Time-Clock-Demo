class UserDto {
  String userName;
  String email;
  String uid;

  UserDto(this.userName, this.email, this.uid);

  Map<String, dynamic> toDocument() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid
    };
  }
}