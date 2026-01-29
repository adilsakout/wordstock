import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/widgets/button.dart';

/// Screen 4: Progress Framing Page
///
/// Shows a celebration of the user's early progress with stats:
/// "1 word learned", "1 streak started", and a mini progress visual.
/// Encourages continued learning with "Imagine what 5 minutes a day can do."
class ProgressFramingPage extends StatelessWidget {
  const ProgressFramingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
          ),
          child: Column(
            children: [
              // Celebration icon with animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 50,
                  color: AppColors.primaryGreen,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    delay: 200.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 32),

              // Title with entrance animation
              Text(
                "You're already learning.",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms),

              const SizedBox(height: 40),

              // Stats container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // First stat: Word learned
                    const _StatRow(
                      icon: Icons.menu_book,
                      iconColor: AppColors.primaryBlue,
                      label: '1 word learned',
                      delay: 800,
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Divider(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),

                    const SizedBox(height: 20),

                    // Second stat: Streak started
                    const _StatRow(
                      icon: Icons.local_fire_department,
                      iconColor: Colors.orange,
                      label: '1 streak started',
                      delay: 1000,
                    ),

                    const SizedBox(height: 24),

                    // Mini progress bar visualization
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.14, // 1/7 progress
                            minHeight: 12,
                            backgroundColor: theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 500.ms, delay: 1200.ms).slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 500.ms,
                          delay: 1200.ms,
                        ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 700.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    delay: 700.ms,
                  ),

              const SizedBox(height: 32),

              // Motivational text
              Text(
                'Imagine what 5 minutes a day can do.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 1400.ms),

              const Spacer(flex: 2),

              // CTA Button
              PushableButton(
                height: 56,
                borderRadius: 16,
                text: 'Next',
                onTap: () => context.read<OnboardingCubit>().nextPage(),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1600.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// A stat row widget showing an icon, label, and animated appearance
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.delay,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.check_circle,
          color: AppColors.primaryGreen,
          size: 24,
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideX(begin: 0.1, end: 0, duration: 500.ms, delay: delay.ms);
  }
}
