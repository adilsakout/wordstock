import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/features/user_data/widget/new_streak_bottom_sheet.dart';
import 'package:wordstock/gen/assets.gen.dart';

class UserStreakWidget extends StatefulWidget {
  const UserStreakWidget({super.key});

  @override
  State<UserStreakWidget> createState() => _UserStreakWidgetState();
}

class _UserStreakWidgetState extends State<UserStreakWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreakCubit, StreakState>(
      listener: (context, state) async {
        if (state.isLoaded && state.profile != null) {
          final currentStreak = state.profile!.dailyStreak;
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return NewStreakBottomSheet(currentStreak: currentStreak);
            },
          );
        }
      },
      listenWhen: (previous, current) {
        // Only trigger listener when streak value changes and state is loaded
        final previousStreak = previous.profile?.dailyStreak;
        final currentStreak = current.profile?.dailyStreak;

        if (previousStreak == null || currentStreak == null) {
          return false;
        }

        return previousStreak != currentStreak;
      },
      builder: (context, state) {
        if (state.isLoaded && state.profile != null) {
          final streakValue = state.profile!.dailyStreak;

          return SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: const Color(0xffF97316),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(Assets.icons.flame)
                      .animate(
                        controller: _controller,
                      )
                      .scale(duration: 500.ms, curve: Curves.easeInOut)
                      .then(delay: 100.ms)
                      .shake(
                        hz: 2,
                      ),
                ).animate().fadeIn(duration: 500.ms, curve: Curves.easeInOut),
                Positioned(
                  right: 0,
                  top: 0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 25,
                      minHeight: 20,
                      maxHeight: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF97316),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: AnimatedFlipCounter(
                        value: streakValue,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffFFFFFF),
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
