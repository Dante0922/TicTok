import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom.dart';

class ChatroomsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatroom(ChatroomModel data) async {
    //_db.collection("chat_rooms").add(data.toJson());
    _db.collection("chat_rooms").doc("${data.personA}000${data.personB}").set({
      "createdAt": DateTime.now().microsecondsSinceEpoch,
      "personA": data.personA,
      "personB": data.personB
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatrooms(String uid) {
    final query =
        _db.collection("users").doc(uid).collection("chat_rooms").get();
    return query;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> findChatroomId(
      String chatroomId) async {
    final query = _db.collection("chat_rooms").doc(chatroomId).get();

    return query;
  }
}

final chatroomsRepo = Provider((ref) => ChatroomsRepo());
