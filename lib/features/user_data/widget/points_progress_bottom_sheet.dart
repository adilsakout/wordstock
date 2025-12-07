import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
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

    Gaimon.heavy();

    // Duolingo-style colors
    const coinYellow = Color(0xFFFFC800);
    const lockedGrey = Color(0xFFE5E5E5);
    const textGrey = Color(0xFF4B4B4B);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Drag handle
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 32),

            // Hero Section: Coin + Big Number
            Column(
              children: [
                SvgPicture.asset(
                  Assets.icons.coin,
                  width: 80,
                  height: 80,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: -0.05, end: 0.05),
                const SizedBox(height: 16),
                Text(
                  '$totalPoints',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: coinYellow,
                        height: 1,
                        fontSize: 64,
                      ),
                ).animate().fadeIn().scale(delay: 200.ms),
                Text(
                  l10n.totalPoints.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.5,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Milestones Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pointsLearningJourney,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: textGrey,
                        ),
                  ).animate().fadeIn().slideX(begin: -0.1),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: lockedGrey, width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildTimelineItem(
                          context,
                          title: l10n.achievementWordExplorer,
                          targetPoints: 100,
                          currentPoints: totalPoints,
                          color: Colors.green,
                          isFirst: true,
                        ),
                        _buildTimelineItem(
                          context,
                          title: l10n.achievementVocabularyBuilder,
                          targetPoints: 500,
                          currentPoints: totalPoints,
                          color: Colors.blue,
                        ),
                        _buildTimelineItem(
                          context,
                          title: l10n.achievementLanguageMaster,
                          targetPoints: 1000,
                          currentPoints: totalPoints,
                          color: Colors.purple,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

            const SizedBox(height: 32),

            // Motivation Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.pointsMotivationMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textGrey,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
              ).animate(delay: 500.ms).fadeIn(),
            ),

            const SizedBox(height: 32),

            // Action Button
            PushableButton(
              text: l10n.closeButton,
              width: MediaQuery.of(context).size.width - 48,
              height: 56,
              buttonColor: coinYellow,
              shadowColor: const Color(0xFFCC9900), // Darker yellow
              onTap: () {
                Navigator.pop(context);
              },
            ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.5, end: 0),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String title,
    required int targetPoints,
    required int currentPoints,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isAchieved = currentPoints >= targetPoints;
    final isNext = !isAchieved &&
        (isFirst ||
            currentPoints >=
                (targetPoints == 500
                    ? 100
                    : targetPoints == 1000
                        ? 500
                        : 0)); // Simple logic based on hardcoded steps

    // Determine the progress for this specific level step
    var progress = 0.0;
    if (isAchieved) {
      progress = 1.0;
    } else if (isNext) {
      final previousTarget = targetPoints == 100
          ? 0
          : targetPoints == 500
              ? 100
              : 500;
      progress =
          (currentPoints - previousTarget) / (targetPoints - previousTarget);
      progress = progress.clamp(0.0, 1.0);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Column
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Top Line
                Expanded(
                  child: isFirst
                      ? const SizedBox()
                      : Container(
                          width: 4,
                          color: isAchieved || isNext
                              ? color.withValues(alpha: 0.3)
                              : const Color(0xFFE5E5E5),
                        ),
                ),
                // Dot/Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isAchieved ? color : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isAchieved
                          ? color
                          : (isNext ? color : const Color(0xFFE5E5E5)),
                      width: isAchieved ? 0 : 3,
                    ),
                  ),
                  child: isAchieved
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                // Bottom Line
                Expanded(
                  child: isLast
                      ? const SizedBox()
                      : Container(
                          width: 4,
                          color: isAchieved
                              ? color.withValues(alpha: 0.3)
                              : const Color(0xFFE5E5E5),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: isAchieved || isNext
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isAchieved || isNext
                                      ? const Color(0xFF4B4B4B)
                                      : Colors.grey.shade400,
                                ),
                      ),
                      Text(
                        '$targetPoints XP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isAchieved ? color : Colors.grey.shade400,
                            ),
                      ),
                    ],
                  ),
                  if (isNext) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE5E5E5),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% to go',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
