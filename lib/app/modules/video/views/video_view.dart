import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/app/modules/video/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoView extends GetView<VideoController> {
  @override
  Widget build(BuildContext context) {
    // Ambil parameter dari Get.arguments
    final arguments = Get.arguments as Map<String, dynamic>;
    final initialIndex = arguments['index'] as int;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              controller: PageController(initialPage: initialIndex), // Set initial page
              itemBuilder: (context, index) {
                final videoData = controller.videoList[index];

                return Stack(
                  children: [
                    VideoPlayerWidget(videoUrl: videoData.videoUrl),
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
                    Positioned(
                      bottom: 50,
                      left: 10,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            Positioned(
              top: 10,
              left: 10,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
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
    _loadVideo();
  }

  void _loadVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller!.play();
          _controller!.setLooping(true);
        }
      }).catchError((error) {
        print("Error loading video: $error");
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _loadVideo();
    }
  }

  void _disposeController() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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