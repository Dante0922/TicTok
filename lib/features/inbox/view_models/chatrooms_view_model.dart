import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom.dart';
import 'package:tiktok_clone/features/inbox/repos/chatrooms_repo.dart';

class ChatroomsViewModel extends AsyncNotifier<List<ChatroomModel>> {
  List<ChatroomModel> _list = [];
  late final ChatroomsRepo _chatroomsRepo;

  @override
  FutureOr<List<ChatroomModel>> build() async {
    _chatroomsRepo = ref.read(chatroomsRepo);
    final user = ref.read(authRepo).user;
    _list = await _fetchChatrooms(user!.uid);
    return _list;
  }

  Future<List<ChatroomModel>> _fetchChatrooms(String uid) async {
    final result = await _chatroomsRepo.fetchChatrooms(uid);
    final chats = result.docs.map(
      (doc) => ChatroomModel.fromJson(
        doc.data(),
      ),
    );
    return chats.toList();
  }

  Future<void> makeChatroom(String opponentUid) async {
    final userUid = ref.read(authRepo).user!.uid;
    final chatroom = ChatroomModel(personA: userUid, personB: opponentUid);
    ref.read(chatroomsRepo).createChatroom(chatroom);
  }

  Future<String> findChatroomId(String personA, String personB) async {
    final id1 = "${personA}000$personB";
    final id2 = "${personB}000$personA";
    final chatroomid = await ref.read(chatroomsRepo).findChatroomId(id1);

    if (chatroomid.data() != null) {
      return id1;
    } else {
      return id2;
    }
  }
}

final chatroomsProvider =
    AsyncNotifierProvider<ChatroomsViewModel, List<ChatroomModel>>(
  () => ChatroomsViewModel(),
);
