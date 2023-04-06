import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    // repo를 만들어야 하지만 시간 단축을 위해 여기다 둠.
    final user = ref.read(authRepo).user;
    if (user == null) return;
    await _db.collection("users").doc(user.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("I got message ${event.notification?.title}");
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      //print(notification.data['screen']);
      context.pushNamed(ActivityScreen.routeName);
    });
    // terminated
    final notification =
        await _messaging.getInitialMessage(); // 알림에 의해 실행되었는지만 알려준다. on이 아니다.
    if (notification != null) {
      // print(notification.data['screen']);
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    updateToken(token);
    await initListeners(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
