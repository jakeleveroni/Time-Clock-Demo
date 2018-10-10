import 'package:uuid/uuid.dart';

class Message {
  String uid;
  String senderId;
  String receiverId;
  DateTime sentTime;
  DateTime receivedTime;
  String contents;

  Message(this.senderId, this.receiverId, this.contents) {
    uid = Uuid().v4();
    sentTime = new DateTime.now();
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'senderId': senderId,
      'receieverId': receiverId,
      'sentTime': sentTime,
      'receivedTime': receivedTime,
      'contents': contents
    };
  }
}