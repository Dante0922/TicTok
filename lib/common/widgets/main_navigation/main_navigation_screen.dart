import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';

import 'package:tiktok_clone/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/user/views/user_profile_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_timeline_screen.dart';

import 'package:tiktok_clone/utils.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeName = "MainNavigation";
  final String tab;
  const MainNavigationScreen({super.key, required this.tab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxx",
    "inbox",
    "profile",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  final screens = [
    const Center(
      child: Text("Home"),
    ),
    const Center(
      child: Text("Discover"),
    ),
    Container(),
    const Center(
      child: Text("Inbox"),
    ),
    const Center(
      child: Text("Profile"),
    ),
  ];

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  void _onPostVideoButtonTap(BuildContext context) {
    context.pushNamed(VideoRecordingScreen.routeName);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Scaffold(
    //       appBar: AppBar(
    //         title: const Text('Record Video'),
    //       ),
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false, // flutter는 키보드가 나타날 떄 자동으로 body를 축소시킨다.
      //이를 방지하기 위해 false를 해주면 키보드가 화면을 가리는 형태가 된다.
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            //Offstage는 네비게이터의 여러 탭을 한번에 구동시킨다. 이와 같이 처리해야 다른 탭에 갔다가 와도 캐시가 유지된다.
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(
              username: "크림",
              tab: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.only(
          bottom: Sizes.size32,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            Sizes.size12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                selectedIndex: _selectedIndex,
                onTap: () => _onTap(
                    0), //widget을 만들어서 onTap을 required로 지정해뒀다. _onTap(0)을 실행시킴.
              ),
              NavTab(
                text: "Discover",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                selectedIndex: _selectedIndex,
                onTap: () => _onTap(1),
              ),
              Gaps.h24,
              PostVideoButton(
                onTapFunction: _onPostVideoButtonTap,
                inverted: _selectedIndex != 0,
              ),
              Gaps.h24,
              NavTab(
                text: "Inbox",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                selectedIndex: _selectedIndex,
                onTap: () => _onTap(3),
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                selectedIndex: _selectedIndex,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
