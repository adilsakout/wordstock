import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class QuizButton extends StatefulWidget {
  const QuizButton({
    required this.width,
    required this.height,
    required this.text,
    required this.onTap,
    super.key,
    this.buttonColor = const Color(0xFF77D728),
    this.shadowColor = const Color(0xFF49A100),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.white,
    this.borderRadius = 30.0,
  });
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color shadowColor;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  @override
  QuizButtonState createState() => QuizButtonState();
}

class QuizButtonState extends State<QuizButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final top = _animationController.value * 8;
            return Stack(
              children: [
                // Shadow layer
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: widget.height - 10,
                    decoration: BoxDecoration(
                      color: widget.shadowColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
                // Button layer
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: widget.height - 10,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      border: Border.all(color: widget.buttonColor, width: 2),
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
