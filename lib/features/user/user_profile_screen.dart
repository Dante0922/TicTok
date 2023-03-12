import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/user/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // NestedScrollView 는 중첩된 스크롤뷰를 하나의 스크롤처럼 만들어 준다.
          // headerSliverBuilder를 통해 머리부분을 만들고
          // body에 그리드 뷰를 넣어주었다.

          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              //Slvier끼리는 부모자식 관계가 되지 못한다. 형제 관계로 []안에 넣어주어야 함.
              SliverAppBar(
                title: const Text("크림"),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.gear,
                      size: Sizes.size20,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/101305519?v=4"),
                      child: Text("크림"),
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "@크림",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size16,
                          ),
                        ),
                        Gaps.h5,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Gaps.v24,
                    SizedBox(
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "97",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v3,
                              Text(
                                "Following",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            // 세로선으로 구분자를 만들어주는 위젯. father의 높이를 가져오기 때문에 father의 높이가 설정되어 있어야 한다.
                            width: Sizes.size32, // 구분공간의 크기
                            thickness: Sizes.size1, // 구분선의 굵기
                            indent: Sizes.size14, // father높이의 얼마부터 시작할 것인지
                            endIndent: Sizes.size14, // father높이의 얼마전에 끝날 것인지
                            color: Colors.grey.shade400,
                          ),
                          Column(
                            children: [
                              const Text(
                                "10.4M",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v3,
                              Text(
                                "Followers",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            // 세로선으로 구분자를 만들어주는 위젯. father의 높이를 가져오기 때문에 father의 높이가 설정되어 있어야 한다.
                            width: Sizes.size32, // 구분공간의 크기
                            thickness: Sizes.size1, // 구분선의 굵기
                            indent: Sizes.size14, // father높이의 얼마부터 시작할 것인지
                            endIndent: Sizes.size14, // father높이의 얼마전에 끝날 것인지
                            color: Colors.grey.shade400,
                          ),
                          Column(
                            children: [
                              const Text(
                                "194.3M",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v3,
                              Text(
                                "Likes",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    FractionallySizedBox(
                      // father의 높이와 너비를 가져옴
                      widthFactor: 0.65, // father의 width의 60%만 차지
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    Sizes.size4,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Gaps.h4,
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    Sizes.size1,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const FaIcon(
                                FontAwesomeIcons.youtube,
                              ),
                            ),
                          ),
                          Gaps.h4,
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    Sizes.size1,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const FaIcon(
                                FontAwesomeIcons.angleDown,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.size32),
                      child: Text(
                        'All highlights and wher to watch live matches on FIFA+ I wonder how it would look',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size10,
                        ),
                        Gaps.h4,
                        Text(
                          "https://nomadcoder.co",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v20,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: PersistentTabBar(), // delegate를 통해 탭바를 build한다.
                pinned: true, // 상단에 고정.
              ),
            ];
          },
          body: TabBarView(children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                  .onDrag, // 그리드를 드래그하면 키보드가 자동으로 사라진다.
              // ListView와 비슷한 위젯. 그리드뷰를 만들어 준다. 성능을 위해 builder를 써주자.
              padding: EdgeInsets.zero,
              itemCount: 20, //그리드 아이템의 갯수
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // Controller와 비슷한 역할이다. 이를 통해 컨트롤 가능.
                // 추후에 Sliver에 대해 다시 배운다.
                crossAxisCount: 3, // 한줄에 2개
                crossAxisSpacing: Sizes.size2,
                mainAxisSpacing: Sizes.size2,
                childAspectRatio:
                    9 / 14, // 그리드의 비율. 그림은 9/16. 4를 추가하여 텍스트 자리를 만들었다.
              ),
              itemBuilder: (context, index) => Column(children: [
                Stack(
                  children: [
                    AspectRatio(
                      //자식의 면 비율을 결정해주는 위젯 부모는 9/20이고 이것은 9/16이라 남는 9/4에 텍스트를 채운다는 개념.
                      aspectRatio: 9 / 14,
                      child: FadeInImage.assetNetwork(
                        // 이미지를 네트워크에서 불러오지만 불러올 때까지는 placeholder에 있는 이미지로 임시 대체하는 위젯.
                        fit: BoxFit.cover, // 불러온 이미지가 어떻게 채워질 것인지 정하는 옵션
                        placeholder: "assets/images/Cream.jpeg",
                        image:
                            "https://images.unsplash.com/photo-1677533485266-23f7ea336852?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      ),
                    ),
                    Positioned(
                      left: 4,
                      bottom: 0,
                      child: Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.caretRight,
                            color: Colors.white,
                            size: Sizes.size20,
                          ),
                          Gaps.h4,
                          Text(
                            "4.1M",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            const Center(child: Text('Page two'))
          ]),
          // slivers: [
          //   // CustomScrollView는 slivers라는 특이한 자식들을 가진다.
          //   SliverAppBar(
          //     // slivers는 위젯을 담고 있지만 선정된 위젯만 사용할 수 있다.
          //     /// floating: true, // 화면을 잔뜩 내린 뒤에도 살짝 위로 올리면 앱바가 나타난다
          //     // snap: true, // snap & floating 의 조합을 사용하면 아주 살짝만 위로 올려도 앱바가 나타난다.
          //     stretch: true, // 앱바를 당기면 늘어나는 효과
          //     pinned: true, // 위로 올려도 사라지지 않고 고정된 크기를 차지함.
          //     backgroundColor: Colors.teal,

          //     collapsedHeight: 80, // 앱바가 중러들 수 있는 최소 크기
          //     expandedHeight: 200, // 앱바의 확장된 크기
          //     flexibleSpace: FlexibleSpaceBar(
          //       // 움직일 수 있는 공간의 효과를 지정함.
          //       title: const Text("Hello"),
          //       stretchModes: const [
          //         // 앱바를 당겼을 때의 효과를 지정함.
          //         StretchMode.blurBackground,
          //         StretchMode.zoomBackground,
          //         StretchMode.fadeTitle,
          //       ],
          //       background: Image.asset(
          //         "assets/images/Cream.jpeg",
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          //   SliverToBoxAdapter(
          //     // slivers 안에는 sliver만 넣을 수 있다.
          //     // 컬럼 등 다른 위젯 만들고 싶으면 SlivertoBoxAdapter를 활용해서 다른 위젯을 넣는 방법이 있다.
          //     child: Column(
          //       children: const [
          //         CircleAvatar(
          //           backgroundColor: Colors.red,
          //           radius: 20,
          //         )
          //       ],
          //     ),
          //   ),
          //   SliverFixedExtentList(
          //     // 고정된 Extent(크기)를 갖는 sliver리스트를 만든다.
          //     delegate: SliverChildBuilderDelegate(
          //       childCount: 50, // 생성할 자식의 갯수
          //       (context, index) => Container(
          //         color:
          //             Colors.amber[100 * (index % 9)], // index를 활용해서 컬러를 각기 다르게 표현
          //         child: Align(
          //           //정렬을 돕는 위젯
          //           alignment: Alignment.center, child: Text("child $index"),
          //         ),
          //       ),
          //     ),
          //     itemExtent: 100,
          //   ), // 생성할 아이템의 크기
          //   SliverPersistentHeader(
          //     delegate: CustomDelegate(),
          //     pinned: true,
          //     floating: true, // 현재는 SliverAppBar의 pinned 때문에 잘 보이진 않는다.
          //     //추후 이런 중복 문제를 잘 피해야 할듯.
          //   ),
          //   SliverGrid(
          //     // Sliver그리드를 만드는 위젯
          //     delegate: SliverChildBuilderDelegate(
          //       // 자식을 만들 빌더
          //       childCount: 50, // 자식의 갯수
          //       (context, index) => Container(
          //         color:
          //             Colors.blue[100 * (index % 9)], // index를 활용해서 컬러를 각기 다르게 표현
          //         child: Align(
          //           //정렬을 돕는 위젯
          //           alignment: Alignment.center, child: Text("child $index"),
          //         ),
          //       ),
          //     ),
          //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //       // Grid의 크기 등을 설정
          //       maxCrossAxisExtent: 100,
          //       mainAxisSpacing: Sizes.size20,
          //       crossAxisSpacing: Sizes.size20,
          //       childAspectRatio: 1,
          //     ),
          //   )
          // ],
        ),
      ),
    );
  }
}

// class CustomDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.indigo,
//       child: const FractionallySizedBox(
//         heightFactor: 1,
//         child: Center(
//           child: Text(
//             'Title!!!!!',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ), // 부모로부터 최대한 많은 공간을 차지하는 박스
//     );
//   }

//   @override
//   double get maxExtent => 150;

//   @override
//   double get minExtent => 80;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
