import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PushableButton extends StatefulWidget {
  const PushableButton({
    required this.width,
    required this.height,
    required this.text,
    required this.onTap,
    super.key,
    this.buttonColor = const Color(0xFF77D728),
    this.shadowColor = const Color(0xFF49A100),
    this.textColor = Colors.white,
    this.borderRadius = 30.0,
    this.iconSize = 20.0,
    this.suffixIcon,
    this.prefixIcon,
    this.spacing = 0.0,
    this.shouldPlaySound = true,
  });
  final double width;
  final double height;
  final String text;
  final bool shouldPlaySound;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color shadowColor;
  final Color textColor;
  final double borderRadius;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final double spacing;
  final double iconSize;
  @override
  PushableButtonState createState() => PushableButtonState();
}

class PushableButtonState extends State<PushableButton>
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
    if (widget.shouldPlaySound) {
      _playSound();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
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
                      color: widget.buttonColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Row(
                      spacing: widget.spacing,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.prefixIcon != null)
                          Icon(
                            widget.prefixIcon,
                            color: widget.textColor,
                            size: widget.iconSize,
                          ),
                        if (widget.text.isNotEmpty)
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (widget.suffixIcon != null)
                          Icon(
                            widget.suffixIcon,
                            color: widget.textColor,
                            size: widget.iconSize,
                          ),
                      ],
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
