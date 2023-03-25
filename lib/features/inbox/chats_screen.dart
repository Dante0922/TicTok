import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = "chats";
  static const routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // 키는 좀 더 공부해보자.
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = []; //각 메세지의 순서가 유지되도록 가상 리스트를 생성
  final Duration _duration = const Duration(milliseconds: 300);

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length, // 리스트의 길이를 인설트. 키를 인설트하면 built가 실행되는듯?
        duration: _duration,
      );
      _items.add(
        //아이템리스트에도 똑같이 인설트하여 동기화
        _items.length,
      );
    }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        // removeItem은 index를 바탕으로 아이템을 없앤다.
        // 그 과정에서 animation 효과를 줄 수 있다.
        // 아래 방법은 기존과 똑같지만 바탕만 red인 타일을 하나 생성하고 사라지는 애니메이션을 주어 착시효과를 준다.
        index,
        (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: Container(color: Colors.red, child: _makeTile(index))),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap(int index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const ChatDetailScreen(),
    //   ),
    // );
  }

  Widget _makeTile(int index) {
    // ListTile를 공용으로 쓸 수 있도록 함수화
    return ListTile(
      onLongPress: () => _deleteItem(index), //롱프레스는 삭제함수 발동. index를 넣어준다.
      onTap: () => _onChatTap(index), //온탭 채팅디테일로 이동
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/101305519?v=4"),
        child: Text("쿨미"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Kream ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            //trailing은 자동으로 중앙에 정렬된다.  Row를 활용하면 trailing과는 다른 위치에 정렬시킬 수 있다.
            "2:16 PM",
            style: TextStyle(
              fontSize: Sizes.size12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      subtitle: const Text(
        "Don't forget to make video",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Dairect messages'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: AnimatedList(
        key: _key, // 리스트의 Key. Key개념은 좀 더 공부해봐야 할 거 같다.
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            // 페이드 효과를 주는 위젯
            key: UniqueKey(), // 각 타일들이 헷갈리지 않도록 유니크 키를 준다.
            opacity: animation,
            child: SizeTransition(
              // 사이즈를 애니메이션 해주는 위젯
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
