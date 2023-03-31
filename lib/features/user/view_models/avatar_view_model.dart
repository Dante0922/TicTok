import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/user/repos/user_repo.dart';
import 'package:tiktok_clone/features/user/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncLoading();
    final fileName =
        ref.read(authRepo).user!.uid; // 파일네임은 uid로 고정. 업데이트하면 덧씌워진다.
    state = await AsyncValue.guard(() async {
      await _repository.uploadAvatar(file, fileName); // repo를 통해 storage에 업로드
      await ref
          .read(usersProvider.notifier)
          .onAvatarUpload(); // hasAvatar 업데이트를 통해 watch에 전달. 리랜더링
    });
  }
}

final avatarProvider =
    AsyncNotifierProvider<AvatarViewModel, void>(() => AvatarViewModel());
