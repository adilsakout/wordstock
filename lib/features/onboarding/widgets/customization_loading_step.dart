import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordstock/widgets/button.dart';

class CustomizationLoadingStep extends StatefulWidget {
  const CustomizationLoadingStep({
    required this.title,
    required this.progress,
    required this.question,
    required this.isCompleted,
    this.onTap,
    super.key,
  });

  final String title;
  final double progress;
  final String question;
  final VoidCallback? onTap;
  final bool isCompleted;
  @override
  State<CustomizationLoadingStep> createState() =>
      _CustomizationLoadingStepState();
}

class _CustomizationLoadingStepState extends State<CustomizationLoadingStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (!widget.isCompleted)
              Text(
                '${(widget.progress * 100).toInt()}%',
              ),
            if (widget.isCompleted)
              const Icon(
                Icons.check_circle,
                color: Color(0xff58CC02),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (!widget.isCompleted)
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: widget.progress,
                minHeight: 10,
                color: const Color(0xff58CC02),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
        if (widget.isCompleted)
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        if (!widget.isCompleted &&
            widget.progress > 0.47 &&
            widget.progress < 0.5)
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
          ),
        if (!widget.isCompleted &&
            widget.progress > 0.47 &&
            widget.progress < 0.5)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'To move forward, specify',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                Text(
                  widget.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PushableButton(
                      width: 100,
                      height: 40,
                      text: 'No',
                      buttonColor: const Color(0xff58CC02),
                      shadowColor: const Color(0xff58A700),
                      onTap: widget.onTap ?? () {},
                    ),
                    const SizedBox(width: 20),
                    PushableButton(
                      width: 100,
                      height: 40,
                      text: 'Yes',
                      buttonColor: const Color(0xff58CC02),
                      shadowColor: const Color(0xff58A700),
                      onTap: widget.onTap ?? () {},
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 1.seconds),
      ],
    );
  }
}
