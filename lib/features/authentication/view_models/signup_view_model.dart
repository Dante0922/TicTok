import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  // 계정 생성을 만들기만 할 것이기 때문에 <void>

  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);
    print(form);
    print(form["email"]);
    print(form["password"]);
    state = await AsyncValue.guard(
      // guard는 state에 이상이 있으면 이상을, 없으면 정상값을 넣어준다.
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
    print(state);
  }
}

final signUpForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
