import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  //onVideoFinished 함수는 state가 아닌 Widget으로 넘겨받았다.
  //이를 아래 state에서 쓰고 싶다면 widget.onVideoFinish로 사용할 수 있다.
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset(
          "assets/videos/IMG_9255.MOV"); //비디오를 asset으로 갖는 Controller를 만들어준다.

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController; // 애니메이션 컨트롤러 선언
  final String _text = "크림 뒹굴뒹굴~~ 언능 건강해지자 쿨미야!!";
  bool _seeMore = false;

  void _onVideoChange() {
    //비디오의 길이와 현재위치(position)이 일치하면 비디오가 끝난 것으로 간주하고
    //내려받은 onVideoFinished를 실행시킨다.
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    //비디오를 불러오기까지 기다려줘야 하기 때문에 async를 활용한다.
    //컨트롤러.initialize()를 통해 비디오를 불러오고 play()를 통해 실행시킨 뒤 setState를 한다.
    //또한 종료를 알기 위해 이벤트리스너를 컨트롤러에 추가하고 이벤트 시 종료를 감지하는 함수를 넣어준다.
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true); //비디오가 무한 반복되도록 설정
    _videoPlayerController.addListener(_onVideoChange);
    if (kIsWeb) {
      // k를 붙이면 framework가 제공하는 constant들을 확인할 수 있다.
      // 대부분의 웹에서는 영상+소리가 자동재생되는 것을 금지하고 있다.
      // 사용자에게 불쾌한 경험을 끼칠 수 있기 때문. web이라면 volume를 0으로 줄여서 방지하자.
      await _videoPlayerController.setVolume(0);
    }
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //info를 통해 현재 보이는 화면의 visibleFraction이 1이 되면(전체가 다 보이면)
    //영상을 작동시키는 메소드
    if (!mounted) return; //mounted란 위젯이 트리에 존재하는지 확인하는 것. 존재한다면 True
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      //다른 탭에 가면 비디오가 멈출 수 있도록 설정.
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    //화면을 클릭했을 때 영상이 작동중미면 멈추고, 멈춰있으면 작동시킨다.
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); //애니메이션 크기의 최대/최소 값을 바꿔준다.
    } else {
      _videoPlayerController.play();
      _animationController.forward(); // 애니메이션의 크기를 원상태로 복구한다.
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onTapSeeMore() {
    _seeMore = !_seeMore;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      //initState 하면서 컨트롤러값을 지정해준다.
      vsync: this,
      lowerBound: 1.0, //애니메니션 크기의 최소값과 최대값을 지정함
      upperBound: 1.5,
      value: 1.5, // 애니메이션의 기본 크기를 지정함.
      duration: _animationDuration,
    );
    // _animationController.addListener(() {
    //   setState(() {}); // 1번 방법. 애니메이션컨트롤러에 리스너를 달아 변경될 때마다 setState하여 자연스럽게 빌드한다.
    // });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose(); //컨트롤러는 항상 dispose
    _animationController.dispose();
    super.dispose();
  }

  void _onCommentTap(BuildContext context) async {
    //async 를 사용함으로써 showModalBottonShseet await가 완료된 뒤 _onTogglePause를 실행할 수 있다.
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      //flutter 내장 함수. 바텀씨트를 빌드해준다.
      backgroundColor: Colors.transparent, //바텀시트의 색깔을 지정해준다.
      isScrollControlled:
          true, //bottomSheet 안에 ListView를 사용하려면 꼭 true값을 넣어줘야 한다.
      context: context,
      builder: (context) => const VideoComments(), //빌드할 위젯
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    final videoConfig = context.dependOnInheritedWidgetOfExactType<
        VideoConfigData>(); // 가장 위에 있는 VideoConfig에 다이렉트로 접근할 수 있도록 해준다. 방법 중 하나지만 피곤하다.
    final videoConfig2 = VideoConfigData.of(context).autoMute;
    print("stst");
    print(VideoConfigData.of(context).autoMute);
    print("ttt");
    return VisibilityDetector(
      //보이는 정도를 추적할 수 있는 위젯
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged, //보이는 정도가 바뀔 때마다 실행되는 함수.
      child: Stack(
        children: [
          Positioned.fill(
            //positioned.fill fill은 남은 모든 공간을 채우는 것/
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(
                    _videoPlayerController) //VideoPlayer 위젯은 컨트롤를 필수로 받는다.
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              //이 위젯의 자식들은 Gesture 무시처리가 된다.
              //이걸 감싸지 않으면 icon을 클릭했을 때 icon에 클릭이 속해서 전체화면의 제스처가 안 먹게 됨
              child: Center(
                child: AnimatedBuilder(
                  //두번쨰 방법. Controller에 이벤트리스너를 달지 않고 이 위젯을 활용해서 에니메이션을 빌드한다
                  //니콜라스의 추천 방식. 위젯과 애니메이션을 분리해서 사용하기 떄문에 보다 직관적이다.
                  animation: _animationController, //어떤 에니메이션 컨트롤할지 컨트롤러를 넣어주고
                  builder: (context, child) {
                    // 빌더를 선언하여 어떤 에니메이션을 빌드할지 선언한다.
                    return Transform.scale(
                      //크기를 바꿔주는 위젯
                      scale: _animationController.value, // 스케일을 바꾸어주고
                      child:
                          child, // 이 애니메이션의 대상을 지정해준다. 여기서 child는 바로 아래에 있는 child: AnimatedOpacity()이다.
                    );
                  },
                  child: AnimatedOpacity(
                    //선명도 바꾸면서 에니메이션 효과를 주는 위젯
                    opacity: _isPaused ? 1 : 0, // 선명도를 바꿔준다.
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size56,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@크림",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v24,
                Row(
                  children: [
                    Text(
                      _seeMore ? _text : _text.substring(0, 7),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onTapSeeMore,
                      child: Text(
                        _seeMore ? "...Close" : "...See more",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: 40,
            top: 40,
            child: IconButton(
              icon: FaIcon(VideoConfigData.of(context).autoMute
                  ? FontAwesomeIcons.volumeOff
                  : FontAwesomeIcons.volumeHigh),
              color: Colors.white,
              onPressed: VideoConfigData.of(context).toggleMuted,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/101305519?s=400&u=49f84ad7b2032a7809bbf656cb96f923566bfb51&v=4"),
                  child: Text("크림"),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(989898888),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(32321231233332),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
