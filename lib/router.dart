import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/views/login_screen.dart';
import 'package:tiktok_clone/features/authentication/views/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/inbox/views/select_chat_screen.dart';
import 'package:tiktok_clone/features/notifications/notifications_provider.dart';

import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  //ref.watch(authState); // authState가 변경될 때 자동으로 route가 리빌드된다.
  return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        ShellRoute(
            builder: (context, state, child) {
              ref.read(notificationsProvider(context));
              return child;
            },
            routes: [
              GoRoute(
                name: SignUpScreen.routeName,
                path: SignUpScreen.routeURL,
                builder: (context, state) => const SignUpScreen(),
              ),
              GoRoute(
                name: LoginScreen.routeName,
                path: LoginScreen.routeURL,
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                name: InterestsScreen.routeName,
                path: InterestsScreen.routeURL,
                builder: (context, state) => const InterestsScreen(),
              ),
              GoRoute(
                path:
                    "/:tab(home|discover|inbox|profile)", // 받을 수 있는 파라미터를 4개로 제한함.
                name: MainNavigationScreen.routeName,
                builder: (context, state) {
                  final tab = state.params["tab"]!;
                  return MainNavigationScreen(
                    tab: tab,
                  );
                },
              ),
              GoRoute(
                path: ActivityScreen.routeURL,
                name: ActivityScreen.routeName,
                builder: (context, state) => const ActivityScreen(),
              ),
              GoRoute(
                path: ChatsScreen.routeURL,
                name: ChatsScreen.routeName,
                builder: (context, state) => const ChatsScreen(),
                routes: [
                  // 채팅들은 각각 자식주소를 달아주는 작업
                  GoRoute(
                    path: ChatDetailScreen.routeURL,
                    name: ChatDetailScreen.routeName,
                    builder: (context, state) {
                      final chatroomId = state.params["chatroomId"]!;
                      return ChatDetailScreen(
                        chatroomId: chatroomId,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: VideoRecordingScreen.routeURL,
                name: VideoRecordingScreen.routeName,
                pageBuilder: (context, state) => CustomTransitionPage(
                  transitionDuration: const Duration(
                    milliseconds: 200,
                  ),
                  child: const VideoRecordingScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final position =
                        Tween(begin: const Offset(0, 1), end: Offset.zero)
                            .animate(animation);
                    return SlideTransition(
                      position: position,
                      child: child,
                    );
                  },
                ),
              ),
              GoRoute(
                path: SelectChatScreen.routeUrl,
                name: SelectChatScreen.routeName,
                builder: (context, state) => const SelectChatScreen(),
              ),
            ])
      ]);
});

// final router = GoRouter(
//   routes: [
//     GoRoute(
//       name: SignUpScreen.routeName,
//       path: SignUpScreen.routeURL,
//       builder: (context, state) => const SignUpScreen(),
//       routes: [
//         GoRoute(
//             path: UsernameScreen.routeURL,
//             name: UsernameScreen.routeName,
//             builder: (context, state) => const UsernameScreen(),
//             routes: [
//               GoRoute(
//                 path: EmailScreen.routeURL,
//                 name: EmailScreen.routeName,
//                 builder: (context, state) {
//                   final args = state.extra as EmailScreenArgs;
//                   return EmailScreen(username: args.username);
//                 },
//               ),
//             ]),
//       ],
//     ),
//     // GoRoute(
//     //   path: LoginScreen.routeName,
//     //   builder: (context, state) => const LoginScreen(),
//     // ),
//     // GoRoute(
//     //   name: "username_screen",
//     //   path: UsernameScreen.routeName,
//     //   pageBuilder: (context, state) {
//     //     return CustomTransitionPage(
//     //       // GoRoute로 페이지 변환 애니메이션을 넣는 방법
//     //       child: const UsernameScreen(),
//     //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//     //         return FadeTransition(
//     //           opacity: animation,
//     //           child: ScaleTransition(
//     //             scale: animation,
//     //             child: child,
//     //           ),
//     //         );
//     //       },
//     //     );
//     //   },
//     // ),

//     GoRoute(
//       path: "/users/:username",
//       builder: (context, state) {
//         // print(state.params);
//         final username = state.params['username'];
//         final tab = state.queryParams["show"];
//         return UserProfileScreen(username: username!, tab: tab!);
//       },
//     )
//   ],
// );
