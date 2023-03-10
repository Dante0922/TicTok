import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

void main() {
  runApp(const TicTokApp());
}

class TicTokApp extends StatelessWidget {
  const TicTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTok Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(
              0xFFE9435A), //쿠퍼티노서치 같은 위젯은 기본 커서컬러가 안 바뀌지만, main.dart에서 이런 방식으로 기본 색상을 지정해줄 순 있다.
        ),
        splashColor:
            Colors.transparent, //버튼을 눌렀을 때 퍼지는 Splash효과를 막고 싶다면 이 옵션을 지정해주면 된다.
        // highlightColor: Colors.transparent,  꾹 눌렀을 때 나타나는 색상변화를 없애고 싶다면 이 옵션을 설정.
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
