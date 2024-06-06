import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import '../../../core/Helper/sharedPref.dart';
import '../../../core/Helper/snackbar_toast_helper.dart';

class VideoPlayerControllers extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late VideoPlayerController controller = VideoPlayerController.network('');
  RxList<String> videoUrls = <String>[].obs;
  RxInt currentIndex = 0.obs;
  RxBool isDownloading = false.obs;
  RxBool offLine = false.obs;
  File? image;

  @override
  void onInit() {
    super.onInit();
    fetchVideoUrls();
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
          offLine.value = true;
          showToastSuccess("Playing in Offline!");
          controller.play();
          update();
        });
    } else {
      controller = VideoPlayerController.network(currentUrl)
        ..initialize().then((_) {
          offLine.value = false;
          showToastSuccess("Playing in Online!");
          controller.play();
          update();
        });
    }
  }

  Future<void> addToCache(String videoLink) async {
    isDownloading.value = true;

    try {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Could not get external storage directory");
      }

      final String fileName = path.basename(videoLink);
      final String localPath = path.join(directory.path, fileName);

      final File file = File(localPath);
      if (!file.existsSync()) {
        final Reference ref = FirebaseStorage.instance.refFromURL(videoLink);
        final DownloadTask downloadTask = ref.writeToFile(file);
        await downloadTask.whenComplete(() {});
      }

      await setSharedPrefrence(videoLink, file.path);
      isDownloading.value = false;
      offLine.value = true;
      showToastSuccess("Download Complete!");
    } catch (e) {
      isDownloading.value = false;
      offLine.value = false;
      showToastError("Download Failed: $e");
    }
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
    final Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception("Could not get external storage directory");
    }
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
