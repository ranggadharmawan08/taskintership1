import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/app/modules/video/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

// [VideoView] merupakan view yang menampilkan video dalam bentuk PageView
// vertikal yang mirip dengan tampilan TikTok. Video akan diputar otomatis
// dan ada overlay untuk title, description, dan beberapa ikon di bagian kanan.
class VideoView extends GetView<VideoController> {
  @override
  Widget build(BuildContext context) {
    // Ambil parameter dari Get.arguments, misalnya index awal dari video yang akan diputar
    final arguments = Get.arguments as Map<String, dynamic>;
    final initialIndex = arguments['index'] as int;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // PageView untuk menampilkan video-video secara vertikal
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              controller:
                  PageController(initialPage: initialIndex), // Set initial page
              itemBuilder: (context, index) {
                final videoData = controller.videoList[index];

                return Stack(
                  children: [
                    // Widget untuk memutar video
                    VideoPlayerWidget(videoUrl: videoData.videoUrl),

                    // Overlay untuk efek gradient dari atas ke bawah
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Overlay untuk menampilkan title dan description
                    Positioned(
                      bottom: 50,
                      left: 10,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              videoData.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              videoData.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ikon-ikon fungsionalitas (like, comment, share, bookmark, more options) di sebelah kanan
                    Positioned(
                      right: 10,
                      bottom: 60,
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.white),
                            onPressed: () {
                              // Implementasikan fungsi like
                            },
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.white),
                            onPressed: () {
                              // Implementasikan fungsi comment
                            },
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              // Implementasikan fungsi share
                            },
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.bookmark, color: Colors.white),
                            onPressed: () {
                              // Implementasikan fungsi bookmark
                            },
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              // Implementasikan fungsi more options
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Tombol back di pojok kiri atas
            Positioned(
              top: 10,
              left: 10,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back(); // Kembali ke halaman sebelumnya
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// [VideoPlayerWidget] adalah widget yang menghandle pemutaran video dari URL
// yang diberikan. Widget ini menggunakan package [video_player].
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _loadVideo(); // Load video saat inisialisasi widget
  }

  // Metode untuk load video dari URL
  void _loadVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller!.play(); // Play video setelah di-load
          _controller!.setLooping(true); // Set video untuk loop terus menerus
        }
      }).catchError((error) {
        print("Error loading video: $error");
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika URL video berubah, dispose controller sebelumnya dan load video baru
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _loadVideo();
    }
  }

  // Metode untuk dispose controller
  void _disposeController() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _disposeController(); // Dispose controller saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Jika video telah diinisialisasi, tampilkan video, jika tidak tampilkan loading indicator
        _controller != null && _controller!.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),

        // Progress bar untuk video
        if (_controller != null && _controller!.value.isInitialized)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                backgroundColor: Colors.white,
                playedColor: Colors.red,
                bufferedColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
