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
  String get welcomeSubtitle =>
      'Learn words you\'ll actually use, in just 5 minutes a day.';

  @override
  String get welcomeBulletPersonalized => 'Personalized words for your level';

  @override
  String get welcomeBulletSmartReviews => 'Smart reviews so you don\'t forget';

  @override
  String get welcomeBulletAssessments => 'Quick assessments that adapt to you';

  @override
  String get welcomeSocialProof => 'Trusted by 42,000 learners';

  @override
  String get welcomeCta => 'Build my plan';

  @override
  String get welcomeSkip => 'Skip';

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
  String get aiAssistantSystemMessage =>
      'Ich bin ein Experte für Vokabellernen, der Lernenden hilft, neue Wörter durch umfassende, ansprechende Erklärungen zu meistern. Ich biete klare Definitionen, praktische Beispiele, Gedächtnistechniken und kulturellen Kontext. Ich mache das Vokabellernen angenehm und einprägsam, indem ich Wörter mit realen Situationen verknüpfe und verschiedene Lernansätze anbiete.';

  @override
  String aiVocabularySystemMessage(String word) {
    return 'Du bist ein Experte für Vokabellernen, der einem Schüler das Wort \'$word\' beibringt. Biete umfassende, lehrreiche Erklärungen, die Folgendes beinhalten: 1) Klare, einfache Definition 2) Etymologie oder Wortherkunft, wenn hilfreich 3) Mehrere Beispielsätze in verschiedenen Kontexten 4) Synonyme und Antonyme 5) Häufige Kollokationen und Phrasen 6) Verwendungstipps und häufige Fehler, die vermieden werden sollten 7) Gedächtnistechniken oder Eselsbrücken, wenn möglich 8) Aussprachehilfe, wenn relevant. Gestalte deine Erklärungen ansprechend, praktisch und so, dass der Schüler das Wort wirklich versteht und sich daran erinnert. Bei themenfremden Fragen leite höflich um: \'Ich bin hier, um dir beim Vokabellernen zu helfen! Lass uns auf das Verstehen von Wörtern und die Verbesserung deiner Sprachkenntnisse konzentrieren.\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return 'Ich lerne das Wort \'$word\' und möchte es wirklich verstehen. Das Wörterbuch sagt, es bedeutet \'$definition\' und hier ist ein Beispiel: \'$example\'. Könntest du mir helfen, dieses Wort zu meistern, indem du es klar erklärst und praktische Beispiele, Synonyme, häufige Verwendungsmuster und Tipps zum Merken gibst? Ich möchte mich sicher fühlen, dieses Wort in echten Gesprächen und beim Schreiben zu verwenden.';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      'Ich bin hier, um dir beim Vokabellernen zu helfen! Lass uns auf das Verstehen von Wörtern und die Verbesserung deiner Sprachkenntnisse konzentrieren. Möchtest du mehr über die Bedeutung dieses Wortes erfahren, weitere Beispiele sehen oder verwandte Wörter lernen?';

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
  String get onboardingReviewTitle =>
      'Bereit zum Lernen? Helfen Sie anderen, uns zu finden! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'Wir wissen, dass Sie gerade erst Ihre WordStock-Reise beginnen, aber Ihre frühe Unterstützung hilft anderen Sprachlernenden, unsere App zu entdecken. Gemeinsam können wir eine Gemeinschaft von Wort-Enthusiasten aufbauen!';

  @override
  String get onboardingReviewButton => '🌱 Beim Wachsen helfen';

  @override
  String get onboardingReviewSkip => 'Lassen Sie mich es zuerst ausprobieren';

  @override
  String get onboardingEnglishTestTitle => 'Schnelle Englisch-Bewertung 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      'Lassen Sie uns Ihr Vokabularniveau mit einem schnellen 5-Fragen-Test einschätzen. Das hilft uns, Ihre Lernerfahrung zu personalisieren!';

  @override
  String get onboardingEnglishTestStart => '🚀 Bewertung starten';

  @override
  String get onboardingEnglishTestSkip => 'Für jetzt überspringen';

  @override
  String get onboardingEnglishTestIcon => 'Englisch-Test';

  @override
  String get onboardingEnglishTestExcellent => 'Ausgezeichnet! 🌟';

  @override
  String get onboardingEnglishTestGood => 'Großartige Arbeit! 👍';

  @override
  String get onboardingEnglishTestOkay => 'Guter Start! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return 'Sie haben $correct von $total erreicht';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsNotificationsDescription =>
      'Steuern Sie wann und wie Sie Benachrichtigungen erhalten';

  @override
  String get settingsEnableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get settingsEnableNotificationsDescription =>
      'Alle Benachrichtigungen ein- oder ausschalten';

  @override
  String get settingsDailyReminders => 'Tägliche Erinnerungen';

  @override
  String get settingsDailyRemindersDescription =>
      'Lassen Sie sich täglich ans Üben erinnern';

  @override
  String get settingsPracticeReminders => 'Übungserinnerungen';

  @override
  String get settingsPracticeRemindersDescription =>
      'Lassen Sie sich erinnern, wenn Sie nicht geübt haben';

  @override
  String get settingsNewWords => 'Neue Wörter';

  @override
  String get settingsNewWordsDescription =>
      'Benachrichtigungen über neue Vokabeln erhalten';

  @override
  String get settingsStreakReminders => 'Streak-Erinnerungen';

  @override
  String get settingsStreakRemindersDescription =>
      'Brechen Sie nicht Ihre Lernstreak';

  @override
  String get settingsResetToDefaults => 'Auf Standardwerte zurücksetzen';

  @override
  String get settingsResetTitle => 'Einstellungen zurücksetzen';

  @override
  String get settingsResetMessage =>
      'Sind Sie sicher, dass Sie alle Einstellungen auf ihre Standardwerte zurücksetzen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get settingsLoadingMessage => 'Einstellungen werden geladen...';

  @override
  String get settingsError => 'Einstellungsfehler';

  @override
  String get settingsRetry => 'Wiederholen';

  @override
  String get settingsRecover => 'Wiederherstellen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return 'Wortschatz-Level wurde auf $levelName aktualisiert';
  }

  @override
  String get somethingWentWrong => 'Etwas ist schief gelaufen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get quickActions => 'Schnelle Aktionen';

  @override
  String get vocabularyLevel => 'Wortschatz-Level';

  @override
  String get supportAndInfo => 'Support & Info';

  @override
  String get copyUserID => 'Benutzer-ID kopieren';

  @override
  String get userIDCopied => 'Benutzer-ID in die Zwischenablage kopiert';

  @override
  String get legal => 'Rechtliches';

  @override
  String get vocabularyLevelDialogTitle => 'Was ist dein Wortschatz-Level?';

  @override
  String get vocabularyLevelDialogDescription =>
      'Wähle das Level, das deinen aktuellen Wortschatz am besten beschreibt.';

  @override
  String get saveButton => 'Speichern';

  @override
  String get notificationPermissionTitle =>
      'Lerne Wörter mit täglichen Erinnerungen';

  @override
  String get notificationPermissionDescription =>
      'Erlaube Benachrichtigungen, um tägliche Erinnerungen zu erhalten und deine Lernsträhne nie zu verpassen.';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get requestingPermission => 'Berechtigung anfordern...';

  @override
  String get swipeUp => 'Nach oben wischen';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsThemeDescription =>
      'Wählen Sie Ihr bevorzugtes App-Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get onboardingGoalTitle => 'Was ist Ihr Ziel mit Englisch?';

  @override
  String get onboardingGoalSubtitle =>
      'Wählen Sie, was am wichtigsten ist. Wir passen alles an.';

  @override
  String get onboardingGoalSpeakConfidently => 'Selbstbewusst sprechen';

  @override
  String get onboardingGoalGrowVocabulary => 'Meinen Wortschatz erweitern';

  @override
  String get onboardingGoalPrepareWorkExams =>
      'Für Arbeit oder Prüfungen vorbereiten';

  @override
  String get onboardingGoalTravelWithoutStress => 'Stressfrei reisen';

  @override
  String get onboardingGoalMixSimilarWords => 'I mix up similar words';

  @override
  String get onboardingGoalSoundNatural => 'I want to sound natural';

  @override
  String get onboardingLevelTitle => 'Was ist Ihr aktuelles Niveau?';

  @override
  String get onboardingLevelSubtitle =>
      'Denken Sie nicht zu viel nach. Sie können es jederzeit ändern.';

  @override
  String get onboardingLevelBeginner => 'Anfänger';

  @override
  String get onboardingLevelIntermediate => 'Mittelstufe';

  @override
  String get onboardingLevelAdvanced => 'Fortgeschritten';

  @override
  String get onboardingLevelHelper =>
      'Most learners start here. You\'re not behind.';

  @override
  String get onboardingAssessmentTitle => 'Vocabulary assessment';

  @override
  String get onboardingAssessmentContext =>
      'This helps us calibrate your level.';

  @override
  String get onboardingAssessmentQuizPrompt =>
      'Which sentence uses it correctly?';

  @override
  String get onboardingAssessmentCorrect =>
      'Correct. You just learned a new word.';

  @override
  String get onboardingAssessmentIncorrect =>
      'Assessment complete. The correct answer is A.';

  @override
  String get onboardingProgressTitle => 'Sie lernen bereits.';

  @override
  String get onboardingProgressWordLearned => '1 Wort gelernt';

  @override
  String get onboardingProgressStreakStarted => '1 Serie gestartet';

  @override
  String get onboardingProgressYourProgress => 'Ihr Fortschritt';

  @override
  String get onboardingProgressMotivation =>
      'Stellen Sie sich vor, was 5 Minuten täglich bewirken können.';

  @override
  String get onboardingDailyHabitTitle => 'Wie oft möchten Sie üben?';

  @override
  String get onboardingDailyHabitSubtitle =>
      'Beständigkeit schlägt Intensität.';

  @override
  String get onboardingDailyHabitHelper =>
      'We\'ll gently coach you to stay consistent.';

  @override
  String get onboardingDailyHabit5min => '5 Min/Tag';

  @override
  String get onboardingDailyHabit10min => '10 Min/Tag';

  @override
  String get onboardingDailyHabit15min => '15 Min/Tag';

  @override
  String get onboardingPlanTitle => 'Ihr WordStock-Plan ist bereit';

  @override
  String get onboardingPlanYourPlan => 'Ihr Plan';

  @override
  String get onboardingPlanGoalLabel => 'Ziel';

  @override
  String get onboardingPlanLevelLabel => 'Niveau';

  @override
  String get onboardingPlanDailyLabel => 'Täglich';

  @override
  String onboardingPlanDailyValue(int minutes) {
    return '$minutes Min/Tag';
  }

  @override
  String get onboardingPlanWhatYouGet => 'Was Sie bekommen';

  @override
  String onboardingPlanDailyLessons(int minutes) {
    return 'Tägliche $minutes-Minuten-Lektionen';
  }

  @override
  String get onboardingPlanWordsMatchedLevel =>
      'Wörter passend zu Ihrem Niveau';

  @override
  String get onboardingPlanSmartReviews =>
      'Intelligente Wiederholungen, damit Sie nichts vergessen';

  @override
  String get onboardingPlanProgressTracking =>
      'Fortschrittsverfolgung & Serien';

  @override
  String get onboardingPlanReassurance =>
      'Designed for where most learners start.';

  @override
  String get onboardingProofTitle => 'Sie sind nicht allein';

  @override
  String get onboardingProofLearnerCount => '42.000+';

  @override
  String get onboardingProofSubtitle =>
      'Join 42,000 learners improving their English every day';

  @override
  String get onboardingProofLearnerLabel =>
      'Lernende verbessern täglich ihr Englisch';

  @override
  String get onboardingProofRating => '4,6 durchschnittliche Bewertung';

  @override
  String get onboardingProofAppStore => 'im App Store';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get aiSuggestionExamples => 'Show me more examples';

  @override
  String get aiSuggestionSynonyms => 'What are the synonyms?';

  @override
  String get aiSuggestionPronunciation => 'How do I pronounce it?';
}
