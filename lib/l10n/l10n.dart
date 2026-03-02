import 'package:flutter/widgets.dart';
import 'package:wordstock/l10n/arb/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Returns localized onboarding goal text for the given goal id.
  /// Use this instead of hardcoded strings so goal text is translated.
  String localizedOnboardingGoalText(String? goalId) {
    final l10n = this.l10n;
    switch (goalId) {
      case 'speak_confidently':
        return l10n.onboardingGoalSpeakConfidently;
      case 'grow_vocabulary':
        return l10n.onboardingGoalGrowVocabulary;
      case 'prepare_work_exams':
        return l10n.onboardingGoalPrepareWorkExams;
      case 'mix_similar_words':
        return l10n.onboardingGoalMixSimilarWords;
      case 'sound_natural':
        return l10n.onboardingGoalSoundNatural;
      case 'travel_without_stress':
        return l10n.onboardingGoalTravelWithoutStress;
      default:
        return '';
    }
  }

  /// Returns localized onboarding level text for the given level id.
  /// Use this instead of hardcoded strings so level text is translated.
  String localizedOnboardingLevelText(String? levelId) {
    final l10n = this.l10n;
    switch (levelId) {
      case 'beginner':
        return l10n.onboardingLevelBeginner;
      case 'intermediate':
        return l10n.onboardingLevelIntermediate;
      case 'advanced':
        return l10n.onboardingLevelAdvanced;
      default:
        return '';
    }
  }
}
