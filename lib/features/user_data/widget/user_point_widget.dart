import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/gen/assets.gen.dart';

class UserPointWidget extends StatefulWidget {
  const UserPointWidget({super.key});

  @override
  State<UserPointWidget> createState() => _UserPointWidgetState();
}

class _UserPointWidgetState extends State<UserPointWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreakCubit, StreakState>(
      listener: (context, state) async {
        await _controller.reverse();
        await _controller.forward();
      },
      listenWhen: (previous, current) {
        return previous.profile?.totalPoints != current.profile?.totalPoints;
      },
      builder: (context, state) {
        if (state.isLoaded && state.profile != null) {
          return SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: const Color(0xffFFC20E),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.coin,
                      )
                          .animate(
                            controller: _controller,
                          )
                          .scale(duration: 300.ms, curve: Curves.easeOut)
                          .then(delay: 100.ms)
                          .shake(
                            hz: 2,
                          ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut),
                Positioned(
                  right: 0,
                  top: 0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 25,
                      maxHeight: 25,
                      minHeight: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFC20E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: AnimatedFlipCounter(
                        value: state.profile!.totalPoints ?? 0,
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
          ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
