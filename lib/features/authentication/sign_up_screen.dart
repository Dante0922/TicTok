import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onloginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _onEmailTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      // 오리엔테이션을 활용하기 위한 위젯
      builder: (context, orientation) {
        print(orientation);
        // if (orientation == Orientation.landscape) {
        // 단순하게 회전하지 말라고 알리는 방법도 있다.
        //   return const Scaffold(
        //     body: Center(
        //       child: Text("Plz rotate Ur phone"),
        //     ),
        //   );
        // }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  const Text("Sign up for TicTok",
                      style: TextStyle(
                        fontSize: Sizes.size24,
                        fontWeight: FontWeight.w700,
                      )),
                  Gaps.v20,
                  const Text(
                    "Create a profile, follow other accounts, make your own vides, and more.",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.v40,
                  // Orientation의 방향을 받아와서 방향마다 배치를 바꿔준다.
                  if (orientation == Orientation.portrait) ...[
                    // colection if는 하나의 위젯만 반환한다.
                    // 이처럼 List로 묶어서 여러 자식들을 반환토록 할 수 있다.
                    AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.user),
                      text: "Use email & password",
                      onTapFunction: _onEmailTap,
                    ),
                    Gaps.v16,
                    AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      text: "Continue with Apple",
                      onTapFunction: _onEmailTap,
                    )
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          // AuthButton은 FractionallySizedBox를 포함하고 있따.
                          // FraBOX는 부모의 최대한의 크기를 갖고자 하는데, Row는 좌우로 제한이 없기 떄문에
                          // 이 크기가 무제한이 된다. 이를 방지하기 위해 Expanded를 사용해주자.
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.user),
                            text: "Use email & password",
                            onTapFunction: _onEmailTap,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.apple),
                            text: "Continue with Apple",
                            onTapFunction: _onEmailTap,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.grey.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onloginTap(context),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
