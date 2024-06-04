import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/assets_utils.dart';

class CustomControlsWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final List<Duration> timestamps;
  final VoidCallback onNextVideo;
  final VoidCallback onPreviousVideo;

  const CustomControlsWidget({
    required this.controller,
    required this.timestamps,
    required this.onNextVideo,
    required this.onPreviousVideo,
    Key? key,
  }) : super(key: key);

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                buildButton(
                    SvgPicture.asset(
                      assetsPath + "left.svg",
                      height: 15,
                    ),
                    widget.onPreviousVideo),
                SizedBox(width: 0),
                buildButton(
                    Icon(
                      Icons.replay_5,
                      color: Colors.white,
                      size: 20,
                    ),
                    rewind5Seconds),
                SizedBox(width: 0),
                buildButton(
                    Icon(
                      Icons.forward_5,
                      color: Colors.white,
                      size: 20,
                    ),
                    forward5Seconds),
                SizedBox(width: 0),
                buildButton(
                    SvgPicture.asset(
                      assetsPath + "right.svg",
                      height: 15,
                    ),
                    widget.onNextVideo),
                SizedBox(width: 0),
                buildButton(
                  Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 20,
                  ),
                  toggleMute,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                    SvgPicture.asset(
                      assetsPath + "setting.svg",
                      height: 15,
                    ),
                    openSettings),
                SizedBox(width: 0),
                buildButton(
                    SvgPicture.asset(
                      assetsPath + "full.svg",
                      height: 15,
                    ),
                    toggleFullscreen),
              ],
            ),
          ],
        ),
      );

  Widget buildButton(Widget child, Function onPressed) => Container(
        height: 50,
        width: 50,
        child: TextButton(
          child: child,
          onPressed: onPressed as void Function()?,
        ),
      );

  Future rewindToPosition() async {
    if (widget.timestamps.isEmpty) return;
    Duration rewind(Duration currentPosition) => widget.timestamps.lastWhere(
          (element) => currentPosition > element + Duration(seconds: 2),
          orElse: () => Duration.zero,
        );

    await goToPosition(rewind);
  }

  Future forwardToPosition() async {
    if (widget.timestamps.isEmpty) return;
    Duration forward(Duration currentPosition) => widget.timestamps.firstWhere(
          (position) => currentPosition < position,
          orElse: () => Duration(days: 1),
        );

    await goToPosition(forward);
  }

  Future forward5Seconds() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));

  Future rewind5Seconds() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await widget.controller.position;
    final newPosition = builder(currentPosition!);

    await widget.controller.seekTo(newPosition);
  }

  void toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      widget.controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void openSettings() {
    // Placeholder for settings functionality
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('Settings button pressed'),
    ));
  }

  void toggleFullscreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
