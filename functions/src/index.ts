// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";

// admin.initializeApp();

// export const onVideoCreated = functions.firestore
//   .document("videos/{videoId}")
//   .onCreate(async (snapshot, context) => {
//     const spawn = require("child-process-promise").spawn; // child-process-promise는 firebase의 기본 함수들을 사용할 수 있게 해준다. spawn을 통해 ffmpeg를 사용함.
//     const video = snapshot.data();
//     await spawn("ffmpeg", [
//       "-i", //ffmpeg를 활용해서 vidoe를 읽고
//       video.fileUrl,
//       "-ss", // 01초로 이동한 다음
//       "00:00:01.000",
//       "-vframes", // 첫번째 프레임을 골라서
//       "1",
//       "-vf", // 스케일을 150:-1로 지정.-1은 ffmpeg가 비율에 맞춰 자동 저장
//       "scale=150:-1",
//       `/tmp/${snapshot.id}.jpg`, // tmp폴더에 저장한다.
//     ]);
//     const storage = admin.storage();
//     await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
//       destination: `thumbnails/${snapshot.id}.jpg`,
//     });
//   });

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]);
    console.log(snapshot.data());
    console.log(video.fileUrl);
    console.log(snapshot.id);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    const db = admin.firestore();
    // users/creatorUid/videos/videoId 안에 videoId와 썸네일을 넣어준다.
    // 데이터가 중복되지만 nosql에선 흔한 방식이다. 이렇게 하면 쉽게 유저별 썸네일/영상을 찾을 수 있다.
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({ thumbnailUrl: file.publicUrl(), videoId: snapshot.id });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(1) });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(-1) });
  });
