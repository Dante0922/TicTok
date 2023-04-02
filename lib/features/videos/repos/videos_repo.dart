import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    // storage에 videos/uid/time으로 경로를 지정해두고
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().microsecondsSinceEpoch.toString()}");
    // putFile(video)를 통해 파일을 업로드한다.
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {int? lastItemCreatedAt}) {
    //return _db.collection("videos").where("likes", isGreaterThan: 0).get();
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set({
        "createdAt:": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await query.delete();
    }
  }

  Future<bool> isLiked(String videoId, String userId) async {
    final url = "${videoId}000$userId";
    final query = _db.collection("likes").doc(url);
    final isliked = await query.get();
    return isliked.exists;
  }
}

final videosRepo = Provider((ref) => VideosRepository());
