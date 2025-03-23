import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingQuiz extends StatelessWidget {
  const LoadingQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 80,
            color: Color(0xffE94E77),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(
                duration: 700.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                duration: 700.ms,
                begin: const Offset(1.1, 1.1),
                end: const Offset(1, 1),
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 24),
          const Text(
            'Preparing your quiz...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xffE94E77),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 800.ms)
              .then()
              .fadeOut(duration: 800.ms),
        ],
      ),
    );
  }
}
