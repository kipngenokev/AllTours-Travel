import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_theme.dart';

/// A tap-to-play network video preview. Initialises lazily so lists stay light.
class VideoPreview extends StatefulWidget {
  final String url;
  const VideoPreview({super.key, required this.url});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? _controller;
  bool _initialising = false;

  Future<void> _start() async {
    if (_initialising || _controller != null) return;
    setState(() => _initialising = true);
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await c.initialize();
      c
        ..setLooping(true)
        ..play();
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _initialising = false;
      });
    } catch (_) {
      c.dispose();
      if (mounted) setState(() => _initialising = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: _controller != null && _controller!.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller!),
                    _PlayPauseOverlay(controller: _controller!),
                  ],
                )
              : Center(
                  child: _initialising
                      ? const CircularProgressIndicator(color: Colors.white)
                      : _PlayButton(onTap: _start),
                ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PlayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.play_arrow_rounded,
            color: Colors.white, size: 40),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const _PlayPauseOverlay({required this.controller});

  @override
  State<_PlayPauseOverlay> createState() => _PlayPauseOverlayState();
}

class _PlayPauseOverlayState extends State<_PlayPauseOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
        });
      },
      child: AnimatedOpacity(
        opacity: widget.controller.value.isPlaying ? 0 : 1,
        duration: const Duration(milliseconds: 250),
        child: Container(
          color: Colors.black26,
          child: const Center(
            child: Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 56),
          ),
        ),
      ),
    );
  }
}
