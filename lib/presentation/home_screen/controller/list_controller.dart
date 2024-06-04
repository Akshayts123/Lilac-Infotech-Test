import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class VideoListController extends GetxController {
  var videoUrls = <String>[].obs;
  var videoThumbnails = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideoUrls();
  }

  Future<void> fetchVideoUrls() async {
    List<String> urls = await getVideoUrls();
    videoUrls.assignAll(urls);
    // await fetchVideoThumbnails(urls);
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

  Future<void> fetchVideoThumbnails(List<String> urls) async {
    List<String> thumbnails = [];
    for (var url in urls) {
      final String thumbnailUrl = await getVideoThumbnailUrl(url);
      thumbnails.add(thumbnailUrl);
    }
    videoThumbnails.assignAll(thumbnails);
  }

  Future<String> getVideoThumbnailUrl(String videoUrl) async {
    String thumbnailName = videoUrl.split('/').last.replaceFirst('.mp4', '_thumbnail.jpg');
    Reference thumbnailRef = FirebaseStorage.instance.ref('Thumbnails/$thumbnailName');
    return await thumbnailRef.getDownloadURL();
  }
}
