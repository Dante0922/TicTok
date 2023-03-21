import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // 2개 이상의 animationController가 있는 경우 SingleTicker를 이 위젯으로 바꿔주자.
  // 앱을 나가거나 들어오는 것을 체크하기 위해 WidgetsBindingObserver 를 추가로 달아줌.
  bool _hasPermission = false;
  // final bool _deniedPermission = false;
  bool _isSelfieMode = false;
  late CameraController _cameraController;
  late FlashMode _flashMode;
  late double maxZoom;
  double zoomLv = 1.0;
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 200,
    ),
  );
  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 10,
    ),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  Future<void> initCamera() async {
    final cameras = await availableCameras(); // 사용 가능한 카메라가 무엇이 있는지 알려주는 함수
    if (cameras.isEmpty) return;
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );
    await _cameraController.initialize(); // 카메라 활성화
    await _cameraController
        .prepareForVideoRecording(); // iOS 녹화를 위한 사전작업. Android는 이 함수가 필요없다.
    _flashMode = _cameraController.value.flashMode;
    maxZoom = await _cameraController.getMaxZoomLevel();

    setState(() {});
  }

  Future<void> initPermissions() async {
    //  Permission 확장자를 통해 권한을 받아오고 체크하는 함수.
    final cameraPermission =
        await Permission.camera.request(); // 카메라 권한을 받아오는 함수
    final micPermission =
        await Permission.microphone.request(); //마이크 권한을 받아오는 함수
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance
        .addObserver(this); // 앱을 나가거나 켤 때 카메라를 onoff하기 위해 사용한다.
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
    final video =
        await _cameraController.stopVideoRecording(); // Future<XFile>를 반환하고 있다.

    //print(video.name);
    //print(video.path);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _cameraController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) {
      return; // 방법 1. flutter을 처음 실행할 때 권한창을 불러오면 inactive 상태가 된다.
      // 이 때 아직 controller가 없는데 호출하고 있어 에러가 난다.
    }
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//    final video = await ImagePicker().pickVideo(source: ImageSource.camera);  // 카메라로 촬영하도록
    if (video == null) return;
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  void _onDragButton(DragUpdateDetails details) {
    if (details.primaryDelta! < 0) {
      if (zoomLv >= 129.0) return;
      zoomLv = zoomLv + 0.5;
      _cameraController.setZoomLevel(zoomLv);
    } else if (details.primaryDelta! > 0) {
      if (zoomLv <= 1.0) return;
      zoomLv = zoomLv - 0.5;
      _cameraController.setZoomLevel(zoomLv);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission || !_cameraController.value.isInitialized
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Requesting permissions...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size24,
                      ),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator.adaptive(),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(_cameraController),
                    Positioned(
                      top: Sizes.size32,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.off
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.off),
                            icon: const Icon(
                              Icons.flash_off_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.always
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.always),
                            icon: const Icon(
                              Icons.flash_on_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.auto
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.auto),
                            icon: const Icon(
                              Icons.flash_auto_rounded,
                            ),
                          ),
                          IconButton(
                            color: _flashMode == FlashMode.torch
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.torch),
                            icon: const Icon(
                              Icons.flashlight_on_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: Sizes.size40,
                      child: Row(
                        children: [
                          const Spacer(), // 빈 공간을 차지하는 위젯 Spacer - GE - Icon 으로 ROW를 균형있게 차지하게 해주고 있다.
                          GestureDetector(
                            onTapDown: _startRecording,
                            onTapUp: (details) => _stopRecording(),
                            //onVerticalDragUpdate: _onDragButton,
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // 아이콘 버튼이 눌리는 범위를 아이콘 크기로 제한하고 싶다면 Container로 감싸주자.
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
