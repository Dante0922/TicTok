import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';

import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 0;
  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      //Controller는 build 밖에서 내부를 조종할 수 있다!
      //굉장히 유용하다. 이번 건은 animateToPage를 통해 onPageChanged가 발생했을 때
      //넘어갈 page, 동작할 시간, 동작할 방법(curve)를 조종하고 있다.
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).fetchNextFetch();
    }
  }

  void _onVideoFinished() {
    return;
    //  _pageController.nextPage(duration: _scrollDuration, curve: _scrollCurve);
  }

  @override
  void dispose() {
    _pageController.dispose(); //컨트롤러는 항상 dispose해줘야 한다!
    super.dispose();
  }

  Future<void> _onRefresh() {
    //새로고침 시 작동하는 함수 원래 API를 호출해야 하지만 임시로 delayed를 반환하여 5초간 작동 후 리턴한다.
    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
        // when을 통해 loading, error, data 등 ref의 상태에 따라 출력을 다르게 해줄 수 있다.
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => Center(
              child: Text(
                "Could not load videos: $error",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
        data: (videos) {
          _itemCount = videos.length;
          return RefreshIndicator(
            // 화면을 아래로 끌어내렸을 때 상단에 리프레쉬 버튼이 나타나면서 새로고침해주는 위젯
            onRefresh: _onRefresh, // future를 반환해야 함. 새로고침 시 수행할 활동.
            displacement: 50, // 새로고침 버튼이 어디서 돌아가고 있을지
            edgeOffset: 20, // 새로고침 버튼이 어디서부터 시작할지
            color: Theme.of(context).primaryColor, // 새로고침 화살표의 색깔
            strokeWidth: 3, //화살표의 굵기
            child: PageView.builder(
                /*ListBuilder과 같이 필요할 때마다 PageView를 빌드해주는 함수. 영상을 한번에 불러오면 과부하를 불러 일으킨다.
         빌더를 활용하면 그떄그때 영상을 렌더링하기 떄문에 성능에 효과적 */
                scrollDirection: Axis.vertical,
                controller: _pageController,
                itemCount: videos.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    onVideoFinished:
                        () {}, //_onVideoFinished, //pageController를 활용하기 위해 onVideoFinished를 넘겨준다.
                    index: index,
                    videoData: videoData,
                  );

                  return null;
                }),
          );
        });

    // return RefreshIndicator(
    //   // 화면을 아래로 끌어내렸을 때 상단에 리프레쉬 버튼이 나타나면서 새로고침해주는 위젯
    //   onRefresh: _onRefresh, // future를 반환해야 함. 새로고침 시 수행할 활동.
    //   displacement: 50, // 새로고침 버튼이 어디서 돌아가고 있을지
    //   edgeOffset: 20, // 새로고침 버튼이 어디서부터 시작할지
    //   color: Theme.of(context).primaryColor, // 새로고침 화살표의 색깔
    //   strokeWidth: 3, //화살표의 굵기
    //   child: PageView.builder(
    //     /*ListBuilder과 같이 필요할 때마다 PageView를 빌드해주는 함수. 영상을 한번에 불러오면 과부하를 불러 일으킨다.
    //      빌더를 활용하면 그떄그때 영상을 렌더링하기 떄문에 성능에 효과적 */
    //     scrollDirection: Axis.vertical,
    //     controller: _pageController,
    //     itemCount: _itemCount,
    //     onPageChanged: _onPageChanged,
    //     itemBuilder: (context, index) => VideoPost(
    //       onVideoFinished:
    //           _onVideoFinished, //pageController를 활용하기 위해 onVideoFinished를 넘겨준다.
    //       index: index,
    //     ),
    //   ),
    // );
  }
}


/*
*/ 