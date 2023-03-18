import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/utils.dart';

// enum Page.first처럼 지정된 내역만 사용할 수 있도록 제어를 도와주는 기능.
enum Direction { right, left }

enum Page { first, second }

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  Direction _direction = Direction.right;
  Page _showingPage = Page.first;

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      //x축 이동 값을 측정한다. 0보다 크면 오른쪽
      //to the right
      setState(() {
        _direction = Direction.right;
      });
    } else {
      //to the left
      setState(() {
        _direction = Direction.left;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_direction == Direction.left) {
      //포인터 이동이 끝났을 때 끝난 값에 따라 Page를 지정하고 setState
      setState(() {
        _showingPage = Page.second;
      });
    } else {
      setState(() {
        _showingPage = Page.first;
      });
    }
  }

  void _onEnterAppTap() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ), (route) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate, //드래그하는 값이 업데이트될 때 실행되는 함수
      onPanEnd: _onPanEnd, //드래그가 끝날 때 실행되는 함수
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size24,
          ),
          child: SafeArea(
            child: AnimatedCrossFade(
              //자식들이 Fade-in / Fade-out으로 교차하면서 나타하게 하는 위젯.
              firstChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Gaps.v80,
                  Text(
                    "Watch cool videos",
                    style: TextStyle(
                      fontSize: Sizes.size32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v16,
                  Text(
                    "Videos are personalized for you based on what you watch, like, and share.",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                    ),
                  ),
                ],
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Gaps.v80,
                  Text(
                    "Follow the rules",
                    style: TextStyle(
                      fontSize: Sizes.size32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v16,
                  Text(
                    "Take care of one another! Plis!",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                    ),
                  ),
                ],
              ),
              crossFadeState: _showingPage == Page.first
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(
                milliseconds: 300,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: isDarkMode(context) ? Colors.black : Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size32,
              bottom: Sizes.size64,
              left: Sizes.size24,
              right: Sizes.size24,
            ),
            child: AnimatedOpacity(
              //애니메이션과 함께 나타나게 해주는 위젯
              duration: const Duration(milliseconds: 1000),
              opacity: _showingPage == Page.first ? 0 : 1,
              child: CupertinoButton(
                //애플 스타일의 버튼. 이쁘다.
                color: Theme.of(context).primaryColor,
                onPressed: _onEnterAppTap,
                child: const Text("Enter the App!"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
