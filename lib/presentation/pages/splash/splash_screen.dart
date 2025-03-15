import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play_world/presentation/pages/auth/controller/auth_controller.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');
    
    await _videoController.initialize();
    await _videoController.setLooping(false);
    
    // Set video to full screen by setting the aspect ratio
    _videoController.setVolume(1.0);
    
    setState(() {
      _isVideoInitialized = true;
    });
    
    // Play the video
    await _videoController.play();
    
    // Listen for video completion
    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        _checkAuthAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _checkAuthAndNavigate() {
    final authState = ref.read(authControllerProvider);
    authState.whenData((user) {
      if (mounted) {
        if (user != null) {
          context.go('/');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isVideoInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
    );
  }
} 