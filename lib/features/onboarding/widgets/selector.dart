import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

class Selector extends StatefulWidget {
  const Selector({
    required this.text,
    required this.onTap,
    super.key,
    this.selected = false,
    this.isMultipleChoice = false,
  });
  final String text;
  final VoidCallback onTap;
  final bool selected;
  final bool isMultipleChoice;
  @override
  SelectorState createState() => SelectorState();
}

class SelectorState extends State<Selector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    if (widget.selected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Selector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gaimon.selection();
        widget.onTap();
      },
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        width: double.infinity,
        height: 56,
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
                    height: 56 - 10,
                    decoration: BoxDecoration(
                      color: const Color(0xff999999),
                      borderRadius: BorderRadius.circular(15),
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
                    height: 56 - 10,
                    decoration: BoxDecoration(
                      color: widget.selected
                          ? const Color(0xffDDF4FF)
                          : const Color(0xffFFFFFF),
                      border: Border.all(
                        color: widget.selected
                            ? const Color(0xff1899D6)
                            : const Color(0xff999999),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.selected
                                ? const Color(0xff1899D6)
                                : const Color(0xff999999),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.selected
                                ? const Color(0xff1899D6)
                                : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: widget.selected
                                  ? const Color(0xff1899D6)
                                  : const Color(0xff999999),
                            ),
                            shape: widget.isMultipleChoice
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: widget.isMultipleChoice
                                ? BorderRadius.circular(8)
                                : null,
                          ),
                          child: widget.selected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : const SizedBox(),
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
