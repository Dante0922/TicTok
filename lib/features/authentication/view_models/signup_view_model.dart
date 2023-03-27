import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  // 계정 생성을 만들기만 할 것이기 때문에 <void>

  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(
      // guard는 state에 이상이 있으면 이상을, 없으면 정상값을 넣어준다.
      () async => await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      ),
    );
    if (state.hasError) {
      showFirebaseErrorSnack(
        context,
        state.error,
      ); // ViewModel에서 활용할 수 있는 util로 구현
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

final signUpForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
