import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  //ticker는 굉장히 많은 리소스를 사용한다. 이 위젯을 쓰면 애니메이션이 없을 때 리소스를 사용하지 않는다.
  //List.generate를 활용하면 리스트를 원하는 갯수만큼 만들 수 있다.
  final List<String> _notifications = List.generate(20, (index) => "${index}h");
  // 원래 this는 initState가 실행 된 이후 사용할 수 있지만, late를 사용하면
  // 자동으로 initState 후에 이 변수를 지정해주는 효과를 준다.
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  final List<Map<String, dynamic>> _tabs = [
    // Map List를 만들어 활용
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  bool _showBarrier = false;

  // 아래와 같이 애니메이션을 만들면 animation.Builder 혹은 setState가 필요없다
  late final Animation<double> _arrowAnimation =
      Tween(begin: 0.0, end: 0.5) // 애니메이션의 Turn 각도. 0도에서 180도까지 작동.
          .animate(_animationController); //애니메이션을 컨트롤러에 연결함.

  late final Animation<Offset> _panelAnimation = Tween(
    // Tween은 직선으로 가는 애니메이션
    begin: const Offset(0, -1), // 픽셀이 아닌 비율이다. vertical -1 으로 화면 밖에 숨겨둔다.
    end: Offset.zero, // 0, 0 으로 불러온다
  ).animate(_animationController);

  late final Animation<Color?> _barrierAnimations = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  void _onDismissed(String notification) {
    // Dismiss를 하더라도 랜더링 된 아이템은 남아 있어 에러를 유발한다
    // 이를 방지하기 위해 Dismissible의 onDismissed가 실행될 때마다 리스트에 그 아이템을 지우고 다시 빌드해준다.
    _notifications.remove(notification);
    setState(() {});
  }

  void _onTitleTap() async {
    if (_animationController.isCompleted) {
      await _animationController.reverse();
      // showBarrier은 T/F값에 따라 바로 바뀌고 있다. reverse할 때 슬라이드바는 천천히 올라가는데
      // 배리어는 바로 꺼지는 것을 방지하기 위해 await를 활용하면 된다. 이는 reverse가 future를 반환하기 때문에 가능하다.
    } else {
      _animationController.forward(); // 애니메이션 플레이
    }
    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isdark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("All activity"),
              Gaps.h2,
              RotationTransition(
                //방향을 돌려주는 애니메이션
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Gaps.v14,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size12,
                ),
                child: Text(
                  "New",
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Gaps.v14,
              for (var notification in _notifications)
                Dismissible(
                  // 아이템이 사라지도록 만들어주는 위젯. 굉장히 유용
                  onDismissed: (direction) => _onDismissed(notification),
                  key: Key(notification),
                  background: Container(
                    // 오른쪽으로 쓸어넘겼을 떄 보여주는 백그라운드
                    alignment: Alignment.centerLeft, // 컨테이너 안의 아이템들을 정렬해주는 옵션
                    color: Colors.green,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    // 왼쪽으로 쓸어넘겼을 때 보여주는 백그라운드
                    alignment: Alignment.centerRight, // 컨테이너 안의 아이템들을 정렬해주는 옵션
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        right: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  child: ListTile(
                    //contentPadding: EdgeInsets.zero, // 컨텐츠의 패딩은 0으로 만들어줌.
                    minVerticalPadding: Sizes.size16, //
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isdark ? Colors.grey.shade800 : Colors.white,
                        border: Border.all(
                          color: isdark
                              ? Colors.grey.shade800
                              : Colors.grey.shade400,
                          width: Sizes.size1,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                        ),
                      ),
                    ),
                    title: RichText(
                      // 풍푸한 텍스트 표현을 가능하도록 돕는 위젯.
                      text: TextSpan(
                        // JS의 <Span> 같은 역할을 하는 위젯
                        text: "Account updates",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isdark ? null : Colors.black,
                          fontSize: Sizes.size16,
                        ),
                        children: [
                          const TextSpan(
                            text: " Upload longer videos",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: Sizes.size16,
                            ),
                          ),
                          TextSpan(
                            text: " $notification",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size16,
                    ),
                  ),
                )
            ],
          ),
          if (_showBarrier) // collection if
            AnimatedModalBarrier(
              // 아래에 있는 위젯이 안 눌리도록 해주는 위젯
              // 코드 순서에 따라 위젯의 위아래가 결정된다.
              // 배리어 아래의 위젯은 배리어보다 위에 있다.
              color: _barrierAnimations,
              dismissible: true, // 사라질 수 있도록
              onDismiss:
                  _onTitleTap, // 배리어를 누르면 애니메이션동작을 다시 수행해서 패널과 슬라이드팝업이 사라지도록
            ),
          SlideTransition(
            // 슬라이드 애니메이션 위젯
            position: _panelAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    Sizes.size5,
                  ),
                  bottomRight: Radius.circular(
                    Sizes.size5,
                  ),
                ),
              ),
              child: Column(
                // Column과 Row는 사용할 수 있는 가장 많은 상하/좌우의 영역을 차지한다.
                mainAxisSize: MainAxisSize.min, // 그렇기 때문에 이 옵션으로 막아줘야 함.
                children: [
                  for (var tab in _tabs) //collection for
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab["icon"],
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
