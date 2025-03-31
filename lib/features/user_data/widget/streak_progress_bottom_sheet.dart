import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
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

    // Create a list of abbreviated day names
    //(2 characters) starting from the current day
    final allWeekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
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

    // No need to replace day names anymore, use actual day abbreviations
    final dayLabels = weekDays;

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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.flame,
                      width: 32,
                      height: 32,
                      colorFilter: const ColorFilter.mode(
                        Color(0xffF97316),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.weeklyProgress,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffF97316),
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
                  currentStreak == 1
                      ? l10n.currentStreakSingular(currentStreak)
                      : l10n.currentStreakPlural(currentStreak),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              ),
              const SizedBox(height: 30),

              // Week Days Visual Representation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    final isToday = index == 5; // Today is now at index 5
                    final isTomorrow = index == 6;
                    // For streaks, a streak day must be today or before today
                    // (not tomorrow)
                    // and must be within the streak count
                    // If streak is 3, it means today + 2 previous days
                    final isInStreakRange =
                        !isTomorrow && (5 - index < currentStreak);
                    final hasStreak = isToday || (index < 5 && isInStreakRange);

                    return Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasStreak
                                ? (isToday
                                    ? const Color(0xffF97316)
                                    : const Color(0xffFFA360))
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isToday || isTomorrow
                                  ? const Color(0xffF97316)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.icons.flame,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                hasStreak
                                    ? (isToday
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.9))
                                    : Colors.grey.shade400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                            .animate(delay: (100 * index).ms)
                            .fadeIn(duration: 400.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 400.ms,
                            ),
                        const SizedBox(height: 8),
                        Text(
                          dayLabels[index],
                          style: TextStyle(
                            fontWeight: isToday || isTomorrow
                                ? FontWeight.w900
                                : FontWeight.bold,
                            fontSize: 14,
                            color: isToday || isTomorrow
                                ? const Color(0xffF97316)
                                : null,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // Streak Stats
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          context,
                          l10n.current,
                          l10n.streakDaysCount(currentStreak),
                          const Color(0xffF97316),
                        ),
                        _buildStatItem(
                          context,
                          l10n.goal,
                          l10n.streakDaysCount(streakGoal),
                          Colors.blue,
                        ),
                      ],
                    ),

                    // Add progress indicator
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.percentToGoal(
                            (currentStreak / streakGoal * 100).toInt(),
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: currentStreak / streakGoal,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xffF97316),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.streakMotivationMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
              ),
              const SizedBox(height: 30),
              PushableButton(
                text: l10n.keepGoing,
                width: 200,
                height: 56,
                buttonColor: const Color(0xffF97316),
                shadowColor: const Color(0xffE86A10),
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
