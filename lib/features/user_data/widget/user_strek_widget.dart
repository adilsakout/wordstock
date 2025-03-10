import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/gen/assets.gen.dart';

class UserStreakWidget extends StatelessWidget {
  const UserStreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreakCubit, StreakState>(
      builder: (context, state) {
        if (state is StreakLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: const Color(0xffF97316),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(Assets.icons.flame)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeInOut)
                    .then(delay: 100.ms)
                    .shake(
                      hz: 2,
                    ),
                const SizedBox(width: 5),
                AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: state.profile.dailyStreak,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffF97316),
                      ),
                ).animate().slideX(
                      duration: 500.ms,
                      curve: Curves.easeInOut,
                      begin: -1,
                      end: 0,
                    ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, curve: Curves.easeInOut);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
