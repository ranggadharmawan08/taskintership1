import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/app/modules/video/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoView extends GetView<VideoController> {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final initialIndex = arguments['index'] as int;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                final videoData = controller.videoList[index];

                return Stack(
                  children: [
                    VideoPlayerWidget(videoUrl: videoData.videoUrl, videoIndex: index),

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
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.white),
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.bookmark, color: Colors.white),
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {},
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
  final int videoIndex;

  const VideoPlayerWidget({Key? key, required this.videoUrl, required this.videoIndex}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  VideoPlayerController? _prevController;
  VideoPlayerController? _nextController;
  bool _isPreloading = false;

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
          Future.delayed(Duration(seconds: 10), () {
            _startPreloading();
          });
        }
      }).catchError((error) {
        print("Error loading video: $error");
      });
  }

  void _startPreloading() async {
    if (_isPreloading) return;
    _isPreloading = true;

    final videoList = Get.find<VideoController>().videoList;
    final prevIndex = widget.videoIndex > 0 ? widget.videoIndex - 1 : null;
    final nextIndex = widget.videoIndex < videoList.length - 1 ? widget.videoIndex + 1 : null;

    if (prevIndex != null) {
      _prevController = await _preloadVideo(videoList[prevIndex].videoUrl);
    }

    if (nextIndex != null) {
      _nextController = await _preloadVideo(videoList[nextIndex].videoUrl);
    }

    Future.delayed(Duration(seconds: 5), () {
      _disposePreloadControllers();
      _isPreloading = false;
    });
  }

  Future<VideoPlayerController?> _preloadVideo(String url) async {
    try {
      final controller = VideoPlayerController.network(url);
      await controller.initialize();
      return controller;
    } catch (error) {
      print("Error preloading video: $error");
      return null;
    }
  }

  void _disposePreloadControllers() {
    if (_prevController != null) {
      _prevController!.dispose();
      _prevController = null;
    }
    if (_nextController != null) {
      _nextController!.dispose();
      _nextController = null;
    }
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
    _disposePreloadControllers();
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
