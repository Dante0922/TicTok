import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    if (_authenticationRepository.isLoggedIn) {
      // authRepo를 통해 login상태로 확인되면 uid로 객체정보를 받아옴.
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile); // 객체정보Json을 Map으로 분리하여 반환.
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
        hasAvatar: false,
        bio: "undefined",
        link: "undefined",
        email: credential.user!.email ?? "anon@anon.com",
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anon",
        introduction: "first visit",
        homepage: "");
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  // hasAvatar를 true로 업데이트 시켜 화면이 동적으로 반응하게 만든다.
  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> onIntroUpload(String intro, String homepage) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(
      introduction: intro,
      homepage: homepage,
    ));
    await _usersRepository.updateUser(state.value!.uid, {
      "introduction": intro,
      "homepage": homepage,
    });
  }

  Future<List<UserProfileModel>> getUserList() async {
    final result = await _usersRepository.fetchUsers();
    final users = result.docs.map(
      (doc) => UserProfileModel.fromJson(doc.data()),
    );
    return users.toList();
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
