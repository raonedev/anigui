import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.videoUrls});
   final List<String> videoUrls;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
   late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;
  int _currentVideoIndex = 0;
  
  // Variables for swipe-to-seek functionality
  double _dragStartX = 0.0;
  Duration _seekStartPos = Duration.zero;
  Duration _currentSeekPos = Duration.zero;
  bool _isSeeking = false;

  // Variables for brightness and volume control
  double _dragStartY = 0.0;
  double _currentBrightness = 0.5;
  double _currentVolume = 0.5;
  bool _isAdjustingBrightness = false;
  bool _isAdjustingVolume = false;
  double _initialBrightness = 0.5;
  double _initialVolume = 0.5;

   @override
  void initState() {
    super.initState();
    // Force the screen into landscape mode when this widget is initialized.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializePlayer();
    _initializeBrightnessAndVolume();
  }

  Future<void> _initializeBrightnessAndVolume() async {
    try {
      // Get current brightness
      _currentBrightness = await ScreenBrightness().application;
      _initialBrightness = _currentBrightness;
      
      // Get current volume
      _currentVolume = await VolumeController.instance.getVolume();
      _initialVolume = _currentVolume;
      
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing brightness/volume: $e');
    }
  }
  
  Future<void> _initializePlayer() async {
    // If we've tried all URLs, show error
    if (_currentVideoIndex >= widget.videoUrls.length) {
      log("we've tried all URLs");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final videoUrl = widget.videoUrls[_currentVideoIndex];
    if(videoUrl.isEmpty) {
      _tryNextVideo();
      return;
    }

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
      _videoPlayerController.dispose();
      _tryNextVideo();
    }

    VolumeController.instance.showSystemUI = false;
  }
  
   void _tryNextVideo() {
    log("_tryNextVideo");
    setState(() {
      _currentVideoIndex++;
      _isLoading = true;
    });
    _initializePlayer();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load video ${_currentVideoIndex + 1}/${widget.videoUrls.length}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _tryNextVideo,
                  child: const Text('Try Next Video'),
                ),
              ],
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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

  void _onPanStart(DragStartDetails details) {
    if (!_videoPlayerController.value.isInitialized) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final startX = details.globalPosition.dx;
    final startY = details.globalPosition.dy;

    setState(() {
      _dragStartX = startX;
      _dragStartY = startY;
      
      // Determine if this is a brightness, volume, or seek gesture based on position
      if (startX < screenWidth * 0.3) {
        // Left side - brightness control
        _isAdjustingBrightness = true;
        _initialBrightness = _currentBrightness;
      } else if (startX > screenWidth * 0.7) {
        // Right side - volume control
        _isAdjustingVolume = true;
        _initialVolume = _currentVolume;
      } else {
        // Center - seek control (horizontal only)
        _isSeeking = true;
        _seekStartPos = _videoPlayerController.value.position;
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentX = details.globalPosition.dx;
    final currentY = details.globalPosition.dy;

    if (_isAdjustingBrightness) {
      // Brightness control - vertical drag on left side
      final dragDistance = _dragStartY - currentY; // Inverted for intuitive control
      final sensitivity = 2.0 / screenHeight; // Adjust sensitivity as needed
      final brightnessChange = dragDistance * sensitivity;
      
      final newBrightness = (_initialBrightness + brightnessChange).clamp(0.0, 1.0);
      
      setState(() {
        _currentBrightness = newBrightness;
      });
      
      ScreenBrightness().setApplicationScreenBrightness(newBrightness);
      
    } else if (_isAdjustingVolume) {
      // Volume control - vertical drag on right side
      final dragDistance = _dragStartY - currentY; // Inverted for intuitive control
      final sensitivity = 1.0 / screenHeight; // Adjust sensitivity as needed
      final volumeChange = dragDistance * sensitivity;
      
      final newVolume = (_initialVolume + volumeChange).clamp(0.0, 1.0);
      
      setState(() {
        _currentVolume = newVolume;
      });
      
      VolumeController.instance.setVolume(newVolume);
      
    } else if (_isSeeking) {
      // Seek control - horizontal drag in center
      final dragDistance = currentX - _dragStartX;
      final seekAmount = (dragDistance / (screenWidth / 2)) * 60;
      final seekDuration = Duration(seconds: seekAmount.round());
      final newPosition = _seekStartPos + seekDuration;
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
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSeeking) {
      _videoPlayerController.seekTo(_currentSeekPos);
    }
    
    setState(() {
      _isSeeking = false;
      _isAdjustingBrightness = false;
      _isAdjustingVolume = false;
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
              : _currentVideoIndex >= widget.videoUrls.length
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'All videos failed to load.',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentVideoIndex = 0;
                              _isLoading = true;
                            });
                            _initializePlayer();
                          },
                          child: const Text('Retry All Videos'),
                        ),
                      ],
                    )
                  : _videoPlayerController.value.isInitialized
                      ? GestureDetector(
                          onDoubleTapDown: _handleDoubleTap,
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Chewie(controller: _chewieController),
                              // Show indicators when adjusting
                              if (_isSeeking) _buildSeekingIndicator(),
                              if (_isAdjustingBrightness) _buildBrightnessIndicator(),
                              if (_isAdjustingVolume) _buildVolumeIndicator(),
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

  // Seeking indicator
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
                  color: Color(0xFFAEAEAE),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Brightness indicator
  Widget _buildBrightnessIndicator() {
    final percentage = (_currentBrightness * 100).round();
    
    return Positioned(
      left: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Material(
          color: Color(0x99000000),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _currentBrightness > 0.5 
                      ? CupertinoIcons.brightness_solid 
                      : CupertinoIcons.brightness,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Volume indicator
  Widget _buildVolumeIndicator() {
    final percentage = (_currentVolume * 100).round();
    
    return Positioned(
      right: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Material(
          color: Color(0x99000000),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _currentVolume == 0 
                      ? CupertinoIcons.speaker_slash_fill
                      : _currentVolume < 0.3
                      ? CupertinoIcons.speaker_1_fill
                      : _currentVolume < 0.7
                      ? CupertinoIcons.speaker_2_fill
                      : CupertinoIcons.speaker_3_fill,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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