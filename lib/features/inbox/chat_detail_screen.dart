import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
          title: const Text(
            "크림",
            style: TextStyle(
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
          ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size20,
                horizontal: Sizes.size14,
              ),
              itemBuilder: (context, index) {
                var isMine = index % 2 == 0;
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
                      child: const Text(
                        "This is a message!",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10),
          Positioned(
            // 텍스트필드는 나중에 시간이 나면 추가로 개발해보자.
            bottom: 0,
            width: MediaQuery.of(context).size.width, //기기의 width를 받아오는 위젯
            child: BottomAppBar(
                color: Colors.grey.shade50,
                child: Row(
                  children: [
                    const Expanded(
                        child:
                            TextField()), // TextField는 항상 width를 가져야 한다. Exapnded로 감싸주자
                    Gaps.h20,
                    Container(
                      child: const FaIcon(
                        FontAwesomeIcons.paperPlane,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
