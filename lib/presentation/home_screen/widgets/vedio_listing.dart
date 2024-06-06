import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/list_controller.dart';

class VideoListPage extends StatelessWidget {
  final  videoController = Get.put(VideoListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return videoController.videoUrls.isEmpty
          ? Container()
          : ListView.builder(
        itemCount: videoController.videoUrls.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              'Playlist vedio ${index + 1}',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            subtitle: Text(
              videoController.videoUrls[index],
              style: GoogleFonts.poppins(fontSize: 10),
            ),
            leading: videoController.videoThumbnails.isNotEmpty
                ? Image.network(videoController.videoThumbnails[index])
                : Image.asset('assets/thumbnail.jpeg'),
            onTap: () {
              // Get.to(MyHomePage());
            },
          );
        },
      );
    });
  }
}
