import 'package:uuid/uuid.dart';

class Message {
  Uuid uid;
  String senderId;
  String receiverId;
  DateTime sentTime;
  DateTime receivedTime;
  String contents;

  Message(this.senderId, this.receiverId, this.contents) {
    uid = new Uuid();
    sentTime = new DateTime.now();
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid.toString(),
      'senderId': senderId,
      'receieverId': receiverId,
      'sentTime': sentTime,
      'receivedTime': receivedTime,
      'contents': contents
    };
  }
}