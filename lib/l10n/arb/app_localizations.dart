import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ko'),
    Locale('zh')
  ];

  /// Text shown in the Welcome Page
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wordstock'**
  String get welcomeTitle;

  /// Text shown in the Welcome Page
  ///
  /// In en, this message translates to:
  /// **'Wordstock is a tool that helps you learn new words.'**
  String get welcomeDescription;

  /// Text shown in the Info Page
  ///
  /// In en, this message translates to:
  /// **'Create a custom word list'**
  String get infoTitle;

  /// Text shown in the Info Page
  ///
  /// In en, this message translates to:
  /// **'Wordstock is a tool that helps you learn new words.'**
  String get infoDescription;

  /// Text for get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Text for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Title for personalization page
  ///
  /// In en, this message translates to:
  /// **'Let\'s make WordStock yours'**
  String get makeYoursTitle;

  /// Title for personalization page with user's name
  ///
  /// In en, this message translates to:
  /// **'Let\'s make WordStock yours, {name}'**
  String makeYoursWithNameTitle(String name);

  /// Description for personalization pages
  ///
  /// In en, this message translates to:
  /// **'Some final questions to help us personalize your experience.'**
  String get personalizeDescription;

  /// Title for favorite words screen
  ///
  /// In en, this message translates to:
  /// **'Your Favorite Words'**
  String get favoriteWordsTitle;

  /// Text for try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Title shown when no favorite words exist
  ///
  /// In en, this message translates to:
  /// **'No favorite words yet'**
  String get noFavoritesTitle;

  /// Description shown when no favorite words exist
  ///
  /// In en, this message translates to:
  /// **'Start adding words to your favorites'**
  String get noFavoritesDescription;

  /// Title shown on the time commitment selection page
  ///
  /// In en, this message translates to:
  /// **'How much time will you devote to learning?'**
  String get timeCommitmentTitle;

  /// Description text for time commitment selection
  ///
  /// In en, this message translates to:
  /// **'Choose the amount of time you can commit to learning each day.'**
  String get timeCommitmentDescription;

  /// 5 minutes time commitment option
  ///
  /// In en, this message translates to:
  /// **'⚡️ 5 minutes a day'**
  String get fiveMinutes;

  /// 10 minutes time commitment option
  ///
  /// In en, this message translates to:
  /// **'⏱️ 10 minutes a day'**
  String get tenMinutes;

  /// 15 minutes time commitment option
  ///
  /// In en, this message translates to:
  /// **'⏳ 15 minutes a day'**
  String get fifteenMinutes;

  /// 30 minutes time commitment option
  ///
  /// In en, this message translates to:
  /// **'🕰️ 30 minutes a day'**
  String get thirtyMinutes;

  /// Title shown on the topic selection page
  ///
  /// In en, this message translates to:
  /// **'Which topics are you interested in?'**
  String get topicSelectionTitle;

  /// Description text for topic selection
  ///
  /// In en, this message translates to:
  /// **'Select the topics that you are most interested in learning about.'**
  String get topicSelectionDescription;

  /// Society topic option
  ///
  /// In en, this message translates to:
  /// **'👥 Society'**
  String get topicSociety;

  /// Foreign languages topic option
  ///
  /// In en, this message translates to:
  /// **'🌏 Foreign languages'**
  String get topicForeignLanguages;

  /// Human body topic option
  ///
  /// In en, this message translates to:
  /// **'💪 Human body'**
  String get topicHumanBody;

  /// Emotions topic option
  ///
  /// In en, this message translates to:
  /// **'😃 Emotions'**
  String get topicEmotions;

  /// Other topics option
  ///
  /// In en, this message translates to:
  /// **'🔍 Other'**
  String get topicOther;

  /// Loading title with user's name on customization loading page
  ///
  /// In en, this message translates to:
  /// **'Hang tight, {name}! We are personalizing your Wordstock experience.'**
  String customizationLoadingTitleWithName(String name);

  /// Loading title on customization loading page
  ///
  /// In en, this message translates to:
  /// **'Hang tight! We are personalizing your Wordstock experience.'**
  String get customizationLoadingTitle;

  /// Complete title with user's name on customization loading page
  ///
  /// In en, this message translates to:
  /// **'All set, {name}! Your Wordstock experience is ready!'**
  String customizationCompleteTitleWithName(String name);

  /// Complete title on customization loading page
  ///
  /// In en, this message translates to:
  /// **'All set! Your Wordstock experience is ready!'**
  String get customizationCompleteTitle;

  /// First part of the title on customization loading page
  ///
  /// In en, this message translates to:
  /// **'We are crafting your'**
  String get craftingExperienceTitle;

  /// Second part of the title on customization loading page
  ///
  /// In en, this message translates to:
  /// **'Learning experience...'**
  String get learningExperienceSubtitle;

  /// Title for the first step in customization loading
  ///
  /// In en, this message translates to:
  /// **'Setting up your profile'**
  String get profileSetupTitle;

  /// Question about forgetting words in the customization process
  ///
  /// In en, this message translates to:
  /// **'Do you often forget new words even after reviewing them several times?'**
  String get forgetWordsQuestion;

  /// Title for the second step in customization loading
  ///
  /// In en, this message translates to:
  /// **'Adjusting your learning preferences'**
  String get learningPreferencesTitle;

  /// Question about reading vs conversation in the customization process
  ///
  /// In en, this message translates to:
  /// **'Do you feel frustrated when you understand a word while reading, but can\'t use it in conversation?'**
  String get readingConversationQuestion;

  /// Title for the third step in customization loading
  ///
  /// In en, this message translates to:
  /// **'Analyzing your growth areas'**
  String get growthAreasTitle;

  /// Question about progress frustration in the customization process
  ///
  /// In en, this message translates to:
  /// **'Are you putting in the effort but still feel like you\'re not making fast progress?'**
  String get progressFrustrationQuestion;

  /// Text for Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get buttonYes;

  /// Text for No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get buttonNo;

  /// Instruction text in the customization step
  ///
  /// In en, this message translates to:
  /// **'To move forward, specify'**
  String get toMoveForwardSpecify;

  /// Text for start learning button
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// Text for analyzing preferences step
  ///
  /// In en, this message translates to:
  /// **'Analyzing your preferences...'**
  String get analyzingPreferences;

  /// Text for selecting words step
  ///
  /// In en, this message translates to:
  /// **'Selecting words based on your level...'**
  String get selectingWords;

  /// Text for personalizing learning path step
  ///
  /// In en, this message translates to:
  /// **'Personalizing your learning path...'**
  String get personalizingPath;

  /// Text for creating word list step
  ///
  /// In en, this message translates to:
  /// **'Creating your custom word list...'**
  String get creatingWordList;

  /// Text for finalizing experience step
  ///
  /// In en, this message translates to:
  /// **'Finalizing your experience...'**
  String get finalizingExperience;

  /// Title for practice reminder screen
  ///
  /// In en, this message translates to:
  /// **'Great progress!'**
  String get practiceReminderTitle;

  /// Description for practice reminder screen with dynamic word count
  ///
  /// In en, this message translates to:
  /// **'You\'ve learned {count} new words! Now is a perfect time to practice and reinforce your learning.'**
  String practiceReminderDescription(int count);

  /// Text for start practice button
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// Text for continue learning button
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// Title shown on streak milestone celebration
  ///
  /// In en, this message translates to:
  /// **'Streak Milestone!'**
  String get streakMilestoneTitle;

  /// Text showing number of streak days
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDaysCount(int count);

  /// Congratulatory message for streak milestone
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve been learning consistently for {count} days. Keep up the great work!'**
  String streakCongratulationsMessage(int count);

  /// Congratulatory message for first day streak
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve started your learning journey today. Keep it up!'**
  String get streakCongratulationsMessageSingular;

  /// Congratulatory message for multiple day streak
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve been learning consistently for {count} days. Keep up the great work!'**
  String streakCongratulationsMessagePlural(int count);

  /// Text for button to dismiss streak milestone celebration
  ///
  /// In en, this message translates to:
  /// **'Keep Going!'**
  String get keepGoing;

  /// Congratulatory message for first day streak
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve started your learning journey today. Keep it up!'**
  String get streakCongratulationsSingular;

  /// Quiz result feedback for high scores (80%+)
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get quizResultExcellent;

  /// Quiz result feedback for good scores (60-79%)
  ///
  /// In en, this message translates to:
  /// **'Good job!'**
  String get quizResultGoodJob;

  /// Quiz result feedback for moderate scores (40-59%)
  ///
  /// In en, this message translates to:
  /// **'Nice try!'**
  String get quizResultNiceTry;

  /// Quiz result feedback for lower scores (below 40%)
  ///
  /// In en, this message translates to:
  /// **'Keep practicing!'**
  String get quizResultKeepPracticing;

  /// Message shown when a quiz is completed
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished the vocabulary quiz.'**
  String get quizCompleteMessage;

  /// Message showing how many coins were earned
  ///
  /// In en, this message translates to:
  /// **'{count} coins earned'**
  String coinsEarned(int count);

  /// Summary of quiz performance
  ///
  /// In en, this message translates to:
  /// **'You answered {correct} out of {total} questions correctly.'**
  String quizResultSummary(int correct, int total);

  /// Text for play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Text for home button
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Title for exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitConfirmationTitle;

  /// Message for exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Your progress will not be saved.'**
  String get exitConfirmationMessage;

  /// Text for exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Text for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Title for vocabulary quiz
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Quiz'**
  String get vocabularyQuiz;

  /// Question counter format
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String questionCounter(int current, int total);

  /// Instruction for vocabulary quiz
  ///
  /// In en, this message translates to:
  /// **'Select the correct word to complete the sentence.'**
  String get selectCorrectWord;

  /// Text for next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Text for finish button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Message when no quiz questions are available
  ///
  /// In en, this message translates to:
  /// **'No quiz questions available'**
  String get noQuizQuestions;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Title for the commitment pact page
  ///
  /// In en, this message translates to:
  /// **'Commitment Pact'**
  String get commitmentPactTitle;

  /// Introduction text for the commitment pact
  ///
  /// In en, this message translates to:
  /// **'I want to '**
  String get commitmentPactIntro;

  /// Text about inner needs in the commitment pact
  ///
  /// In en, this message translates to:
  /// **'stay connected to my inner needs'**
  String get commitmentPactInnerNeeds;

  /// Text connecting needs and learning amount
  ///
  /// In en, this message translates to:
  /// **' by learning'**
  String get commitmentPactByLearning;

  /// Text showing the number of words per day
  ///
  /// In en, this message translates to:
  /// **' {count} words per day'**
  String commitmentPactWordsPerDay(int count);

  /// Text about helping to become something
  ///
  /// In en, this message translates to:
  /// **' to help me become '**
  String get commitmentPactHelpBecome;

  /// Text for vocabulary master goal
  ///
  /// In en, this message translates to:
  /// **'vocabulary master.'**
  String get commitmentPactVocabularyMaster;

  /// Text for test champion goal
  ///
  /// In en, this message translates to:
  /// **'test champion.'**
  String get commitmentPactTestChampion;

  /// Text for career achiever goal
  ///
  /// In en, this message translates to:
  /// **'career achiever.'**
  String get commitmentPactCareerAchiever;

  /// Text for lifelong learner goal
  ///
  /// In en, this message translates to:
  /// **'lifelong learner.'**
  String get commitmentPactLifelongLearner;

  /// Text about trusting the app
  ///
  /// In en, this message translates to:
  /// **'I want and trust Wordstock AI to guide me along the way and help me accomplish all my resolutions.'**
  String get commitmentPactTrust;

  /// Text for the commitment button
  ///
  /// In en, this message translates to:
  /// **'I commit to my Goals'**
  String get commitmentPactButton;

  /// Title for the commitment congratulations message
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get commitmentCongratulationsTitle;

  /// Congratulations message after committing to goals
  ///
  /// In en, this message translates to:
  /// **'You\'ve taken the first step on your vocabulary learning journey. Your commitment will help you reach your goals!'**
  String get commitmentCongratulationsMessage;

  /// Text for the next button after commitment
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// Title for the goal selection page
  ///
  /// In en, this message translates to:
  /// **'What is your primary learning goal?'**
  String get goalSelectionTitle;

  /// Description for the goal selection page
  ///
  /// In en, this message translates to:
  /// **'Select the goal that best describes your main learning objective.'**
  String get goalSelectionDescription;

  /// Goal option for mastering new words
  ///
  /// In en, this message translates to:
  /// **'📚 Mastering new words'**
  String get goalMasteringWords;

  /// Goal option for improving memory
  ///
  /// In en, this message translates to:
  /// **'🧠 Improving memory'**
  String get goalImprovingMemory;

  /// Goal option for speaking with confidence
  ///
  /// In en, this message translates to:
  /// **'🗣️ Speaking with confidence'**
  String get goalSpeakingConfidence;

  /// Goal option for writing more clearly
  ///
  /// In en, this message translates to:
  /// **'✍️ Writing more clearly'**
  String get goalWritingClearly;

  /// Goal option for understanding content
  ///
  /// In en, this message translates to:
  /// **'🧩 Understanding content'**
  String get goalUnderstandingContent;

  /// Goal option for reaching language goals
  ///
  /// In en, this message translates to:
  /// **'🎯 Reaching language goals'**
  String get goalReachingLanguageGoals;

  /// Title for weekly progress section
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// Text showing current streak for one day
  ///
  /// In en, this message translates to:
  /// **'Current Streak: {count} day'**
  String currentStreakSingular(int count);

  /// Text showing current streak for multiple days
  ///
  /// In en, this message translates to:
  /// **'Current Streak: {count} days'**
  String currentStreakPlural(int count);

  /// Label for current streak in stats
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Label for streak goal in stats
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// Text showing number of days
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysText(int count);

  /// Text showing percentage progress to goal
  ///
  /// In en, this message translates to:
  /// **'{percent}% to your goal'**
  String percentToGoal(int percent);

  /// Motivational message for maintaining streak
  ///
  /// In en, this message translates to:
  /// **'Keep up your streak for better learning results!'**
  String get streakMotivationMessage;

  /// Title for the points progress bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Points Progress'**
  String get pointsProgressTitle;

  /// Label for total points display
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// Title for achievement levels section in points progress
  ///
  /// In en, this message translates to:
  /// **'Your Learning Journey'**
  String get pointsLearningJourney;

  /// Name for beginner achievement level
  ///
  /// In en, this message translates to:
  /// **'Word Explorer'**
  String get achievementWordExplorer;

  /// Name for intermediate achievement level
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Builder'**
  String get achievementVocabularyBuilder;

  /// Name for advanced achievement level
  ///
  /// In en, this message translates to:
  /// **'Language Master'**
  String get achievementLanguageMaster;

  /// Format for displaying points with the pts suffix
  ///
  /// In en, this message translates to:
  /// **'{count} pts'**
  String pointsFormat(int count);

  /// Motivational message shown in the points progress bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Keep earning points to unlock new achievements!'**
  String get pointsMotivationMessage;

  /// Text for close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Title for the chat with AI bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Chat about \"{word}\"'**
  String chatWithAITitle(String word);

  /// Placeholder text for the chat input field
  ///
  /// In en, this message translates to:
  /// **'Ask a question about \"{word}\"...'**
  String chatWithAIPlaceholder(String word);

  /// Error message in the chat with AI
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String chatWithAIError(String message);

  /// System message describing the AI assistant's role and scope
  ///
  /// In en, this message translates to:
  /// **'I\'m an expert vocabulary tutor who helps learners master new words through comprehensive, engaging explanations. I provide clear definitions, practical examples, memory techniques, and cultural context. I make vocabulary learning enjoyable and memorable by connecting words to real-life situations and offering multiple learning approaches.'**
  String get aiAssistantSystemMessage;

  /// System message for vocabulary-focused AI conversation
  ///
  /// In en, this message translates to:
  /// **'You are an expert vocabulary tutor helping a student learn the word \'{word}\'. Provide comprehensive, educational explanations that include: 1) Clear, simple definition 2) Etymology or word origin when helpful 3) Multiple example sentences showing different contexts 4) Synonyms and antonyms 5) Common collocations and phrases 6) Usage tips and common mistakes to avoid 7) Memory techniques or mnemonics when possible 8) Pronunciation guidance if relevant. Make your explanations engaging, practical, and tailored to help the student truly understand and remember the word. If asked about unrelated topics, politely redirect: \'I\'m here to help you master vocabulary! Let\'s focus on understanding words and improving your language skills.\''**
  String aiVocabularySystemMessage(String word);

  /// Initial prompt template for starting AI conversation about a word
  ///
  /// In en, this message translates to:
  /// **'I\'m learning the word \'{word}\' and want to truly understand it. The dictionary says it means \'{definition}\' and here\'s an example: \'{example}\'. Could you help me master this word by explaining it clearly and providing practical examples, synonyms, common usage patterns, and any tips for remembering it? I want to feel confident using this word in real conversations and writing.'**
  String aiInitialPrompt(String word, String definition, String example);

  /// Response when AI is asked about non-vocabulary topics
  ///
  /// In en, this message translates to:
  /// **'I\'m here to help you master vocabulary! Let\'s focus on understanding words and improving your language skills. Would you like to explore more about this word\'s meaning, see more examples, or learn about related words?'**
  String get aiVocabularyOnlyResponse;

  /// Text shown on the practice button for subscribed users
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceButtonText;

  /// Text shown on the practice button for non-subscribed users
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get goProButtonText;

  /// Title for the review request dialog
  ///
  /// In en, this message translates to:
  /// **'Let\'s Grow Together! 🌱'**
  String get letsGrowTogether;

  /// Description text for the review request dialog
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us create a better learning experience. Share your thoughts and help others discover the joy of learning!'**
  String get reviewMotivationText;

  /// Text for the review dialog button
  ///
  /// In en, this message translates to:
  /// **'Let\'s Grow Together'**
  String get letsGrowTogetherButton;

  /// Title for the profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Text for favorite words menu item
  ///
  /// In en, this message translates to:
  /// **'Favorite Words'**
  String get favoriteWords;

  /// Text for terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Text for privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Text for review us menu item
  ///
  /// In en, this message translates to:
  /// **'Review Us'**
  String get reviewUs;

  /// Text for contact support menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Analytics event for onboarding start
  ///
  /// In en, this message translates to:
  /// **'Onboarding Started'**
  String get onboardingStarted;

  /// Analytics event for onboarding completion
  ///
  /// In en, this message translates to:
  /// **'Onboarding Completed'**
  String get onboardingCompleted;

  /// Analytics event for onboarding page view
  ///
  /// In en, this message translates to:
  /// **'Onboarding Page View: {pageName}'**
  String onboardingPageView(String pageName);

  /// Text showing onboarding progress percentage
  ///
  /// In en, this message translates to:
  /// **'Progress: {progress}%'**
  String onboardingProgress(int progress);

  /// Text for skip button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Text for back button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Accessibility label for star icon in onboarding
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get onboardingStar;

  /// Text for next button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Text for previous button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get onboardingPrevious;

  /// Label for progress indicator in onboarding
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get onboardingProgressLabel;

  /// Title for the onboarding review request page
  ///
  /// In en, this message translates to:
  /// **'Excited to Learn? Help Others Find Us! 🌱'**
  String get onboardingReviewTitle;

  /// Subtitle text for the onboarding review request page
  ///
  /// In en, this message translates to:
  /// **'We know you\'re just starting your WordStock journey, but your early support helps other language learners discover our app. Together, we can build a community of word enthusiasts!'**
  String get onboardingReviewSubtitle;

  /// Button text for the review request in onboarding
  ///
  /// In en, this message translates to:
  /// **'🌱 Help Us Grow'**
  String get onboardingReviewButton;

  /// Skip text for the review request in onboarding
  ///
  /// In en, this message translates to:
  /// **'Let Me Try It First'**
  String get onboardingReviewSkip;

  /// Title for the English test onboarding page
  ///
  /// In en, this message translates to:
  /// **'Quick English Assessment 📝'**
  String get onboardingEnglishTestTitle;

  /// Subtitle text for the English test onboarding page
  ///
  /// In en, this message translates to:
  /// **'Let\'s gauge your vocabulary level with a quick 10-question test. This helps us personalize your learning experience!'**
  String get onboardingEnglishTestSubtitle;

  /// Button text to start the English test
  ///
  /// In en, this message translates to:
  /// **'🚀 Start Assessment'**
  String get onboardingEnglishTestStart;

  /// Skip text for the English test
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get onboardingEnglishTestSkip;

  /// Accessibility label for English test icon
  ///
  /// In en, this message translates to:
  /// **'English Test'**
  String get onboardingEnglishTestIcon;

  /// Result message for excellent performance (80%+)
  ///
  /// In en, this message translates to:
  /// **'Excellent! 🌟'**
  String get onboardingEnglishTestExcellent;

  /// Result message for good performance (60-79%)
  ///
  /// In en, this message translates to:
  /// **'Great Job! 👍'**
  String get onboardingEnglishTestGood;

  /// Result message for moderate performance (<60%)
  ///
  /// In en, this message translates to:
  /// **'Good Start! 💡'**
  String get onboardingEnglishTestOkay;

  /// Shows the test score with correct and total questions
  ///
  /// In en, this message translates to:
  /// **'You scored {correct} out of {total}'**
  String onboardingEnglishTestScore(int correct, int total);

  /// Title for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Title for the notifications section in settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// Description for the notifications section in settings
  ///
  /// In en, this message translates to:
  /// **'Control when and how you receive notifications'**
  String get settingsNotificationsDescription;

  /// Master toggle for all notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get settingsEnableNotifications;

  /// Description for the master notification toggle
  ///
  /// In en, this message translates to:
  /// **'Turn all notifications on or off'**
  String get settingsEnableNotificationsDescription;

  /// Toggle for daily reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get settingsDailyReminders;

  /// Description for daily reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Get reminded to practice daily'**
  String get settingsDailyRemindersDescription;

  /// Toggle for practice reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Practice Reminders'**
  String get settingsPracticeReminders;

  /// Description for practice reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Get reminded when you haven\'t practiced'**
  String get settingsPracticeRemindersDescription;

  /// Toggle for new word notifications
  ///
  /// In en, this message translates to:
  /// **'New Words'**
  String get settingsNewWords;

  /// Description for new word notifications
  ///
  /// In en, this message translates to:
  /// **'Get notified about new vocabulary'**
  String get settingsNewWordsDescription;

  /// Toggle for streak reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Streak Reminders'**
  String get settingsStreakReminders;

  /// Description for streak reminder notifications
  ///
  /// In en, this message translates to:
  /// **'Don\'t break your learning streak'**
  String get settingsStreakRemindersDescription;

  /// Button to reset all settings to default values
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get settingsResetToDefaults;

  /// Title for the reset settings dialog
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get settingsResetTitle;

  /// Message for the reset settings confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to their default values? This action cannot be undone.'**
  String get settingsResetMessage;

  /// Message shown while settings are being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get settingsLoadingMessage;

  /// Title for settings error state
  ///
  /// In en, this message translates to:
  /// **'Settings Error'**
  String get settingsError;

  /// Button to retry loading settings
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get settingsRetry;

  /// Button to recover from settings error
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get settingsRecover;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Success message when vocabulary level is updated
  ///
  /// In en, this message translates to:
  /// **'Vocabulary level updated to {levelName}'**
  String vocabularyLevelUpdated(String levelName);

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Text for retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Section title for quick actions in profile
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Menu item for vocabulary level settings
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Level'**
  String get vocabularyLevel;

  /// Section title for support and info in profile
  ///
  /// In en, this message translates to:
  /// **'Support & Info'**
  String get supportAndInfo;

  /// Menu item to copy user ID
  ///
  /// In en, this message translates to:
  /// **'Copy User ID'**
  String get copyUserID;

  /// Success message when user ID is copied
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard'**
  String get userIDCopied;

  /// Section title for legal information in profile
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Title for vocabulary level selection dialog
  ///
  /// In en, this message translates to:
  /// **'What is your Vocabulary Level?'**
  String get vocabularyLevelDialogTitle;

  /// Description for vocabulary level selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select the level that best describes your current vocabulary.'**
  String get vocabularyLevelDialogDescription;

  /// Text for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Title for the notification permission page
  ///
  /// In en, this message translates to:
  /// **'Learn words with daily reminders'**
  String get notificationPermissionTitle;

  /// Description text for notification permission request
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to get daily reminders and never miss your learning streak.'**
  String get notificationPermissionDescription;

  /// Button text to enable notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Button text while requesting permission
  ///
  /// In en, this message translates to:
  /// **'Requesting Permission...'**
  String get requestingPermission;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'ko',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
