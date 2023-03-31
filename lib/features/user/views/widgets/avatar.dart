import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/user/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;
  const Avatar(
      {required this.uid,
      required this.name,
      super.key,
      required this.hasAvatar});

  Future<void> _onAvatarTap(WidgetRef ref) async {
    // 이미지를 갤러리에서 가져오는 위젯. imageQuality를 활용해 데이터를 아낄 수 있다.
    // maxHeight등을 통해 최대 크기도 정할 수 있음.
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ?
                  // NetWorkImage는 이미지를 cache로 저장하기 때문에
                  // url의 마지막에 시간을 주는 트릭으로 이미지가 바뀌면 새로 불러오도록 해주었다.
                  NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tictok-study.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}")
                  : null,
              child: Text(name),
            ),
    );
  }
}
