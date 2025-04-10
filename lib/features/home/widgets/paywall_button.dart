import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/widgets/button.dart';

class PaywallButton extends StatefulWidget {
  const PaywallButton({super.key});

  @override
  State<PaywallButton> createState() => _PaywallButtonState();
}

class _PaywallButtonState extends State<PaywallButton> {
  @override
  void initState() {
    super.initState();
    // Check subscription status when widget initializes
    context.read<SubscriptionCubit>().checkSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (isSubscribed) {
            return !isSubscribed
                ? PushableButton(
                    width: 50,
                    height: 50,
                    text: '',
                    suffixIcon: Icons.star_rounded,
                    iconSize: 25,
                    onTap: () {
                      context.read<SubscriptionCubit>().showPaywall();
                    },
                  )
                : const SizedBox.shrink();
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
