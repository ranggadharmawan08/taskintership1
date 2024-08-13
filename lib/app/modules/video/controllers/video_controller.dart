import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoController extends GetxController {
  RxList<VideoData> videoList = RxList<VideoData>();

  @override
  void onInit() {
    super.onInit();
    _fetchVideos();
  }

  void _fetchVideos() {
    FirebaseFirestore.instance.collection('videos').snapshots().listen((snapshot) {
      videoList.clear();
      for (var doc in snapshot.docs) {
        videoList.add(VideoData.fromFirestore(doc));
      }
    });
  }
}

class VideoData {
  final String videoUrl;
  final String title;
  final String description;

  VideoData({
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  factory VideoData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return VideoData(
      videoUrl: data['video_url'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
