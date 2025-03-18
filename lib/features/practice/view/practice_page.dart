import 'package:flutter/material.dart';
import 'package:wordstock/features/practice/widgets/practice_body.dart';

/// {@template practice_page}
/// A description for PracticePage
/// {@endtemplate}
class PracticePage extends StatelessWidget {
  /// {@macro practice_page}
  const PracticePage({super.key});

  /// The static route for PracticePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const PracticePage());
  }

  static const name = '/practice';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PracticeView(),
    );
  }
}

/// {@template practice_view}
/// Displays the Body of PracticeView
/// {@endtemplate}
class PracticeView extends StatelessWidget {
  /// {@macro practice_view}
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PracticeBody();
  }
}
