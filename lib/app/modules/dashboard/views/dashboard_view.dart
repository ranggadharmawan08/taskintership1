import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 0, 38, 70),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 30, right: 0),
          child: SingleChildScrollView(
            child: Container(
              color: const Color.fromARGB(255, 51, 3, 78),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Komponen untuk pencarian
                  Container(
                    color: const Color.fromARGB(255, 59, 0, 73),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 38, 0, 44),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  suffixIcon: Icon(Icons.search, color: Colors.white),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Trending Videos
                  Container(
                    color: const Color.fromARGB(255, 59, 0, 73),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 140, 1, 161),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Text('Trending', style: TextStyle(color: Colors.white, fontSize: 20)),
                                        SizedBox(width: 8),
                                        Icon(Icons.trending_up, color: Colors.white, size: 27),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (controller.dataList.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return SizedBox(
                              height: 300, // Sesuaikan tinggi sesuai kebutuhan
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.dataList.length,
                                itemBuilder: (context, index) {
                                  var videoData = controller.dataList[index];
                                  var videoUrl = videoData['video_url'];

                                  return GestureDetector(
                                    onTap: () {
                                      controller.onThumbnailTap(index);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Card(
                                        color: Colors.black,
                                        child: Container(
                                          width: 160, // Sesuaikan lebar sesuai kebutuhan
                                          height: 120, // Sesuaikan tinggi sesuai kebutuhan
                                          padding: const EdgeInsets.all(10),
                                          child: VideoPlayerWidget(videoUrl: videoUrl!),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // New Videos
                  Container(
                    color: const Color.fromARGB(255, 59, 0, 73),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 84, 1, 161),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Text('New Videos', style: TextStyle(color: Colors.white, fontSize: 20)),
                                        SizedBox(width: 8),
                                        Icon(Icons.new_label_outlined, color: Colors.white, size: 27),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (controller.dataList.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return SizedBox(
                              height: 300, // Sesuaikan tinggi sesuai kebutuhan
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.dataList.length,
                                itemBuilder: (context, index) {
                                  var videoData = controller.dataList[index];
                                  var videoUrl = videoData['video_url'];

                                  return GestureDetector(
                                    onTap: () {
                                      controller.onThumbnailTap(index);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Card(
                                        color: Colors.black,
                                        child: Container(
                                          width: 160, // Sesuaikan lebar sesuai kebutuhan
                                          height: 120, // Sesuaikan tinggi sesuai kebutuhan
                                          padding: const EdgeInsets.all(10),
                                          child: VideoPlayerWidget(videoUrl: videoUrl!),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: LayoutBuilder(
        builder: (context, constraints) {
          double iconSize = constraints.maxWidth * 0.08; // Ukuran ikon berdasarkan lebar layar
          double textSize = constraints.maxWidth * 0.03; // Ukuran teks berdasarkan lebar layar

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, const Color.fromARGB(255, 65, 4, 105)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book, color: Colors.white, size: iconSize),
                    const SizedBox(height: 5),
                    Text('Books', style: TextStyle(color: Colors.white, fontSize: textSize)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: iconSize),
                    const SizedBox(height: 5),
                    Text('Flash', style: TextStyle(color: Colors.white, fontSize: textSize)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 53, 1, 83),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_outlined, color: Colors.white, size: iconSize),
                        const SizedBox(height: 5),
                        Text('VIDEO', style: TextStyle(color: Colors.white, fontSize: textSize)),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sports_esports_outlined, color: Colors.white, size: iconSize),
                    const SizedBox(height: 5),
                    Text('GAME', style: TextStyle(color: Colors.white, fontSize: textSize)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_pin_circle_outlined, color: Colors.white, size: iconSize),
                    const SizedBox(height: 5),
                    Text('PROFILE', style: TextStyle(color: Colors.white, fontSize: textSize)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, Key? key}) : super(key: key);

   @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
