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
              const SizedBox(height: 40),

              // Points display
              SvgPicture.asset(
                Assets.icons.coin,
                width: 60,
                height: 60,
                colorFilter: const ColorFilter.mode(
                  Color(0xffFFC20E),
                  BlendMode.srcIn,
                ),
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 500.ms,
                  ),

              const SizedBox(height: 24),
              Text(
                '$totalPoints',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffFFC20E),
                    ),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3, end: 0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.totalPoints,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    _buildPointsText(context, totalPoints),
                  ],
                ).animate(delay: 400.ms).fadeIn(),
              ),

              const SizedBox(height: 40),

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
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(),

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

              const SizedBox(height: 40),
              PushableButton(
                text: l10n.closeButton,
                width: 200,
                height: 56,
                buttonColor: const Color(0xffFFC20E),
                shadowColor: const Color(0xffFF9900),
                onTap: () {
                  Navigator.pop(context);
                },
              ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.3, end: 0),
              const SafeArea(child: SizedBox(height: 20)),
            ],
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

  Text _buildPointsText(BuildContext context, int points) {
    return Text(
      context.l10n.pointsFormat(points),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
    );
  }
}
