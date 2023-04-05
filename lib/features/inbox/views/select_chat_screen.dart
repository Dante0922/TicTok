import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/inbox/view_models/chatrooms_view_model.dart';
import 'package:tiktok_clone/features/user/view_models/userList_view_model.dart';

class SelectChatScreen extends ConsumerStatefulWidget {
  static const String routeName = "selectChat";
  static const String routeUrl = "/selectChat";
  const SelectChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectChatScreenState();
}

class _SelectChatScreenState extends ConsumerState<SelectChatScreen> {
  void _makeRoom(String uid) {
    ref.read(chatroomsProvider.notifier).makeChatroom(uid);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userListProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) {
            return Scaffold(
              body: ListView.separated(
                  itemBuilder: (context, index) {
                    final user = data[index];
                    return GestureDetector(
                      onTap: () => _makeRoom(user.uid),
                      child: Row(
                        children: [
                          const CircleAvatar(),
                          Gaps.h20,
                          Text(user.email)
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gaps.v32,
                  itemCount: data.length),
            );
          },
        );
  }
}
