import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/widgets/button.dart';

class QuizInitial extends StatefulWidget {
  const QuizInitial({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  State<QuizInitial> createState() => _QuizInitialState();
}

class _QuizInitialState extends State<QuizInitial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  // Add audio player for la-la-la sound effect
  final AudioPlayer _introSoundPlayer = AudioPlayer();
  bool _soundLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20),
    );

    // Load and play intro sound
    _loadAndPlaySound();

    // Start forward animation automatically
    _animationController.forward();
  }

  Future<void> _loadAndPlaySound() async {
    if (_soundLoaded) return;

    try {
      await _introSoundPlayer.setSource(AssetSource('sounds/fa-la-la.mp3'));
      await _introSoundPlayer.setVolume(0.7);
      await _introSoundPlayer.resume();
      _soundLoaded = true;
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _introSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffE94E77),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.quizIcon,
                    width: 100,
                    height: 100,
                    colorFilter: const ColorFilter.mode(
                      Color(0xffE94E77),
                      BlendMode.srcIn,
                    ),
                  )
                      .animate(controller: _animationController)
                      .fadeIn(duration: 300.ms, curve: Curves.easeOutCubic)
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        duration: 350.ms,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xffE94E77),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Vocabulary Quiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(controller: _animationController)
            .fadeIn(duration: 250.ms)
            .slideY(
              begin: 0.2,
              end: 0,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: 16),
        const SizedBox(
          width: 200,
          child: Text(
            'Test your vocabulary knowledge with this fun quiz!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        )
            .animate(controller: _animationController)
            .fadeIn(delay: 150.ms, duration: 250.ms),
        const SizedBox(height: 16),
        PushableButton(
          width: 100,
          height: 56,
          buttonColor: const Color(0xffE94E77),
          shadowColor: const Color(0xff963E00),
          text: 'Start',
          onTap: () {
            // Add haptic feedback
            Gaimon.light();
            widget.onTap();
          },
        )
            .animate(controller: _animationController)
            .fadeIn(delay: 300.ms, duration: 250.ms)
            .slideY(
              delay: 300.ms,
              begin: 0.3,
              end: 0,
              duration: 250.ms,
              curve: Curves.easeOutCubic,
            )
            .shimmer(
              delay: 600.ms,
              duration: 1500.ms,
              color: Colors.white.withAlpha(77),
              size: 0.5,
            ),
      ],
    );
  }
}
