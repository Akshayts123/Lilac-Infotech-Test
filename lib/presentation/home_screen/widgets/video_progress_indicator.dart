import 'package:flutter/material.dart';
import 'package:lilac_infotech/presentation/home_screen/widgets/video_controls_widget.dart';
import 'package:video_player/video_player.dart';

class CustomVideoProgressIndicator extends StatefulWidget {
  CustomVideoProgressIndicator(
    this.controller, {
    VideoProgressColors? colors,
    this.allowScrubbing = false,
    this.padding = const EdgeInsets.only(top: 5.0),
    this.timestamps,
  }) : colors = colors ?? VideoProgressColors();

  final VideoPlayerController controller;

  final VideoProgressColors colors;

  final List<Duration>? timestamps;

  final bool allowScrubbing;

  final EdgeInsets padding;

  @override
  _CustomVideoProgressIndicatorState createState() =>
      _CustomVideoProgressIndicatorState();
}

class _CustomVideoProgressIndicatorState
    extends State<CustomVideoProgressIndicator> {
  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  List<int> durationDifferences = [];
  void _onPlaybackStateChanged() {
    if (mounted) {
      setState(() {}); // Update the widget state
    }
  }

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      _onPlaybackStateChanged(); // Call the method when playback state changes
    };
    controller.addListener(listener);
    if (controller.value.isInitialized) {
      calculateDurationDiffs();
    } else {
      controller.addListener(_onVideoInitialized);
    }
  }

  void _onVideoInitialized() {
    if (controller.value.isInitialized) {
      calculateDurationDiffs();
      controller.removeListener(_onVideoInitialized);
    }
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  void calculateDurationDiffs() {
    final timestamps = widget.timestamps ?? [];
    if (timestamps.isEmpty) return;

    durationDifferences.clear();

    final firstDifference =
        timestamps.first.inSeconds - Duration.zero.inSeconds;
    durationDifferences.add(firstDifference);

    for (int i = 0; i < timestamps.length - 1; i++) {
      final difference = timestamps[i + 1].inSeconds - timestamps[i].inSeconds;
      durationDifferences.add(difference);
    }

    final lastDifference =
        controller.value.duration.inSeconds - timestamps.last.inSeconds;
    durationDifferences.add(lastDifference);
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          LinearProgressIndicator(
            value: maxBuffering / duration,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff525252)),
            backgroundColor: colors.backgroundColor,
          ),
          LinearProgressIndicator(
            value: position / duration,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff57EE9D)),
            backgroundColor: Colors.transparent,
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }

    final Widget paddedProgressIndicator = Stack(
      children: [
        Container(
          height: 3,
          child: progressIndicator,
        ),
        if (durationDifferences.isNotEmpty)
          Container(
            height: 3,
            child: Row(
              children: durationDifferences
                  .map(
                    (difference) => Expanded(
                      flex: difference,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: double.infinity,
                          width: 2,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );

    final progressBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: 30,
            width: 30,
            child: VideoControlsWidget(controller: controller)),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: paddedProgressIndicator,
        )),
        // if (controller.value.isInitialized)
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Text(
            '${_formatDuration(controller.value.position)} / ${_formatDuration(controller.value.duration)}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );

    if (widget.allowScrubbing) {
      return _VideoScrubber(
        child: progressBar,
        controller: controller,
      );
    } else {
      return progressBar;
    }
  }
}

class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final VideoPlayerController controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  void seekToRelativePosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position = controller.value.duration * relative;
    controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}
