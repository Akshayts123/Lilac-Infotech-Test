import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/data/controller/theme_controller.dart';
import 'package:lilac_infotech/presentation/home_screen/widgets/vedio_listing.dart';
import 'package:lilac_infotech/theme/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/Helper/sharedPref.dart';
import '../../../core/Helper/snackbar_toast_helper.dart';
import '../../../core/constants/assets_utils.dart';
import '../../../core/utils/link.dart';
import '../../../routes/app_routes.dart';


class VideoPlayerControllers extends GetxController {
  late VideoPlayerController controller;
  RxList<String> videoUrls = <String>[].obs;
  RxInt currentIndex = 0.obs;
  RxBool isDownloading = false.obs;
  RxBool offLine = false.obs;
  File? image;

  @override
  void onInit() {
    super.onInit();
    fetchVideoUrls();
    controller = VideoPlayerController.network(
      'https://videos.pexels.com/video-files/4440931/4440931-hd_1280_720_50fps.mp4',
    );
    _loadImage();
    controller.addListener(() {
      update();
    });
    controller.setLooping(true);
    controller.initialize().then((_) {
      update();
    });
  }

  Future<void> fetchVideoUrls() async {
    List<String> urls = await getVideoUrls();
    videoUrls.value = urls;
    if (urls.isNotEmpty) {
      initializeVideoPlayer();
    }
  }

  Future<List<String>> getVideoUrls() async {
    List<String> videoUrls = [];
    final ListResult result = await FirebaseStorage.instance.ref('Files').listAll();
    final List<Reference> allFiles = result.items;

    for (var file in allFiles) {
      final String fileUrl = await file.getDownloadURL();
      videoUrls.add(fileUrl);
    }

    return videoUrls;
  }

  Future<void> initializeVideoPlayer() async {
    final String currentUrl = videoUrls[currentIndex.value];
    if (await isVideoDownloaded(currentUrl)) {
      final String localPath = await getLocalPath(currentUrl);
      controller = VideoPlayerController.file(File(localPath))
        ..initialize().then((_) {
          update();
        });
    } else {
      controller = VideoPlayerController.network(currentUrl)
        ..initialize().then((_) {
          update();
        });
    }
  }

  Future<void> addToCache(String videoLink) async {
    isDownloading.value = true;
    var file = await DefaultCacheManager().getSingleFile(videoLink);
    await setSharedPrefrence(VIDEOPATH, file.path);
    isDownloading.value = false;
    offLine.value = true;
    showToastSuccess("Download Complete!");
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      image = File(imagePath);
    }
  }

  Future<bool> isVideoDownloaded(String url) async {
    final String localPath = await getLocalPath(url);
    return File(localPath).existsSync();
  }

  Future<String> getLocalPath(String url) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String fileName = path.basename(url);
    return '${directory.path}/$fileName';
  }

  void playNextVideo() {
    if (currentIndex.value < videoUrls.length - 1) {
      currentIndex.value++;
      controller.dispose();
      initializeVideoPlayer();
    }
  }

  void playPreviousVideo() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      controller.dispose();
      initializeVideoPlayer();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Stream<int> timerStream() {
    return Stream.periodic(Duration(seconds: 1), (count) => count);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
