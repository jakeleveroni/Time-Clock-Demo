class UserDto {
  String userName;
  String email;
  String uid;
  String phoneNumber;
  String profileImageUrl;
  List<String> messageThreadRefs;
  List<String> timerRefs;

  UserDto(this.userName, this.email, this.uid);

  Map<String, dynamic> toDocument() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
      'messageThreadRefs': messageThreadRefs,
      'timerRefs': timerRefs
    };
  }
}