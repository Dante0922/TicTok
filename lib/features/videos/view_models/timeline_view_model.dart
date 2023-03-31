import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [VideoModel(title: "First video")];

  void uplaodVideo() async {
    state = const AsyncValue.loading();
    await Future.delayed(
      const Duration(seconds: 2),
    );
    final newVideo = VideoModel(title: "${DateTime.now()}");
    // _list.add(newVideo); 이렇게 하면 화면을 리랜더링/리빌드 하지 않는다.
    _list = [..._list, newVideo];
    state = AsyncData(_list);
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    // FutureOr을 반환하고 있다. Future or Model
    //await Future.delayed(
    //   const Duration(milliseconds: 300),
    //  );
    //  throw Exception("OMG cant fetch");
    return _list;
  }
}

final timelineProvider =
    // Provider을 만드는 방법 AsyncNotifierProvider로 선언하고,
    // TimelineViewModel를 expose 하고, List<VideoModel>라는 데이터를 반환할 것이라고 선언
    // ViewModel 을 초기화해줄 펑션으로 () => TimelineViewModel()를 적으면 됨.
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
