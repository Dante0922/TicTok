import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL =
      ":chatId"; // child 경로를 만들기 위한 주소. 자식URL은 "/"를 쓰면 안 된다.
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  void _onsendPress() {
    final text = _textEditingController.text;
    if (text == "") return;
    ref.read(messageProvider.notifier).sendMessage(text);
    _textEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messageProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size5, //leading 과 title 등 내부의 간격을 설정
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/101305519?v=4"),
                child: Text('크림'),
              ),
              Positioned(
                // Stack 내에서 Positioned를 통해 위젯을 원하는 위치에 배치할 수 있따.
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size16,
                  height: Sizes.size16,
                  padding: const EdgeInsets.all(
                    Sizes.size6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      // Border을 통해서 보더 자체의 색상이나 크기를 조정할 수 있다.
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Sizes.size24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "크림 (${widget.chatId})",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size16,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size16,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider).when(
                error: (error, stackTrace) => Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                data: (data) {
                  return ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.only(
                      top: Sizes.size20,
                      bottom:
                          MediaQuery.of(context).padding.bottom + Sizes.size96,
                      right: Sizes.size14,
                      left: Sizes.size14,
                    ),
                    itemBuilder: (context, index) {
                      final message = data[index];
                      var isMine =
                          message.userId == ref.watch(authRepo).user!.uid;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment
                                .start, // isMine에 따라 채팅을 좌우로 나눠서 배치하고 있다.
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              Sizes.size14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(Sizes.size20),
                                topRight: const Radius.circular(Sizes.size20),
                                bottomLeft: Radius.circular(
                                  isMine ? Sizes.size20 : Sizes.size5,
                                ),
                                bottomRight: Radius.circular(
                                  isMine ? Sizes.size5 : Sizes.size20,
                                ),
                              ),
                              color: isMine
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Gaps.v10,
                    itemCount: data.length,
                  );
                },
              ),
          Positioned(
            // 텍스트필드는 나중에 시간이 나면 추가로 개발해보자.
            bottom: 0,
            width: MediaQuery.of(context).size.width, //기기의 width를 받아오는 위젯
            child: BottomAppBar(
                color: Colors.grey.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                      ),
                    ), // TextField는 항상 width를 가져야 한다. Exapnded로 감싸주자
                    Gaps.h20,
                    IconButton(
                      onPressed: isLoading ? null : _onsendPress,
                      icon: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.paperPlane,
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
