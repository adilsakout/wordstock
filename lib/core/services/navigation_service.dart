import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/features/home/cubit/home_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template navigation_service}
/// Service responsible for handling navigation operations
///  in a clean architecture way
/// Separates navigation logic from UI components and business logic
/// {@endtemplate}
class NavigationService {
  /// {@macro navigation_service}
  const NavigationService();

  /// Navigate to settings page
  void navigateToSettings(BuildContext context) {
    context.push('/settings');
  }

  /// Navigate to favorites page
  void navigateToFavorites(BuildContext context) {
    context.push('/home/favorites');
  }

  /// Show vocabulary level selection bottom sheet
  /// Returns the selected vocabulary level or null if canceled
  Future<VocabularyLevel?> showVocabularyLevelBottomSheet(
    BuildContext context, {
    required VocabularyLevel currentLevel,
  }) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VocabularyLevelBottomSheet(
        currentLevel: VocabularyLevels.levelToId(currentLevel),
      ),
    );

    if (result != null) {
      return VocabularyLevels.idToLevel(result);
    }

    return null;
  }

  /// Show success snackbar
  void showSuccessSnackBar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xffF9C835),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  /// Refresh the home screen to load new words
  /// This method triggers a fresh fetch of words based on
  /// the user's current vocabulary level setting.
  ///
  /// Should be called after vocabulary level changes to ensure
  /// the home screen displays words appropriate to the new level.
  void refreshHomeScreen(BuildContext context) {
    // Access the HomeCubit from the context and trigger word refresh
    // This will cause the home screen to reload with words
    // matching the user's updated vocabulary level
    context.read<HomeCubit>().fetchWords();
  }
}

/// Bottom sheet for vocabulary level selection
/// This is a private widget used only by NavigationService
class _VocabularyLevelBottomSheet extends StatefulWidget {
  const _VocabularyLevelBottomSheet({
    required this.currentLevel,
  });

  final int currentLevel;

  @override
  State<_VocabularyLevelBottomSheet> createState() =>
      _VocabularyLevelBottomSheetState();
}

class _VocabularyLevelBottomSheetState
    extends State<_VocabularyLevelBottomSheet> {
  late int selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

  void _selectVocabularyLevel(int level) {
    setState(() {
      selectedLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              l10n.vocabularyLevelDialogTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              l10n.vocabularyLevelDialogDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Vocabulary level selectors
            ...List.generate(
              VocabularyLevels.all.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Selector(
                  text: VocabularyLevels.all[index].fullDisplayText,
                  selected: selectedLevel == index,
                  onTap: () => _selectVocabularyLevel(index),
                ),
              ),
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: PushableButton(
                    width: double.infinity,
                    height: 50,
                    text: l10n.cancel,
                    textColor: Colors.black87,
                    buttonColor: Colors.grey[200]!,
                    shadowColor: Colors.grey[400]!,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PushableButton(
                    width: double.infinity,
                    height: 50,
                    text: l10n.saveButton,
                    buttonColor: const Color(0xffF9C835),
                    shadowColor: const Color(0xffCDB054),
                    onTap: () => Navigator.of(context).pop(selectedLevel),
                  ),
                ),
              ],
            ),

            // Bottom spacing for safe area
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
