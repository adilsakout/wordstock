import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';

class TimeCommitmentPage extends StatelessWidget {
  const TimeCommitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                l10n.timeCommitmentTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.timeCommitmentDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.fiveMinutes,
                selected: state.selectedTimeCommitment == 0,
                onTap: () {
                  cubit.selectTimeCommitment(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.tenMinutes,
                selected: state.selectedTimeCommitment == 1,
                onTap: () {
                  cubit.selectTimeCommitment(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.fifteenMinutes,
                selected: state.selectedTimeCommitment == 2,
                onTap: () {
                  cubit.selectTimeCommitment(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.thirtyMinutes,
                selected: state.selectedTimeCommitment == 3,
                onTap: () {
                  cubit.selectTimeCommitment(3);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
