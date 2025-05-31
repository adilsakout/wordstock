// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get welcomeTitle => 'Willkommen bei Wordstock';

  @override
  String get welcomeDescription =>
      'Wordstock ist ein Tool, das Ihnen hilft, neue Wörter zu lernen.';

  @override
  String get infoTitle => 'Erstellen Sie Ihre eigene Wortliste';

  @override
  String get infoDescription =>
      'Wordstock ist ein Tool, das Ihnen hilft, neue Wörter zu lernen.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get continueText => 'Weiter';

  @override
  String get makeYoursTitle => 'Machen Sie Wordstock zu Ihrem eigenen';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'Machen Sie Wordstock zu Ihrem eigenen, $name';
  }

  @override
  String get personalizeDescription =>
      'Einige letzte Fragen, um Ihre Erfahrung zu personalisieren.';

  @override
  String get favoriteWordsTitle => 'Ihre Lieblingswörter';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get noFavoritesTitle => 'Noch keine Lieblingswörter';

  @override
  String get noFavoritesDescription =>
      'Beginnen Sie, Wörter zu Ihren Favoriten hinzuzufügen';

  @override
  String get timeCommitmentTitle =>
      'Wie viel Zeit möchten Sie dem Lernen widmen?';

  @override
  String get timeCommitmentDescription =>
      'Wählen Sie, wie viel Zeit Sie täglich zum Lernen aufwenden können.';

  @override
  String get fiveMinutes => '⚡️ 5 Minuten täglich';

  @override
  String get tenMinutes => '⏱️ 10 Minuten täglich';

  @override
  String get fifteenMinutes => '⏳ 15 Minuten täglich';

  @override
  String get thirtyMinutes => '🕰️ 30 Minuten täglich';

  @override
  String get topicSelectionTitle => 'Welche Themen interessieren Sie?';

  @override
  String get topicSelectionDescription =>
      'Wählen Sie die Themen, die Sie am meisten interessieren.';

  @override
  String get topicSociety => '👥 Gesellschaft';

  @override
  String get topicForeignLanguages => '🌏 Fremdsprachen';

  @override
  String get topicHumanBody => '💪 Menschlicher Körper';

  @override
  String get topicEmotions => '😃 Emotionen';

  @override
  String get topicOther => '🔍 Andere';

  @override
  String customizationLoadingTitleWithName(String name) {
    return 'Einen Moment, $name! Wir personalisieren Ihre Wordstock-Erfahrung.';
  }

  @override
  String get customizationLoadingTitle =>
      'Einen Moment! Wir personalisieren Ihre Wordstock-Erfahrung.';

  @override
  String customizationCompleteTitleWithName(String name) {
    return 'Fertig, $name! Ihre Wordstock-Erfahrung ist bereit.';
  }

  @override
  String get customizationCompleteTitle =>
      'Fertig! Ihre Wordstock-Erfahrung ist bereit.';

  @override
  String get craftingExperienceTitle => 'Wir erstellen Ihre';

  @override
  String get learningExperienceSubtitle => 'Lernerfahrung...';

  @override
  String get profileSetupTitle => 'Einrichtung Ihres Profils';

  @override
  String get forgetWordsQuestion =>
      'Vergessen Sie oft neue Wörter, auch nachdem Sie sie mehrmals wiederholt haben?';

  @override
  String get learningPreferencesTitle => 'Anpassung Ihrer Lernpräferenzen';

  @override
  String get readingConversationQuestion =>
      'Fühlen Sie sich frustriert, wenn Sie ein Wort beim Lesen verstehen, es aber nicht in der Konversation verwenden können?';

  @override
  String get growthAreasTitle => 'Analyse Ihrer Wachstumsbereiche';

  @override
  String get progressFrustrationQuestion =>
      'Machen Sie Fortschritte, haben aber das Gefühl, nicht schnell genug voranzukommen?';

  @override
  String get buttonYes => 'Ja';

  @override
  String get buttonNo => 'Nein';

  @override
  String get toMoveForwardSpecify => 'Um fortzufahren, geben Sie an';

  @override
  String get startLearning => 'Lernen beginnen';

  @override
  String get analyzingPreferences => 'Analyse Ihrer Präferenzen...';

  @override
  String get selectingWords => 'Auswahl von Wörtern nach Ihrem Niveau...';

  @override
  String get personalizingPath => 'Personalisierung Ihres Lernwegs...';

  @override
  String get creatingWordList => 'Erstellung Ihrer persönlichen Wortliste...';

  @override
  String get finalizingExperience => 'Fertigstellung Ihrer Erfahrung...';

  @override
  String get practiceReminderTitle => 'Ausgezeichneter Fortschritt!';

  @override
  String practiceReminderDescription(int count) {
    return 'Sie haben $count neue Wörter gelernt! Es ist der perfekte Zeitpunkt, um zu üben und Ihr Lernen zu festigen.';
  }

  @override
  String get startPractice => 'Übung beginnen';

  @override
  String get continueLearning => 'Weiterlernen';

  @override
  String get streakMilestoneTitle => 'Lernserie erreicht!';

  @override
  String streakDaysCount(int count) {
    return '$count Tage';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return 'Glückwunsch! Sie lernen seit $count Tagen kontinuierlich. Machen Sie so weiter!';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      'Glückwunsch! Sie haben heute Ihre Lernreise begonnen. Machen Sie so weiter!';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return 'Glückwunsch! Sie lernen seit $count Tagen kontinuierlich. Machen Sie so weiter!';
  }

  @override
  String get keepGoing => 'Weiter so!';

  @override
  String get streakCongratulationsSingular =>
      'Glückwunsch! Sie haben heute Ihre Lernreise begonnen. Machen Sie so weiter!';

  @override
  String get quizResultExcellent => 'Ausgezeichnet!';

  @override
  String get quizResultGoodJob => 'Gut gemacht!';

  @override
  String get quizResultNiceTry => 'Guter Versuch!';

  @override
  String get quizResultKeepPracticing => 'Weiter üben!';

  @override
  String get quizCompleteMessage => 'Sie haben den Vokabeltest abgeschlossen.';

  @override
  String coinsEarned(int count) {
    return '$count Münzen verdient';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return 'Sie haben $correct von $total Fragen richtig beantwortet.';
  }

  @override
  String get playAgain => 'Erneut spielen';

  @override
  String get home => 'Startseite';

  @override
  String get exitConfirmationTitle =>
      'Sind Sie sicher, dass Sie beenden möchten?';

  @override
  String get exitConfirmationMessage =>
      'Ihr Fortschritt wird nicht gespeichert.';

  @override
  String get exit => 'Beenden';

  @override
  String get continueAction => 'Weiter';

  @override
  String get vocabularyQuiz => 'Vokabeltest';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord =>
      'Wählen Sie das richtige Wort, um den Satz zu vervollständigen.';

  @override
  String get next => 'Weiter';

  @override
  String get finish => 'Beenden';

  @override
  String get noQuizQuestions => 'Keine Fragen verfügbar';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get commitmentPactTitle => 'Verpflichtungspakt';

  @override
  String get commitmentPactIntro => 'Ich möchte ';

  @override
  String get commitmentPactInnerNeeds =>
      'mit meinen inneren Bedürfnissen verbunden bleiben';

  @override
  String get commitmentPactByLearning => ' durch das Lernen von';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count Wörtern täglich';
  }

  @override
  String get commitmentPactHelpBecome => ' um mir zu helfen, ein ';

  @override
  String get commitmentPactVocabularyMaster => 'Vokabelmeister zu werden.';

  @override
  String get commitmentPactTestChampion => 'Testchampion zu werden.';

  @override
  String get commitmentPactCareerAchiever => 'beruflich erfolgreich zu werden.';

  @override
  String get commitmentPactLifelongLearner => 'lebenslang Lernender zu werden.';

  @override
  String get commitmentPactTrust =>
      'Ich möchte und vertraue darauf, dass Wordstock AI mich führt und mir hilft, alle meine Verpflichtungen zu erfüllen.';

  @override
  String get commitmentPactButton =>
      'Ich verpflichte mich, meine Ziele zu erreichen';

  @override
  String get commitmentCongratulationsTitle => 'Glückwunsch!';

  @override
  String get commitmentCongratulationsMessage =>
      'Sie haben den ersten Schritt auf Ihrer Vokabellernreise gemacht. Ihre Verpflichtung wird Ihnen helfen, Ihre Ziele zu erreichen!';

  @override
  String get nextButton => 'Weiter';

  @override
  String get goalSelectionTitle => 'Was ist Ihr Hauptlernziel?';

  @override
  String get goalSelectionDescription =>
      'Wählen Sie das Ziel, das Ihr Hauptlernziel am besten beschreibt.';

  @override
  String get goalMasteringWords => '📚 Neue Wörter beherrschen';

  @override
  String get goalImprovingMemory => '🧠 Gedächtnis verbessern';

  @override
  String get goalSpeakingConfidence => '🗣️ Selbstbewusst sprechen';

  @override
  String get goalWritingClearly => '✍️ Klar schreiben';

  @override
  String get goalUnderstandingContent => '🧩 Inhalte verstehen';

  @override
  String get goalReachingLanguageGoals => '🎯 Sprachziele erreichen';

  @override
  String get weeklyProgress => 'Wöchentlicher Fortschritt';

  @override
  String currentStreakSingular(int count) {
    return 'Aktuelle Serie: $count Tag';
  }

  @override
  String currentStreakPlural(int count) {
    return 'Aktuelle Serie: $count Tage';
  }

  @override
  String get current => 'Aktuell';

  @override
  String get goal => 'Ziel';

  @override
  String daysText(int count) {
    return '$count Tage';
  }

  @override
  String percentToGoal(int percent) {
    return '$percent% Ihres Ziels';
  }

  @override
  String get streakMotivationMessage =>
      'Halten Sie Ihre Serie aufrecht für bessere Lernergebnisse!';

  @override
  String get pointsProgressTitle => 'Punktestand';

  @override
  String get totalPoints => 'Gesamtpunkte';

  @override
  String get pointsLearningJourney => 'Ihre Lernreise';

  @override
  String get achievementWordExplorer => 'Worterforscher';

  @override
  String get achievementVocabularyBuilder => 'Vokabelbauer';

  @override
  String get achievementLanguageMaster => 'Sprachmeister';

  @override
  String pointsFormat(int count) {
    return '$count Punkte';
  }

  @override
  String get pointsMotivationMessage =>
      'Sammeln Sie weiter Punkte, um neue Erfolge freizuschalten!';

  @override
  String get closeButton => 'Schließen';

  @override
  String chatWithAITitle(String word) {
    return 'Chatten Sie über \"$word\"';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return 'Stellen Sie eine Frage über \"$word\"...';
  }

  @override
  String chatWithAIError(String message) {
    return 'Fehler: $message';
  }

  @override
  String get practiceButtonText => 'Üben';

  @override
  String get goProButtonText => 'Pro werden';

  @override
  String get letsGrowTogether => 'Lassen Sie uns zusammen wachsen! 🌱';

  @override
  String get reviewMotivationText =>
      'Ihr Feedback hilft uns, eine bessere Lernerfahrung zu schaffen. Teilen Sie Ihre Gedanken und helfen Sie anderen, die Freude am Lernen zu entdecken!';

  @override
  String get letsGrowTogetherButton => 'Lassen Sie uns zusammen wachsen';

  @override
  String get profileTitle => 'Profil';

  @override
  String get favoriteWords => 'Lieblingswörter';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get reviewUs => 'Bewerten Sie uns';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get onboardingStarted => 'Onboarding gestartet';

  @override
  String get onboardingCompleted => 'Onboarding abgeschlossen';

  @override
  String onboardingPageView(String pageName) {
    return 'Onboarding-Seitenansicht: $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return 'Fortschritt: $progress%';
  }

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingStar => 'Stern';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingPrevious => 'Zurück';

  @override
  String get onboardingProgressLabel => 'Fortschritt';

  @override
  String get onboardingReviewTitle => 'Lieben Sie WordStock? ⭐';

  @override
  String get onboardingReviewSubtitle =>
      'Ihre Bewertung hilft uns, mehr Wortliebhaber zu erreichen und unsere App zu verbessern. Es dauert nur einen Moment!';

  @override
  String get onboardingReviewButton => '⭐ WordStock bewerten';

  @override
  String get onboardingReviewSkip => 'Vielleicht später';
}
