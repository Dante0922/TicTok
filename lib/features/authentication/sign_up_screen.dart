import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/";
  const SignUpScreen({super.key});

  void _onloginTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation);
            final opacityAnimation = Tween(
              begin: 0.5,
              end: 1.0,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: child,
              ),
            );
          }),
    );
  }

  void _onEmailTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      UsernameScreen.routeName, // 실수를 방지하기 위해 static 변수를 정의해서 사용
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const UsernameScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    print(Localizations.localeOf(context));
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
                  Text(
                    S.of(context).signUpTitle("TikTok", DateTime.now()),
                    // AppLocalizations.of(context)!.signUpTitle("TikTokasda"),
                    //"Sign up for TicTok",
                    // 일일히 텍스트스타일을 지정하지 않고 textTheme를 활용해보자.
                    // 설정된 Theme.copyWith() 활용하면 추가적으로
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.amber,
                        ),
                  ),
                  Gaps.v10,
                  Text(
                    "Text Style",
                    // GoogleFonts를 개별적으로 적용할 수도 있다.
                    style: GoogleFonts.abrilFatface(
                      textStyle: const TextStyle(
                        fontSize: Sizes.size24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gaps.v20,
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7, // 다크모드 색상 두번째 방법
                    // 화이트/블랙의 70% 로 회색으로 표현됨
                    child: Text(
                      S.of(context).signUpSubtitle(
                          7898797), //  intl_en.arb에서 인풋값에 따른 복수형도 바꿀 수 있다.
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        // color: isDarkMode(context)
                        // 다크모드 글씨 색상 첫번째 방법 isDarkMode 활용
                        //     ? Colors.grey.shade300
                        //     : Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  // Orientation의 방향을 받아와서 방향마다 배치를 바꿔준다.
                  if (orientation == Orientation.portrait) ...[
                    // colection if는 하나의 위젯만 반환한다.
                    // 이처럼 List로 묶어서 여러 자식들을 반환토록 할 수 있다.
                    AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.user),
                      text: S.of(context).emailPasswordButton,
                      onTapFunction: _onEmailTap,
                    ),
                    Gaps.v16,
                    AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      text: S.of(context).appleButton,
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
                            text: S.of(context).emailPasswordButton,
                            onTapFunction: _onEmailTap,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.apple),
                            text: S.of(context).appleButton,
                            onTapFunction: _onEmailTap,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            //BottomAppBar는 Meterial3에서 디자인이 완전 달라졌다. 대신 Container로 대체하면 된다.
            color: isDarkMode(context)
                // 모든 컬러를 다 수작업으로 바꿔야 해서 별로다.
                // ? Colors.grey.shade900
                ? null // darkTheme의 bottomAppBarTheme을 불러오자
                : Colors.grey.shade50,

            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).alreadyHaveAnAccount),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onloginTap(context),
                    child: Text(
                      S.of(context).logIn(
                          "female"), // intl_en.arb에서 스트링에 다른 표기도 바꿀 수 있다.
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
