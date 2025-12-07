import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/widgets/button.dart';

class StreakProgressBottomSheet extends StatelessWidget {
  const StreakProgressBottomSheet({
    required this.userProfile,
    super.key,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentStreak = userProfile.dailyStreak;
    final streakGoal = userProfile.streakGoal ?? 7; // Default to 7 if not set

    Gaimon.heavy();

    // Create a list of abbreviated day names
    //(2 characters) starting from the current day
    final allWeekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today =
        DateTime.now().weekday - 1; // 0-based (0 = Monday, 6 = Sunday)

    // Get the days in a new order: previous 5 days, today, and tomorrow
    final weekDays = <String>[];

    // Add 5 previous days (oldest first)
    for (var i = 5; i >= 1; i--) {
      final previousDayIndex = (today - i) % 7;
      final adjustedIndex =
          previousDayIndex < 0 ? previousDayIndex + 7 : previousDayIndex;
      weekDays.add(allWeekDays[adjustedIndex]);
    }

    // Add today
    weekDays.add(allWeekDays[today]);

    // Add tomorrow
    final tomorrowIndex = (today + 1) % 7;
    weekDays.add(allWeekDays[tomorrowIndex]);

    final dayLabels = weekDays;

    // Duolingo-style colors
    const fireOrange = Color(0xFFFF9600);
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
            color: Colors.black.withOpacity(0.1),
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 32),

            // Hero Section: Flame + Big Number
            Column(
              children: [
                SvgPicture.asset(
                  Assets.icons.flame,
                  width: 80,
                  height: 80,
                  colorFilter: const ColorFilter.mode(
                    fireOrange,
                    BlendMode.srcIn,
                  ),
                )
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 16),
                Text(
                  '$currentStreak',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: fireOrange,
                        height: 1,
                        fontSize: 64,
                      ),
                ).animate().fadeIn().scale(delay: 200.ms),
                Text(
                  l10n
                      .currentStreakSingular(currentStreak)
                      .split(' ')
                      .last, // "Streak" or "Days"
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textGrey,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Calendar Week Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: lockedGrey, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final isToday = index == 5; // Today is at index 5

                    // Logic:
                    // A day is "completed" if it is part of the streak history.
                    // If today is part of streak, it's completed.
                    // If streak is 0, today is not completed.
                    final isCompleted =
                        (index <= 5) && (5 - index < currentStreak);

                    return Column(
                      children: [
                        Text(
                          dayLabels[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isCompleted ? fireOrange : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                  ? fireOrange
                                  : (isToday ? fireOrange : lockedGrey),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? SvgPicture.asset(
                                    Assets.icons
                                        .check, // Use check for completed days
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                : (isToday
                                    ? const SizedBox() // Empty ring for today if incomplete
                                    : const SizedBox()), // Empty grey ring for others
                          ),
                        ).animate(delay: (index * 50).ms).scale(
                              duration: 300.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Motivation Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.streakMotivationMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textGrey,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
              ).animate(delay: 400.ms).fadeIn(),
            ),

            const SizedBox(height: 32),

            // Stats / Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      l10n.goal,
                      '$streakGoal',
                      Colors.blue,
                      lockedGrey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      'Best Streak', // Using hardcoded or l10n if available, keeping hardcoded fallback safe
                      '${userProfile.longestStreak}',
                      const Color(0xFFFF9600),
                      lockedGrey,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),

            const SizedBox(height: 40),

            // Action Button
            PushableButton(
              text: l10n.keepGoing,
              width: MediaQuery.of(context).size.width - 48,
              height: 56,
              buttonColor: fireOrange,
              shadowColor: const Color(0xFFCC7700), // Darker orange
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

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
