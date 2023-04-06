// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

void main() {
  group("VideoModel Test", () {
    test('Test Constructor', () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        likes: 1,
        creater: "dddd",
        comments: 1,
        createdAt: 1,
        creatorUid: "creatorUid",
      );
      expect(video.id, "id");
    });

    test("Test .fromJson constructor", () {
      final video = VideoModel.fromJson(
        json: {
          "id": "id",
          "title": "title",
          "description": "description",
          "fileUrl": "fileUrl",
          "thumbnailUrl": "thumbnailUrl",
          "likes": 1,
          "creater": "creater",
          "comments": 1,
          "creatorUid": "creatorUid",
          "createdAt": 1,
        },
        videoId: "videoId",
      );

      expect(video.title, "title");
      expect(video.comments, greaterThan(0));
      expect(video.likes, isInstanceOf<int>());
    });

    test("Test toJson Method", () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        likes: 1,
        creater: "creater",
        comments: 1,
        creatorUid: "creatorUid",
        createdAt: 1,
      );
      final json = video.toJson();
      expect(json["id"], "id");
      expect(json["likes"], isInstanceOf<int>());
    });
  });
}
