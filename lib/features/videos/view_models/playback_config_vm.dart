import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel>
// Riverpod의 다양한 확장자 중 Notifier을 사용했다.
// <>안에 원하는 Model의 형식을 가져다가 적어주자.
{
  final PlaybakcConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    /* view가 viewModel의 setMuted를 호출하면 세가지 작업을 처리해준다
  1._repository.setMuted(value)를 통해 저장소에 value를 저장한다.
  2. _model.muted = value를 통해 모델의 muted값을 바꿔준다
  3. notifyListeners()를 통해 view에게 바뀐 값을 전달해준다(rebuild)  */
    _repository.setMuted(value);
    state = PlaybackConfigModel(muted: value, autoplay: state.autoplay);
    // build 안의 변수에 접근하기 위해 state를 활용한다. Notifier Class 안에서는 state를 통해 언제든 접근/수정 가능.
    // 다만 state 자체를 변경하는 것이 아니라 새로운 state로 덧씌워준다.
    //notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(muted: state.muted, autoplay: value);
    //  notifyListeners();
  }

  @override
  PlaybackConfigModel build() {
    // Notifier가 노출되었을 때 보여줄 데이터를 제공하는 build
    return PlaybackConfigModel(
        // repos는 서버이고 model은 cache라고 생각하자.
        muted: _repository.isMuted(),
        autoplay: _repository.isAutoplay());
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
