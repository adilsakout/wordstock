import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wordstock/features/home/widgets/home_body.dart';

/// {@template home_page}
/// A description for HomePage
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  /// The static route for HomePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
  }

  static const name = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeView(),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                Sentry.captureException(Exception('Test exception'));
              },
              child: const Icon(Icons.error),
            )
          : null,
    );
  }
}

/// {@template home_view}
/// Displays the Body of HomeView
/// {@endtemplate}
class HomeView extends StatefulWidget {
  /// {@macro home_view}
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
}
