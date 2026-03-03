import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';

/// Displays remaining daily credits in the home screen header.
///
/// Shows a 50x50 circle with an icon and a badge counter.
/// Hidden for subscribers since they have unlimited access.
class CreditIndicatorWidget extends StatelessWidget {
  const CreditIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCubit, CreditState>(
      builder: (context, state) {
        if (state.isSubscribed) return const SizedBox.shrink();
        if (state.status == CreditStatus.initial) {
          return const SizedBox.shrink();
        }

        final hasCredits = state.creditsRemaining > 0;
        final accentColor =
            hasCredits ? const Color(0xff58CC02) : const Color(0xffFF4B4B);

        return SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: accentColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  size: 24,
                  color: accentColor,
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: AnimatedFlipCounter(
                      value: state.creditsRemaining,
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
      },
    );
  }
}
