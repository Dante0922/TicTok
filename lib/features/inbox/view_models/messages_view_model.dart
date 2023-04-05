import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessageViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;
  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text, String chatroomId) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _repo.sendMessage(message, chatroomId);
    });
  }

  Future<void> deleteMessage(MessageModel message, String chatroomId) async {
    print("heeeeeeeellllooo??");
    await _repo.deleteMessage(message, chatroomId);
  }
}

final messageProvider = AsyncNotifierProvider<MessageViewModel, void>(
  () => MessageViewModel(),
);

// StreamProvider는 backend의 정보를 항상 listen하고 변화할 때마다 결과값을 반환해준다.
// 항상 켜져있기 때문에 autoDispose를 통해 불필요시 자동종료될 수 있도록 달아주어야 한다!
final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatroomId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("chat_rooms")
      .doc(chatroomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots() //stream을 반환하는 snapshots(). 변경사항이 있을 때마다 값을 반환한다.
      .map(
        (event) => event.docs // array를 다른 형태의 array로 바꿔주는 map()
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(), // map를 두번 돌리면서 Stream -> List. Json -> MessageModel로 변환함.
              ),
            )
            .toList() // 다시 리스트로 묶어서 반환
            .reversed // 텍스트를 거꾸로 가져오기 위해
            .toList(),
      );
});
