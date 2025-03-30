import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/widgets/button.dart';

class PointsProgressBottomSheet extends StatelessWidget {
  const PointsProgressBottomSheet({
    required this.userProfile,
    super.key,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalPoints = userProfile.totalPoints ?? 0;

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
                color: Colors.black.withValues(alpha: 0.1),
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
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.coin,
                      width: 32,
                      height: 32,
                      colorFilter: const ColorFilter.mode(
                        Color(0xffFFC20E),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.pointsProgressTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffFFC20E),
                          ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideX(
                      begin: -0.2,
                      end: 0,
                      curve: Curves.easeOutQuad,
                    ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.totalPoints,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalPoints',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffFFC20E),
                    ),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 30),

              // Achievement levels
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pointsLearningJourney,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildAchievementLevel(
                      context,
                      name: l10n.achievementWordExplorer,
                      points: 100,
                      currentPoints: totalPoints,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    _buildAchievementLevel(
                      context,
                      name: l10n.achievementVocabularyBuilder,
                      points: 500,
                      currentPoints: totalPoints,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    _buildAchievementLevel(
                      context,
                      name: l10n.achievementLanguageMaster,
                      points: 1000,
                      currentPoints: totalPoints,
                      color: Colors.purple,
                    ),

                    // Add progress towards next level
                    const SizedBox(height: 16),
                    _buildNextLevelProgress(context, totalPoints),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.pointsMotivationMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 30),
              PushableButton(
                text: l10n.closeButton,
                width: 200,
                height: 56,
                buttonColor: const Color(0xffFFC20E),
                shadowColor: const Color(0xffFF9900),
                onTap: () {
                  Navigator.pop(context);
                },
              ).animate(delay: 800.ms).fadeIn(duration: 400.ms).slideY(
                    begin: 0.3,
                    end: 0,
                  ),
              const SafeArea(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextLevelProgress(BuildContext context, int currentPoints) {
    final l10n = context.l10n;

    // Determine next level threshold and color
    int nextLevelPoints;
    Color nextLevelColor;

    if (currentPoints < 100) {
      nextLevelPoints = 100;
      nextLevelColor = Colors.green;
    } else if (currentPoints < 500) {
      nextLevelPoints = 500;
      nextLevelColor = Colors.blue;
    } else {
      nextLevelPoints = 1000;
      nextLevelColor = Colors.purple;
    }

    // Calculate progress percentage
    final previousLevelPoints = currentPoints < 100
        ? 0
        : currentPoints < 500
            ? 100
            : 500;

    final progressPercentage = nextLevelPoints <= currentPoints
        ? 100
        : ((currentPoints - previousLevelPoints) /
                (nextLevelPoints - previousLevelPoints) *
                100)
            .toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.percentToGoal(progressPercentage),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progressPercentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(nextLevelColor),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementLevel(
    BuildContext context, {
    required String name,
    required int points,
    required int currentPoints,
    required Color color,
  }) {
    final l10n = context.l10n;
    final isAchieved = currentPoints >= points;

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAchieved ? color : Colors.grey.shade300,
          ),
          child: isAchieved
              ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isAchieved ? FontWeight.w600 : FontWeight.normal,
                color: isAchieved ? Colors.black87 : Colors.black54,
              ),
        ),
        const Spacer(),
        Text(
          l10n.pointsFormat(points),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isAchieved ? FontWeight.w600 : FontWeight.normal,
                color: isAchieved ? color : Colors.grey,
              ),
        ),
      ],
    );
  }
}
