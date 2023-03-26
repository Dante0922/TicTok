import 'package:flutter/material.dart';

// 변경될 변수가 한개만 있을 땐 단순하게 ValueNotifier을 사용하면 된다.
final videoConfig = ValueNotifier(false);
//final darkModeConfig = ValueNotifier(false);

class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}

class DarkModeConfig extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleIsDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

//-----------2번 방식

// 다양한 값과 변수가 있다면 ChangeNotifier을 사용하자.
// class VideoConfig extends ChangeNotifier {
//   bool autoMute = true;

//   void toggleAutoMute() {
//     autoMute = !autoMute; // setState 안 해도 됨!
//     notifyListeners(); // 대신 이 함수를 통해 리스너들에게 변경을 알려준다.
//   }
// }

// final videoConfig = VideoConfig();



//-----------1번 방식

// import 'package:flutter/widgets.dart';

// class VideoConfigData extends InheritedWidget {
//   final bool autoMute;
//   final void Function() toggleMuted;
//   const VideoConfigData({
//     super.key,
//     required super.child,
//     required this.autoMute,
//     required this.toggleMuted,
//   });

//   static VideoConfigData of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<
//         VideoConfigData>()!; // 긴 함수를 of()로 간추려준다! 원리는 context에서 <VideoConfigData>와 정확히 일치하는 것을 찾아주는 것
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }

// class VideoConfig extends StatefulWidget {
//   final Widget child;
//   const VideoConfig({
//     super.key,
//     required this.child,
//   });

//   @override
//   State<VideoConfig> createState() => _VideoConfigState();
// }

// class _VideoConfigState extends State<VideoConfig> {
//   bool autoMute = false;

//   void toggleMuted() {
//     setState(() {
//       autoMute = !autoMute;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VideoConfigData(
//       toggleMuted: toggleMuted,
//       autoMute: autoMute,
//       child: widget.child,
//     );
//   }
// }
