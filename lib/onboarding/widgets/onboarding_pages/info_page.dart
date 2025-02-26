import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordstock/onboarding/cubit/cubit.dart';
import 'package:wordstock/widgets/button.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    this.imageWidth = 200,
    this.imageHeight = 200,
    super.key,
  });

  final String image;
  final double imageWidth;
  final double imageHeight;
  final String title;
  final String description;
  final String buttonText;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: 0.5.seconds,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              widget.image,
              width: widget.imageWidth,
              height: widget.imageHeight,
            )
                .animate(controller: _animationController)
                .fadeIn(duration: .5.seconds),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(controller: _animationController)
                      .fadeIn(duration: 0.5.seconds),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                      .animate(controller: _animationController)
                      .fadeIn(duration: 0.5.seconds),
                  const Spacer(),
                  PushableButton(
                    width: 200,
                    height: 60,
                    borderRadius: 20,
                    text: widget.buttonText,
                    onTap: () {
                      _animationController.reverse().then((_) {
                        context.read<OnboardingCubit>().nextPage();
                      });
                    },
                  )
                      .animate(controller: _animationController)
                      .fadeIn(duration: 0.5.seconds),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
