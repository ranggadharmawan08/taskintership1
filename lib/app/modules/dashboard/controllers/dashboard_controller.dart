import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/app/modules/video/views/video_view.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var dataList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('videos').get();
      dataList.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void onThumbnailTap(int index) {
    final videoUrl = dataList[index]['videoUrl'];
    Get.to(() => VideoView(),
        arguments: {'index': index, 'videoUrl': videoUrl});
  }
}
