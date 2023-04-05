import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/utils.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    const AsyncValue.loading();
    state = await AsyncValue.guard(
      // 에러가 없으면 결과를 에러가 있으면 에러를 반환하는 guard
      () async => await _repository.signIn(email, password),
    );
    if (state.hasError) {
      showFirebaseErrorSnack(
          context, state.error); // ViewModel에서 활용할 수 있는 util로 구현
    } else {
      context.go("/home");
    }
  }
}

final loginProvider =
    AsyncNotifierProvider<LoginViewModel, void>(() => LoginViewModel());
