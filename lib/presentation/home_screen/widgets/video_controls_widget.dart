import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControlsWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControlsWidget({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? Container(
                    key: ValueKey<bool>(true),
                    child: Center(
                      child: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  )
                : Container(
                    key: ValueKey<bool>(false),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            },
            child: Container(
              color: Colors.transparent, // Make the tap area transparent
              width: double.infinity, // Expand to full width
              height: double.infinity, // Expand to full height
            ),
          ),
        ],
      );
}
