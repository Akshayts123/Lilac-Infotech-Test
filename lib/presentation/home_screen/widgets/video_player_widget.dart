import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/presentation/home_screen/widgets/vedio_listing.dart';
import 'package:lilac_infotech/presentation/profile_screen/controller/profile_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/assets_utils.dart';
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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final videoHeight =
        isPortrait ? 220.0 : MediaQuery.of(context).size.height - 20;
    final profileController = Get.put(ProfileController());
    return GetBuilder<VideoPlayerControllers>(
      builder: (controller) {
        return StreamBuilder<int>(
          stream: controller.timerStream(),
          builder: (context, snapshot) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {

                    controller.toggleUIVisibility();
                  },
                  child: SizedBox(
                    height: videoHeight,
                    child: Stack(
                      alignment: Alignment(0.2, 0.52),
                      children: <Widget>[
                        VideoPlayer(controller.controller),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: AnimatedOpacity(
                            opacity: controller.isUIVisible.value ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
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
                                    child: profileController.image == null
                                        ? Image.asset(
                                            assetsPath + "prof.png",
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                    height: 90,
                                                    width: 90,
                                                    child: Image.file(
                                                        profileController
                                                            .image!))),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: controller.isUIVisible.value ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    controller.controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
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
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Text(
                                    '${controller.formatDuration(controller.controller.value.position)} / ${controller.formatDuration(controller.controller.value.duration)}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: controller.isUIVisible.value ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
                            child: CustomControlsWidget(
                              controller: controller.controller,
                              timestamps: timestamps,
                              onNextVideo: controller.playNextVideo,
                              onPreviousVideo: controller.playPreviousVideo,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.white,
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
                          if (!controller.offLine.value) {
                            controller.addToCache(controller
                                .videoUrls[controller.currentIndex.value]);
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.grey.shade700
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                controller.offLine.value
                                    ? Container() // Blank container when downloaded
                                    : controller.isDownloading.value
                                        ? Image.asset(assetsPath + "dots.png")
                                        : SvgPicture.asset(
                                            assetsPath + "down.svg",
                                            height: 12,
                                          ),
                                SizedBox(width: 8),
                                Text(
                                  controller.offLine.value
                                      ? "Downloaded"
                                      : controller.isDownloading.value
                                          ? "Downloading..."
                                          : "Download",
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.white,
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
