import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];
  late final VideosRepository _repository;

  // void uplaodVideo() async {
  //   state = const AsyncValue.loading();
  //   await Future.delayed(
  //     const Duration(seconds: 2),
  //   );
  //   // final newVideo = VideoModel(title: "${DateTime.now()}");
  //   // _list.add(newVideo); 이렇게 하면 화면을 리랜더링/리빌드 하지 않는다.
  //   _list = [..._list];
  //   state = AsyncData(_list);
  // }
  FutureOr<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result = await _repository.fetchVideos(
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextFetch() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timelineProvider =
    // Provider을 만드는 방법 AsyncNotifierProvider로 선언하고,
    // TimelineViewModel를 expose 하고, List<VideoModel>라는 데이터를 반환할 것이라고 선언
    // ViewModel 을 초기화해줄 펑션으로 () => TimelineViewModel()를 적으면 됨.
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
