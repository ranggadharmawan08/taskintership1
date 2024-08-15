import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Controller untuk mengelola dan memuat data video dari Firestore.
class VideoController extends GetxController {
  // Daftar video yang diamati untuk perubahan data.
  // `RxList` digunakan agar perubahan otomatis diperbarui di UI.
  RxList<VideoData> videoList = RxList<VideoData>();

  // Dipanggil saat `VideoController` diinisialisasi.
  // Memanggil [_fetchVideos] untuk memulai pendengaran terhadap koleksi video di Firestore.
  @override
  void onInit() {
    super.onInit();
    _fetchVideos();
  }

  // Mengambil dan mendengarkan perubahan data video dari Firestore.
  // Data yang diambil akan dimasukkan ke dalam [videoList].
  void _fetchVideos() {
    FirebaseFirestore.instance.collection('videos').snapshots().listen((snapshot) {
      videoList.clear(); // Membersihkan daftar video lama.
      for (var doc in snapshot.docs) {
        videoList.add(VideoData.fromFirestore(doc)); // Menambahkan video baru dari Firestore.
      }
    });
  }
}

// Model data untuk merepresentasikan struktur data video.
class VideoData {
  final String videoUrl; // URL dari video.
  final String title; // Judul video.
  final String description; // Deskripsi video.

  // Konstruktor untuk membuat objek [VideoData].
  VideoData({
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  // Factory method untuk membuat objek [VideoData] dari [DocumentSnapshot] yang diambil dari Firestore.
  factory VideoData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return VideoData(
      videoUrl: data['video_url'] ?? '', // Mengambil URL video dari data Firestore.
      title: data['title'] ?? '', // Mengambil judul video dari data Firestore.
      description: data['description'] ?? '', // Mengambil deskripsi video dari data Firestore.
    );
  }
}
