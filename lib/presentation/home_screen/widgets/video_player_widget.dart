import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/presentation/home_screen/widgets/vedio_listing.dart';
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
import '../controller/home_controller.dart';
import 'custom_controls_widget.dart';

class VideoPlayerWidget extends StatelessWidget {
  final List<Duration> timestamps;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const VideoPlayerWidget({
    required this.timestamps,
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoPlayerControllers videoPlayerController = Get.put(VideoPlayerControllers());
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final videoHeight = isPortrait ? 220.0 : MediaQuery.of(context).size.height - 20;

    return GetBuilder<VideoPlayerControllers>(
      builder: (controller) {
        return StreamBuilder<int>(
          stream: controller.timerStream(),
          builder: (context, snapshot) {
            return Column(
              children: [
                SizedBox(
                  height: videoHeight,
                  child: Stack(
                    alignment: Alignment(0.2, 0.52),
                    children: <Widget>[
                      VideoPlayer(controller.controller),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  scaffoldKey.currentState?.openDrawer();
                                },
                                child: SvgPicture.asset(
                                  assetsPath + "menu.svg",
                                  height: 18,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PROFILE);
                                },
                                child: controller.image == null
                                    ? Image.asset(
                                  assetsPath + "prof.png",
                                )
                                    : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.file(controller.image!))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                controller.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                if (controller.controller.value.isPlaying) {
                                  controller.controller.pause();
                                } else {
                                  controller.controller.play();
                                }
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: VideoProgressIndicator(
                                  controller.controller,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: Color(0xff57EE9D),
                                    backgroundColor: Color(0xff525252),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: Text(
                                '${controller.formatDuration(controller.controller.value.position)} / ${controller.formatDuration(controller.controller.value.duration)}',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CustomControlsWidget(
                          controller: controller.controller,
                          timestamps: timestamps,
                          onNextVideo: controller.playNextVideo,
                          onPreviousVideo: controller.playPreviousVideo,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.playPreviousVideo();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.grey.shade700 : Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: SvgPicture.asset(
                              assetsPath + "next-left.svg",
                              color: Colors.black,
                              height: 18,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.addToCache(controller.videoUrls[controller.currentIndex.value]);
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.grey.shade700 : Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              children: [
                                controller.isDownloading.value
                                    ? Image.asset(assetsPath + "dots.png")
                                    : SvgPicture.asset(
                                  assetsPath + "down.svg",
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                controller.offLine.value
                                    ? Text(
                                  "Downloaded",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                )
                                    : Text(
                                  controller.isDownloading.value ? "Downloading..." : "Download",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.playNextVideo();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.grey.shade700 : Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: SvgPicture.asset(
                            assetsPath + "next-right.svg",
                            color: Colors.black,
                            height: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                VideoListPage(),
              ],
            );
          },
        );
      },
    );
  }
}
