import 'package:flutter/material.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/features/settings/widgets/settings_error_state.dart';
import 'package:wordstock/features/settings/widgets/settings_header.dart';
import 'package:wordstock/features/settings/widgets/settings_loaded_content.dart';
import 'package:wordstock/features/settings/widgets/settings_loading_state.dart';

/// {@template settings_body}
/// Body of the SettingsPage
///
/// Manages the overall layout and state-based content rendering
/// for the settings page.
/// {@endtemplate}
class SettingsBody extends StatelessWidget {
  /// {@macro settings_body}
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                const SettingsHeader(),

                // Content based on current state
                Expanded(
                  child: _buildContent(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the appropriate content widget based on the current state
  Widget _buildContent(SettingsState state) {
    // Handle initial state
    if (state is SettingsInitial) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xffF9C835),
        ),
      );
    }

    // Handle loading state
    if (state is SettingsLoading) {
      return const SettingsLoadingState();
    }

    // Handle loaded state
    if (state is SettingsLoaded) {
      return SettingsLoadedContent(
        settings: state.notificationSettings,
        updatingSetting: state.updatingSetting,
      );
    }

    // Handle error state
    if (state is SettingsError) {
      return SettingsErrorState(
        message: state.errorMessage,
        previousSettings: state.previousSettings,
      );
    }

    // Fallback - should never reach here
    return const SizedBox.shrink();
  }
}
