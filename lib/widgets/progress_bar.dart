import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.progress, super.key});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final currentWidth = constraints.maxWidth * progress;
        return Container(
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xffE5E5E5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Container(
                width: currentWidth,
                decoration: BoxDecoration(
                  color: const Color(0xff77D728),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment(0.9 * progress, -0.5),
                  child: progress > 0.27
                      ? Container(
                          width: 38,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xff9DED95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
