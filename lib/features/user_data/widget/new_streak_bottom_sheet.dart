import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

class NewStreakBottomSheet extends StatelessWidget {
  const NewStreakBottomSheet({
    required this.currentStreak,
    super.key,
  });

  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Get the appropriate congratulatory message based on streak count
    String getCongratulationsMessage() {
      if (currentStreak < 2) {
        return l10n.streakCongratulationsSingular;
      } else {
        return l10n.streakCongratulationsMessage(currentStreak);
      }
    }

    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(77),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 50),
              SvgPicture.asset(Assets.icons.flame)
                  .animate()
                  .scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(2.5, 2.5),
                  )
                  .then()
                  .shake(
                    hz: 4,
                    rotation: 0.1,
                    duration: 1000.ms,
                  ),
              const SizedBox(height: 40),
              Text(
                l10n.streakMilestoneTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffF97316),
                    ),
              ).animate().fadeIn(duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutQuad,
                  ),
              Text(
                l10n.streakDaysCount(currentStreak),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xffF97316),
                    ),
              ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutQuad,
                  ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  getCongratulationsMessage(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 600.ms),
              const SizedBox(height: 32),
              PushableButton(
                text: l10n.keepGoing,
                width: 200,
                height: 56,
                buttonColor: const Color(0xffF97316),
                shadowColor: const Color(0xffE86A10),
                onTap: () {
                  Navigator.pop(context);
                },
              ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                  ),
              const SafeArea(child: SizedBox.shrink()),
            ],
          ),
        ),
      ],
    );
  }
}
