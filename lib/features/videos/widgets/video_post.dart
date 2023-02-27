import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
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

class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset(
          "assets/videos/IMG_9255.MOV"); //비디오를 asset으로 갖는 Controller를 만들어준다.

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
    setState(() {});
    _videoPlayerController.addListener(_onVideoChange);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //info를 통해 현재 보이는 화면의 visibleFraction이 1이 되면(전체가 다 보이면)
    //영상을 작동시키는 메소드
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    //화면을 클릭했을 때 영상이 작동중미면 멈추고, 멈춰있으면 작동시킨다.
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose(); //컨트롤러는 항상 dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          const Positioned.fill(
            child: IgnorePointer(
              //이 위젯의 자식들은 Gesture 무시처리가 된다.
              //이걸 감싸지 않으면 icon을 클릭했을 때 icon에 클릭이 속해서 전체화면의 제스처가 안 먹게 됨
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: Colors.white,
                  size: Sizes.size56,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
