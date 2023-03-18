import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Initial Text");

  late final TabController _tabBarController;

  String _searchText = "";

  void _onSearchChanged(String value) {
    print(value);
  }

  void _onSearchSubmitted(String value) {
    print(value);
  }

  void _deleteText() {
    setState(() {
      _textEditingController.text = "";
    });
  }

  @override
  void initState() {
    _tabBarController = TabController(length: tabs.length, vsync: this);
    _textEditingController.addListener(() {
      setState(() {
        _searchText = _textEditingController.text;
      });
    });
    _tabBarController.addListener(_focusOut);
    super.initState();
  }

  void _focusOut() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).platformBrightness //Dart모드인지 확인
    // MediaQuery.of(context).padding // 가려지고 있는 부분 확인
    // MediaQuery.of(context).orientation //화면 방향 확인
    final width =
        MediaQuery.of(context).size.width; // 웹의 사이즈를 실시간으로 알 수 있다. 반응형 웹을 만들자.
    print(width);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // 키보드를 열면 스캐폴드가 자동으로 리사이징하는 것을 방지.
        appBar: AppBar(
          elevation: 1,
          // title: CupertinoSearchTextField(
          //   //애플 방식의 서치바
          //   controller: _textEditingController,
          //   onChanged: _onSearchChanged, //글이 바뀔 대마다 실행
          //   onSubmitted: _onSearchSubmitted, // 제출될 때마다 실행
          //   style: TextStyle(
          //     color: isDarkMode(context) ? Colors.white : Colors.black,
          //   ),
          // ),
          title: ConstrainedBox(
            // 검색창의 반응형웹 변경을 위해 ConstrainedBox를 통해 최대 크기를 정해줄 수 있다.
            // constraints에 원하는 값을 넣어주면 된다.
            // 참고로 Container를 사용 중이라면 ConstrainedBox를 쓸 필요 없이 바로 constraints를 지정하면 된다.
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                ),
                Gaps.h10,
                Expanded(
                  child: SizedBox(
                    height: Sizes.size56,
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      style: TextStyle(
                        color:
                            isDarkMode(context) ? Colors.white : Colors.black,
                      ),
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          // 인풋박스 테투리 위젯
                          borderRadius: BorderRadius.circular(
                            Sizes.size8,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDarkMode(context)
                            ? Colors.grey.shade600
                            : Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size5,
                          vertical: Sizes.size5,
                        ),
                        prefixIcon: Container(
                          width: Sizes.size20,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            right: Sizes.size4,
                            left: Sizes.size10,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        suffixIcon: AnimatedOpacity(
                          opacity: _textEditingController.text.isEmpty ? 0 : 1,
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          child: GestureDetector(
                            onTap: _deleteText,
                            child: Container(
                              width: Sizes.size20,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                right: Sizes.size14,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidCircleXmark,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            //앱바의 바텀에 TabBar를 선언할 수 있다.
            controller: _tabBarController,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true, //탭바의 스크롤 기능
            splashFactory: NoSplash.splashFactory, //탭바를 눌렀을 때 이펙트
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,

            labelStyle: const TextStyle(
              // 라벨(탭명)의 색상
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          //탭바의 뷰. 탭을 누르면 각 뷰가 표기됨.
          controller: _tabBarController,
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                  .onDrag, // 그리드를 드래그하면 키보드가 자동으로 사라진다.
              // ListView와 비슷한 위젯. 그리드뷰를 만들어 준다. 성능을 위해 builder를 써주자.
              padding: const EdgeInsets.all(
                Sizes.size6,
              ),
              itemCount: 20, //그리드 아이템의 갯수
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // Controller와 비슷한 역할이다. 이를 통해 컨트롤 가능.
                // 추후에 Sliver에 대해 다시 배운다.
                crossAxisCount:
                    width > Breakpoints.lg ? 5 : 2, // width 와 BP를 비교하여 반응형으로 설정
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio:
                    9 / 20, // 그리드의 비율. 그림은 9/16. 4를 추가하여 텍스트 자리를 만들었다.
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                      // 이것만 한다면 사진이 콘테이너를 초과하기 때문에 효과가 안 먹는다. clipBehavior도 해줘야 함.
                      Sizes.size4,
                    )),
                    child: AspectRatio(
                      //자식의 면 비율을 결정해주는 위젯 부모는 9/20이고 이것은 9/16이라 남는 9/4에 텍스트를 채운다는 개념.
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                        // 이미지를 네트워크에서 불러오지만 불러올 때까지는 placeholder에 있는 이미지로 임시 대체하는 위젯.
                        fit: BoxFit.cover, // 불러온 이미지가 어떻게 채워질 것인지 정하는 옵션
                        placeholder: "assets/images/Cream.jpeg",
                        image:
                            "https://images.unsplash.com/photo-1677533485266-23f7ea336852?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      ),
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "This is a very long caption for my tiktok that im upload just now currently",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.bold,
                      height: 1, // 글씨 상하 간격
                    ),
                    maxLines: 2, // 텍스트 위젯의 최대 라인 제약 기능.
                    overflow: TextOverflow
                        .ellipsis, // 출력 결과를 초과하는 값에 대해 처리하는 옵션. 이 옵션은 ...으로 표기
                  ),
                  Gaps.v8,
                  if (constraints.maxWidth < 100 || constraints.maxWidth > 150)
                    // 각 Container는 Web의 크기와 상관없이 작을 수 있다. 이럴 경우 LayoutBuiler를 통해
                    // 세부 내용을 조절해주는 것이 좋다.
                    DefaultTextStyle(
                      // 자식들의 모든 TextStyle를 지정하는 위젯
                      style: TextStyle(
                        color: isDarkMode(context)
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            //동그란 아바타를 만드는 위젯
                            radius: 12,
                            backgroundImage: NetworkImage(
                                // 네트워크에서 이미지를 가져오는 옵션.
                                "https://avatars.githubusercontent.com/u/101305519?v=4"),
                          ),
                          Gaps.h4,
                          const Expanded(
                            // Expanded는 로우 안에서만 확보할 수 있는 가장 큰 공간을 확보한다.
                            child: Text(
                              "My avatar is going to be very long",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gaps.v4,
                          FaIcon(
                            FontAwesomeIcons.heart,
                            size: Sizes.size16,
                            color: Colors.grey.shade600,
                          ),
                          Gaps.h2,
                          const Text(
                            "2.5M",
                          )
                        ],
                      ),
                    )
                ]),
              ),
            ),
            for (var tab in tabs.skip(1)) //따로 만든 첫번째(Top)는 생략
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: Sizes.size32,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
