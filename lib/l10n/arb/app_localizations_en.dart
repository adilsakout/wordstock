// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Welcome to Wordstock';

  @override
  String get welcomeDescription =>
      'Wordstock is a tool that helps you learn new words.';

  @override
  String get infoTitle => 'Create a custom word list';

  @override
  String get infoDescription =>
      'Wordstock is a tool that helps you learn new words.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueText => 'Continue';

  @override
  String get makeYoursTitle => 'Let\'s make WordStock yours';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'Let\'s make WordStock yours, $name';
  }

  @override
  String get personalizeDescription =>
      'Some final questions to help us personalize your experience.';

  @override
  String get favoriteWordsTitle => 'Your Favorite Words';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noFavoritesTitle => 'No favorite words yet';

  @override
  String get noFavoritesDescription => 'Start adding words to your favorites';

  @override
  String get timeCommitmentTitle =>
      'How much time will you devote to learning?';

  @override
  String get timeCommitmentDescription =>
      'Choose the amount of time you can commit to learning each day.';

  @override
  String get fiveMinutes => '⚡️ 5 minutes a day';

  @override
  String get tenMinutes => '⏱️ 10 minutes a day';

  @override
  String get fifteenMinutes => '⏳ 15 minutes a day';

  @override
  String get thirtyMinutes => '🕰️ 30 minutes a day';

  @override
  String get topicSelectionTitle => 'Which topics are you interested in?';

  @override
  String get topicSelectionDescription =>
      'Select the topics that you are most interested in learning about.';

  @override
  String get topicSociety => '👥 Society';

  @override
  String get topicForeignLanguages => '🌏 Foreign languages';

  @override
  String get topicHumanBody => '💪 Human body';

  @override
  String get topicEmotions => '😃 Emotions';

  @override
  String get topicOther => '🔍 Other';

  @override
  String customizationLoadingTitleWithName(String name) {
    return 'Hang tight, $name! We are personalizing your Wordstock experience.';
  }

  @override
  String get customizationLoadingTitle =>
      'Hang tight! We are personalizing your Wordstock experience.';

  @override
  String customizationCompleteTitleWithName(String name) {
    return 'All set, $name! Your Wordstock experience is ready!';
  }

  @override
  String get customizationCompleteTitle =>
      'All set! Your Wordstock experience is ready!';

  @override
  String get craftingExperienceTitle => 'We are crafting your';

  @override
  String get learningExperienceSubtitle => 'Learning experience...';

  @override
  String get profileSetupTitle => 'Setting up your profile';

  @override
  String get forgetWordsQuestion =>
      'Do you often forget new words even after reviewing them several times?';

  @override
  String get learningPreferencesTitle => 'Adjusting your learning preferences';

  @override
  String get readingConversationQuestion =>
      'Do you feel frustrated when you understand a word while reading, but can\'t use it in conversation?';

  @override
  String get growthAreasTitle => 'Analyzing your growth areas';

  @override
  String get progressFrustrationQuestion =>
      'Are you putting in the effort but still feel like you\'re not making fast progress?';

  @override
  String get buttonYes => 'Yes';

  @override
  String get buttonNo => 'No';

  @override
  String get toMoveForwardSpecify => 'To move forward, specify';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get analyzingPreferences => 'Analyzing your preferences...';

  @override
  String get selectingWords => 'Selecting words based on your level...';

  @override
  String get personalizingPath => 'Personalizing your learning path...';

  @override
  String get creatingWordList => 'Creating your custom word list...';

  @override
  String get finalizingExperience => 'Finalizing your experience...';

  @override
  String get practiceReminderTitle => 'Great progress!';

  @override
  String practiceReminderDescription(int count) {
    return 'You\'ve learned $count new words! Now is a perfect time to practice and reinforce your learning.';
  }

  @override
  String get startPractice => 'Start Practice';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get streakMilestoneTitle => 'Streak Milestone!';

  @override
  String streakDaysCount(int count) {
    return '$count days';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return 'Congratulations! You\'ve been learning consistently for $count days. Keep up the great work!';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      'Congratulations! You\'ve started your learning journey today. Keep it up!';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return 'Congratulations! You\'ve been learning consistently for $count days. Keep up the great work!';
  }

  @override
  String get keepGoing => 'Keep Going!';

  @override
  String get streakCongratulationsSingular =>
      'Congratulations! You\'ve started your learning journey today. Keep it up!';

  @override
  String get quizResultExcellent => 'Excellent!';

  @override
  String get quizResultGoodJob => 'Good job!';

  @override
  String get quizResultNiceTry => 'Nice try!';

  @override
  String get quizResultKeepPracticing => 'Keep practicing!';

  @override
  String get quizCompleteMessage => 'You\'ve finished the vocabulary quiz.';

  @override
  String coinsEarned(int count) {
    return '$count coins earned';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return 'You answered $correct out of $total questions correctly.';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get home => 'Home';

  @override
  String get exitConfirmationTitle => 'Are you sure you want to exit?';

  @override
  String get exitConfirmationMessage => 'Your progress will not be saved.';

  @override
  String get exit => 'Exit';

  @override
  String get continueAction => 'Continue';

  @override
  String get vocabularyQuiz => 'Vocabulary Quiz';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord =>
      'Select the correct word to complete the sentence.';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get noQuizQuestions => 'No quiz questions available';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get commitmentPactTitle => 'Commitment Pact';

  @override
  String get commitmentPactIntro => 'I want to ';

  @override
  String get commitmentPactInnerNeeds => 'stay connected to my inner needs';

  @override
  String get commitmentPactByLearning => ' by learning';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count words per day';
  }

  @override
  String get commitmentPactHelpBecome => ' to help me become ';

  @override
  String get commitmentPactVocabularyMaster => 'vocabulary master.';

  @override
  String get commitmentPactTestChampion => 'test champion.';

  @override
  String get commitmentPactCareerAchiever => 'career achiever.';

  @override
  String get commitmentPactLifelongLearner => 'lifelong learner.';

  @override
  String get commitmentPactTrust =>
      'I want and trust Wordstock AI to guide me along the way and help me accomplish all my resolutions.';

  @override
  String get commitmentPactButton => 'I commit to my Goals';

  @override
  String get commitmentCongratulationsTitle => 'Congratulations!';

  @override
  String get commitmentCongratulationsMessage =>
      'You\'ve taken the first step on your vocabulary learning journey. Your commitment will help you reach your goals!';

  @override
  String get nextButton => 'Next';

  @override
  String get goalSelectionTitle => 'What is your primary learning goal?';

  @override
  String get goalSelectionDescription =>
      'Select the goal that best describes your main learning objective.';

  @override
  String get goalMasteringWords => '📚 Mastering new words';

  @override
  String get goalImprovingMemory => '🧠 Improving memory';

  @override
  String get goalSpeakingConfidence => '🗣️ Speaking with confidence';

  @override
  String get goalWritingClearly => '✍️ Writing more clearly';

  @override
  String get goalUnderstandingContent => '🧩 Understanding content';

  @override
  String get goalReachingLanguageGoals => '🎯 Reaching language goals';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String currentStreakSingular(int count) {
    return 'Current Streak: $count day';
  }

  @override
  String currentStreakPlural(int count) {
    return 'Current Streak: $count days';
  }

  @override
  String get current => 'Current';

  @override
  String get goal => 'Goal';

  @override
  String daysText(int count) {
    return '$count days';
  }

  @override
  String percentToGoal(int percent) {
    return '$percent% to your goal';
  }

  @override
  String get streakMotivationMessage =>
      'Keep up your streak for better learning results!';

  @override
  String get pointsProgressTitle => 'Points Progress';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get pointsLearningJourney => 'Your Learning Journey';

  @override
  String get achievementWordExplorer => 'Word Explorer';

  @override
  String get achievementVocabularyBuilder => 'Vocabulary Builder';

  @override
  String get achievementLanguageMaster => 'Language Master';

  @override
  String pointsFormat(int count) {
    return '$count pts';
  }

  @override
  String get pointsMotivationMessage =>
      'Keep earning points to unlock new achievements!';

  @override
  String get closeButton => 'Close';

  @override
  String chatWithAITitle(String word) {
    return 'Chat about \"$word\"';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return 'Ask a question about \"$word\"...';
  }

  @override
  String chatWithAIError(String message) {
    return 'Error: $message';
  }

  @override
  String get aiAssistantSystemMessage =>
      'I\'m an expert vocabulary tutor who helps learners master new words through comprehensive, engaging explanations. I provide clear definitions, practical examples, memory techniques, and cultural context. I make vocabulary learning enjoyable and memorable by connecting words to real-life situations and offering multiple learning approaches.';

  @override
  String aiVocabularySystemMessage(String word) {
    return 'You are an expert vocabulary tutor helping a student learn the word \'$word\'. Provide comprehensive, educational explanations that include: 1) Clear, simple definition 2) Etymology or word origin when helpful 3) Multiple example sentences showing different contexts 4) Synonyms and antonyms 5) Common collocations and phrases 6) Usage tips and common mistakes to avoid 7) Memory techniques or mnemonics when possible 8) Pronunciation guidance if relevant. Make your explanations engaging, practical, and tailored to help the student truly understand and remember the word. If asked about unrelated topics, politely redirect: \'I\'m here to help you master vocabulary! Let\'s focus on understanding words and improving your language skills.\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return 'I\'m learning the word \'$word\' and want to truly understand it. The dictionary says it means \'$definition\' and here\'s an example: \'$example\'. Could you help me master this word by explaining it clearly and providing practical examples, synonyms, common usage patterns, and any tips for remembering it? I want to feel confident using this word in real conversations and writing.';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      'I\'m here to help you master vocabulary! Let\'s focus on understanding words and improving your language skills. Would you like to explore more about this word\'s meaning, see more examples, or learn about related words?';

  @override
  String get practiceButtonText => 'Practice';

  @override
  String get goProButtonText => 'Go Pro';

  @override
  String get letsGrowTogether => 'Let\'s Grow Together! 🌱';

  @override
  String get reviewMotivationText =>
      'Your feedback helps us create a better learning experience. Share your thoughts and help others discover the joy of learning!';

  @override
  String get letsGrowTogetherButton => 'Let\'s Grow Together';

  @override
  String get profileTitle => 'Profile';

  @override
  String get favoriteWords => 'Favorite Words';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get reviewUs => 'Review Us';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get onboardingStarted => 'Onboarding Started';

  @override
  String get onboardingCompleted => 'Onboarding Completed';

  @override
  String onboardingPageView(String pageName) {
    return 'Onboarding Page View: $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return 'Progress: $progress%';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingStar => 'Star';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingPrevious => 'Previous';

  @override
  String get onboardingProgressLabel => 'Progress';

  @override
  String get onboardingReviewTitle =>
      'Excited to Learn? Help Others Find Us! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'We know you\'re just starting your WordStock journey, but your early support helps other language learners discover our app. Together, we can build a community of word enthusiasts!';

  @override
  String get onboardingReviewButton => '🌱 Help Us Grow';

  @override
  String get onboardingReviewSkip => 'Let Me Try It First';

  @override
  String get onboardingEnglishTestTitle => 'Quick English Assessment 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      'Let\'s gauge your vocabulary level with a quick 10-question test. This helps us personalize your learning experience!';

  @override
  String get onboardingEnglishTestStart => '🚀 Start Assessment';

  @override
  String get onboardingEnglishTestSkip => 'Skip for Now';

  @override
  String get onboardingEnglishTestIcon => 'English Test';

  @override
  String get onboardingEnglishTestExcellent => 'Excellent! 🌟';

  @override
  String get onboardingEnglishTestGood => 'Great Job! 👍';

  @override
  String get onboardingEnglishTestOkay => 'Good Start! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return 'You scored $correct out of $total';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsDescription =>
      'Control when and how you receive notifications';

  @override
  String get settingsEnableNotifications => 'Enable Notifications';

  @override
  String get settingsEnableNotificationsDescription =>
      'Turn all notifications on or off';

  @override
  String get settingsDailyReminders => 'Daily Reminders';

  @override
  String get settingsDailyRemindersDescription =>
      'Get reminded to practice daily';

  @override
  String get settingsPracticeReminders => 'Practice Reminders';

  @override
  String get settingsPracticeRemindersDescription =>
      'Get reminded when you haven\'t practiced';

  @override
  String get settingsNewWords => 'New Words';

  @override
  String get settingsNewWordsDescription => 'Get notified about new vocabulary';

  @override
  String get settingsStreakReminders => 'Streak Reminders';

  @override
  String get settingsStreakRemindersDescription =>
      'Don\'t break your learning streak';

  @override
  String get settingsResetToDefaults => 'Reset to Defaults';

  @override
  String get settingsResetTitle => 'Reset Settings';

  @override
  String get settingsResetMessage =>
      'Are you sure you want to reset all settings to their default values? This action cannot be undone.';

  @override
  String get settingsLoadingMessage => 'Loading settings...';

  @override
  String get settingsError => 'Settings Error';

  @override
  String get settingsRetry => 'Retry';

  @override
  String get settingsRecover => 'Recover';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return 'Vocabulary level updated to $levelName';
  }

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get vocabularyLevel => 'Vocabulary Level';

  @override
  String get supportAndInfo => 'Support & Info';

  @override
  String get copyUserID => 'Copy User ID';

  @override
  String get userIDCopied => 'User ID copied to clipboard';

  @override
  String get legal => 'Legal';

  @override
  String get vocabularyLevelDialogTitle => 'What is your Vocabulary Level?';

  @override
  String get vocabularyLevelDialogDescription =>
      'Select the level that best describes your current vocabulary.';

  @override
  String get saveButton => 'Save';

  @override
  String get notificationPermissionTitle => 'Learn words with daily reminders';

  @override
  String get notificationPermissionDescription =>
      'Allow notifications to get daily reminders and never miss your learning streak.';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get requestingPermission => 'Requesting Permission...';
}
