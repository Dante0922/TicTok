import 'package:flutter/widgets.dart';

class VideoConfigData extends InheritedWidget {
  final bool autoMute;
  final void Function() toggleMuted;
  const VideoConfigData({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  });

  static VideoConfigData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        VideoConfigData>()!; // 긴 함수를 of()로 간추려준다! 원리는 context에서 <VideoConfigData>와 정확히 일치하는 것을 찾아주는 것
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class VideoConfig extends StatefulWidget {
  final Widget child;
  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
