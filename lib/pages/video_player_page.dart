import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;

  // A sample video URL. Replace with your own.
  final String videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  // Variables for swipe-to-seek functionality
  double _dragStartX = 0.0;
  Duration _seekStartPos = Duration.zero;
  Duration _currentSeekPos = Duration.zero;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    // Force the screen into landscape mode when this widget is initialized.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );
    try {
      await _videoPlayerController.initialize();
      _createChewieController();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      // Handle player initialization error
      debugPrint("Error initializing video player: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      errorBuilder: (context, errorMessage) {
        return Material(
          child: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
      customControls: const CupertinoControls(
        backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
        iconColor: Colors.white,

      ),
    );
  }

  @override
  void dispose() {
    // Ensure controllers are disposed to free up resources.
    _videoPlayerController.dispose();
    _chewieController.dispose();

    // Reset preferred orientations to allow both portrait and landscape.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  // --- Gesture Handlers ---

  void _handleDoubleTap(TapDownDetails details) {
    // Get the screen width to determine if the tap was on the left or right half.
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    final currentPosition = _videoPlayerController.value.position;
    final videoDuration = _videoPlayerController.value.duration;

    // Seek 10 seconds forward if tapped on the right side.
    if (tapPosition > screenWidth / 2) {
      final newPosition = currentPosition + const Duration(seconds: 10);
      // Ensure we don't seek beyond the video's duration.
      if (newPosition < videoDuration) {
        _videoPlayerController.seekTo(newPosition);
      } else {
        _videoPlayerController.seekTo(videoDuration);
      }
    }
    // Seek 10 seconds backward if tapped on the left side.
    else {
      final newPosition = currentPosition - const Duration(seconds: 10);
      // Ensure we don't seek to a negative position.
      if (newPosition > Duration.zero) {
        _videoPlayerController.seekTo(newPosition);
      } else {
        _videoPlayerController.seekTo(Duration.zero);
      }
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (!_videoPlayerController.value.isInitialized) return;

    setState(() {
      _isSeeking = true;
      _dragStartX = details.globalPosition.dx;
      _seekStartPos = _videoPlayerController.value.position;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isSeeking) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final dragDistance = details.globalPosition.dx - _dragStartX;

    // Map drag distance to seek duration.
    // Here, dragging across half the screen seeks 60 seconds.
    // You can adjust this sensitivity.
    final seekAmount = (dragDistance / (screenWidth / 2)) * 60;
    final seekDuration = Duration(seconds: seekAmount.round());

    final newPosition = _seekStartPos + seekDuration;

    // Clamp the position to be within the video's duration
    final videoDuration = _videoPlayerController.value.duration;
    final clampedPosition = newPosition < Duration.zero
        ? Duration.zero
        : newPosition > videoDuration
        ? videoDuration
        : newPosition;
    setState(() {
      _currentSeekPos = clampedPosition;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_isSeeking) return;

    _videoPlayerController.seekTo(_currentSeekPos);
    setState(() {
      _isSeeking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        child: Center(
          child: _isLoading
              ? const CupertinoActivityIndicator(
                  radius: 20.0,
                  color: CupertinoColors.white,
                )
              : _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onDoubleTapDown: _handleDoubleTap,
                  onHorizontalDragStart: _onHorizontalDragStart,
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Chewie(controller: _chewieController),
                      // Show a seeking indicator when the user is swiping
                      if (_isSeeking) _buildSeekingIndicator(),
                    ],
                  ),
                )
              : const Text(
                  'Failed to load video.',
                  style: TextStyle(color: CupertinoColors.white),
                ),
        ),
      ),
    );
  }

  // A simple UI widget to show the user they are seeking.
  Widget _buildSeekingIndicator() {
    final positionText = _formatDuration(_currentSeekPos);
    final durationText = _formatDuration(_videoPlayerController.value.duration);
    final difference = _currentSeekPos - _seekStartPos;
    final differenceSign = difference.isNegative ? '-' : '+';
    final differenceText = _formatDuration(difference.abs());

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Material(
        color: Color(0x99000000),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$differenceSign$differenceText',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$positionText / $durationText',
                style: const TextStyle(
                  color: Color(
                    0xFFAEAEAE,
                  ), // Equivalent to CupertinoColors.lightBackgroundGray
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to format Duration into hh:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
