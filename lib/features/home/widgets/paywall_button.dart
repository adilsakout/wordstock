import 'package:flutter/material.dart';
import 'package:wordstock/repositories/rc_repository.dart';
import 'package:wordstock/widgets/button.dart';

class PaywallButton extends StatefulWidget {
  const PaywallButton({super.key});

  @override
  State<PaywallButton> createState() => _PaywallButtonState();
}

class _PaywallButtonState extends State<PaywallButton> {
  late Future<bool> getIsSubscribed;

  @override
  void initState() {
    super.initState();
    getIsSubscribed = RcRepository().isUserSubscribed();
  }

  Future<void> _refreshSubscriptionStatus() async {
    setState(() {
      getIsSubscribed = RcRepository().isUserSubscribed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIsSubscribed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isSubscribed = snapshot.data ?? false;
          return !isSubscribed
              ? PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  suffixIcon: Icons.star_rounded,
                  iconSize: 25,
                  onTap: () async {
                    await RcRepository().presentPaywall();
                    await _refreshSubscriptionStatus();
                  },
                )
              : const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
