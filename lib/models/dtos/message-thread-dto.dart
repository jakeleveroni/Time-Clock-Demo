import 'package:uuid/uuid.dart';

class MessageThread {
  Uuid uid;
  List<String> messages;

  MessageThread(this.messages) {
    uid = new Uuid();
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'messages': messages
    };
  }
}