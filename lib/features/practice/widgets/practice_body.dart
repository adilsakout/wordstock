import 'package:flutter/material.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';

/// {@template practice_body}
/// Body of the PracticePage.
///
/// Add what it does
/// {@endtemplate}
class PracticeBody extends StatelessWidget {
  /// {@macro practice_body}
  const PracticeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeCubit, PracticeState>(
      builder: (context, state) {
        return Center(child: Text(state.customProperty));
      },
    );
  }
}
