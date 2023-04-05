import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message, String chatroomId) async {
    await _db
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("texts")
        .add(message.toJson());
  }

  Future<void> deleteMessage(MessageModel message, String chatroomId) async {
    // firebase 는 where & update 기능이 없다.. 따라서 먼저 where를 찾고 forEach로 update를 돌려줘야 한다.
    final result = await _db
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("texts")
        .where('createdAt', isEqualTo: message.createdAt)
        .get();
    for (var element in result.docs) {
      element.reference.update({"text": "deleted"}); // 와우우우,,
    }

    //  result.get().then((value) => print(value.docs));
    // await target.update("texts", (value) => "deleted");
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());
