import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  final bool _deniedPermission = false; // 코드테스트
  bool _isSelfieMode = false;
  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras(); // 사용 가능한 카메라가 무엇이 있는지 알려주는 함수
    if (cameras.isEmpty) return;
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );
    await _cameraController.initialize();
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
  }

  Future<void> toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
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
                      left: Sizes.size20,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: toggleSelfieMode,
                        icon: const Icon(
                          Icons.cameraswitch,
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
