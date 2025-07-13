import 'package:flutter/material.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/features/settings/widgets/settings_body.dart';
import 'package:wordstock/repositories/settings_repository.dart';

/// {@template settings_page}
/// Settings page for managing user preferences
///
/// This page provides a comprehensive interface for users to manage their
/// app settings, with a focus on notification preferences. It follows the
/// app's established design patterns and provides a smooth,
///  animated user experience.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  /// The static route for SettingsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const SettingsPage());
  }

  /// The route name for navigation
  ///
  /// This name is used by the router to navigate to the settings page
  /// and should be consistent with the app's routing configuration.
  static const name = '/settings';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        settingsRepository: SettingsRepository(),
      )..loadSettings(),
      child: const Scaffold(
        body: SettingsView(),
      ),
    );
  }
}

/// {@template settings_view}
/// Displays the Body of SettingsView
///
/// This view acts as a container for the settings body and handles
/// the overall layout and structure of the settings page.
/// {@endtemplate}
class SettingsView extends StatelessWidget {
  /// {@macro settings_view}
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsBody();
  }
}
