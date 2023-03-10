import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  void _onDmPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatsScreen(),
      ),
    );
  }

  void _onActivityTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ActivityScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Inbox"),
        actions: [
          IconButton(
            onPressed: _onDmPressed,
            icon: const FaIcon(
              FontAwesomeIcons.paperPlane,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            // 리스트타일은 아주 활용도가 높은 위젯. 꼭 복습해보자.
            onTap: _onActivityTap, // 함수도 바로 넣을 수 있고
            title: const Text(
              //타이틀을 설정할 수도
              'Activity',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size14,
              ),
            ),
            trailing: const FaIcon(
              //마지막에 배치할 아이콘을 만들 수도 있다.
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.black,
            ),
          ),
          Container(
            //리스트타일 사이에 구분자를 넣어주는 콘테이너. ListTile.seperated를 사용해서 대체할 수 있다.
            height: Sizes.size1,
            color: Colors.grey.shade200,
          ),
          ListTile(
            leading: Container(
              //맨 앞에 오는 아이콘
              width: Sizes.size52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.users,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              'New followers',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size14,
              ),
            ),
            subtitle: const Text(
              "Messages from followers will appear here",
              style: TextStyle(
                fontSize: Sizes.size14,
              ),
            ), // 서브타이틀은 자동으로 회색의 작은 글씨로 설정된다.
            trailing: const FaIcon(
              // 트레일링은 ListTile의 가장 오른 쪽에 나온다.
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
