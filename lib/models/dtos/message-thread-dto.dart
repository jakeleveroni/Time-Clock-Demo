import 'package:uuid/uuid.dart';

class MessageThread {
  String uid;
  List<String> messages;

  MessageThread(this.messages) {
    uid = new Uuid().v4();
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'messages': messages
    };
  }
}