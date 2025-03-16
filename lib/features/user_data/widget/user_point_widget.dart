import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/gen/assets.gen.dart';

class UserPointWidget extends StatelessWidget {
  const UserPointWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreakCubit, StreakState>(
      builder: (context, state) {
        if (state.isLoaded && state.profile != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: const Color(0xffFFC20E),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                AnimatedFlipCounter(
                  duration: 1.seconds,
                  value: state.profile!.totalPoints ?? 0,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffFFC20E),
                      ),
                ).animate().slideX(
                      duration: 300.ms,
                      curve: Curves.easeOut,
                      begin: 1,
                      end: 0,
                    ),
                const SizedBox(width: 5),
                SvgPicture.asset(Assets.icons.coin)
                    .animate()
                    .scale(duration: 300.ms, curve: Curves.easeOut)
                    .then(delay: 100.ms)
                    .shake(
                      hz: 2,
                    ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
