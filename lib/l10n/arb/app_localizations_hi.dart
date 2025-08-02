// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get welcomeTitle => 'वर्डस्टॉक में आपका स्वागत है';

  @override
  String get welcomeDescription =>
      'वर्डस्टॉक एक ऐसा टूल है जो आपको नए शब्द सीखने में मदद करता है।';

  @override
  String get infoTitle => 'अपनी खुद की शब्द सूची बनाएं';

  @override
  String get infoDescription =>
      'वर्डस्टॉक एक ऐसा टूल है जो आपको नए शब्द सीखने में मदद करता है।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get makeYoursTitle => 'वर्डस्टॉक को अपना बनाएं';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'वर्डस्टॉक को अपना बनाएं, $name';
  }

  @override
  String get personalizeDescription =>
      'आपके अनुभव को व्यक्तिगत बनाने के लिए कुछ अंतिम प्रश्न।';

  @override
  String get favoriteWordsTitle => 'आपके पसंदीदा शब्द';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get noFavoritesTitle => 'अभी तक कोई पसंदीदा शब्द नहीं हैं';

  @override
  String get noFavoritesDescription =>
      'अपने पसंदीदा शब्दों को जोड़ना शुरू करें';

  @override
  String get timeCommitmentTitle => 'आप सीखने के लिए कितना समय देंगे?';

  @override
  String get timeCommitmentDescription =>
      'प्रतिदिन सीखने के लिए आप कितना समय दे सकते हैं, चुनें।';

  @override
  String get fiveMinutes => '⚡️ प्रतिदिन 5 मिनट';

  @override
  String get tenMinutes => '⏱️ प्रतिदिन 10 मिनट';

  @override
  String get fifteenMinutes => '⏳ प्रतिदिन 15 मिनट';

  @override
  String get thirtyMinutes => '🕰️ प्रतिदिन 30 मिनट';

  @override
  String get topicSelectionTitle => 'आपको कौन से विषय रुचिकर लगते हैं?';

  @override
  String get topicSelectionDescription =>
      'वे विषय चुनें जो आपको सबसे अधिक रुचिकर लगते हैं।';

  @override
  String get topicSociety => '👥 समाज';

  @override
  String get topicForeignLanguages => '🌏 विदेशी भाषाएं';

  @override
  String get topicHumanBody => '💪 मानव शरीर';

  @override
  String get topicEmotions => '😃 भावनाएं';

  @override
  String get topicOther => '🔍 अन्य';

  @override
  String customizationLoadingTitleWithName(String name) {
    return 'एक पल, $name! हम आपका वर्डस्टॉक अनुभव व्यक्तिगत बना रहे हैं।';
  }

  @override
  String get customizationLoadingTitle =>
      'एक पल! हम आपका वर्डस्टॉक अनुभव व्यक्तिगत बना रहे हैं।';

  @override
  String customizationCompleteTitleWithName(String name) {
    return 'तैयार है, $name! आपका वर्डस्टॉक अनुभव तैयार है।';
  }

  @override
  String get customizationCompleteTitle =>
      'तैयार है! आपका वर्डस्टॉक अनुभव तैयार है।';

  @override
  String get craftingExperienceTitle => 'हम बना रहे हैं आपका';

  @override
  String get learningExperienceSubtitle => 'सीखने का अनुभव...';

  @override
  String get profileSetupTitle => 'आपकी प्रोफ़ाइल सेटअप';

  @override
  String get forgetWordsQuestion =>
      'क्या आप अक्सर नए शब्दों को कई बार दोहराने के बाद भी भूल जाते हैं?';

  @override
  String get learningPreferencesTitle =>
      'आपकी सीखने की प्राथमिकताएं समायोजित करना';

  @override
  String get readingConversationQuestion =>
      'क्या आप निराश होते हैं जब आप पढ़ते समय एक शब्द समझ लेते हैं लेकिन बातचीत में उसका उपयोग नहीं कर पाते?';

  @override
  String get growthAreasTitle => 'आपके विकास के क्षेत्रों का विश्लेषण';

  @override
  String get progressFrustrationQuestion =>
      'क्या आप प्रयास कर रहे हैं लेकिन फिर भी तेजी से प्रगति नहीं कर पा रहे हैं?';

  @override
  String get buttonYes => 'हाँ';

  @override
  String get buttonNo => 'नहीं';

  @override
  String get toMoveForwardSpecify => 'आगे बढ़ने के लिए, निर्दिष्ट करें';

  @override
  String get startLearning => 'सीखना शुरू करें';

  @override
  String get analyzingPreferences => 'आपकी प्राथमिकताओं का विश्लेषण...';

  @override
  String get selectingWords => 'आपके स्तर के अनुसार शब्दों का चयन...';

  @override
  String get personalizingPath => 'आपके सीखने के मार्ग को व्यक्तिगत बनाना...';

  @override
  String get creatingWordList => 'आपकी व्यक्तिगत शब्द सूची बनाना...';

  @override
  String get finalizingExperience => 'आपके अनुभव को अंतिम रूप देना...';

  @override
  String get practiceReminderTitle => 'उत्कृष्ट प्रगति!';

  @override
  String practiceReminderDescription(int count) {
    return 'आपने $count नए शब्द सीखे हैं! अभ्यास करने और अपने सीखने को मजबूत करने का यह सही समय है।';
  }

  @override
  String get startPractice => 'अभ्यास शुरू करें';

  @override
  String get continueLearning => 'सीखना जारी रखें';

  @override
  String get streakMilestoneTitle => 'लगातार सीखने का लक्ष्य पूरा!';

  @override
  String streakDaysCount(int count) {
    return '$count दिन';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return 'बधाई हो! आप $count दिनों से लगातार सीख रहे हैं। इसी तरह जारी रखें!';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      'बधाई हो! आपने आज अपना सीखने का सफर शुरू किया है। इसी तरह जारी रखें!';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return 'बधाई हो! आप $count दिनों से लगातार सीख रहे हैं। इसी तरह जारी रखें!';
  }

  @override
  String get keepGoing => 'जारी रखें!';

  @override
  String get streakCongratulationsSingular =>
      'बधाई हो! आपने आज अपना सीखने का सफर शुरू किया है। इसी तरह जारी रखें!';

  @override
  String get quizResultExcellent => 'उत्कृष्ट!';

  @override
  String get quizResultGoodJob => 'बहुत अच्छा!';

  @override
  String get quizResultNiceTry => 'अच्छा प्रयास!';

  @override
  String get quizResultKeepPracticing => 'अभ्यास जारी रखें!';

  @override
  String get quizCompleteMessage => 'आपने शब्दावली प्रश्नोत्तरी पूरी कर ली है।';

  @override
  String coinsEarned(int count) {
    return '$count सिक्के अर्जित किए';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return 'आपने $correct प्रश्नों में से $total प्रश्नों के सही उत्तर दिए।';
  }

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get home => 'होम';

  @override
  String get exitConfirmationTitle => 'क्या आप वाकई बाहर निकलना चाहते हैं?';

  @override
  String get exitConfirmationMessage => 'आपकी प्रगति सहेजी नहीं जाएगी।';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get vocabularyQuiz => 'शब्दावली प्रश्नोत्तरी';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord => 'वाक्य को पूरा करने के लिए सही शब्द चुनें।';

  @override
  String get next => 'अगला';

  @override
  String get finish => 'समाप्त करें';

  @override
  String get noQuizQuestions => 'कोई प्रश्न उपलब्ध नहीं है';

  @override
  String errorWithMessage(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get commitmentPactTitle => 'प्रतिबद्धता का वचन';

  @override
  String get commitmentPactIntro => 'मैं चाहता हूं ';

  @override
  String get commitmentPactInnerNeeds => 'अपनी आंतरिक जरूरतों से जुड़े रहना';

  @override
  String get commitmentPactByLearning => ' सीखकर';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count शब्द प्रतिदिन';
  }

  @override
  String get commitmentPactHelpBecome => ' मुझे बनने में मदद करने के लिए ';

  @override
  String get commitmentPactVocabularyMaster => 'शब्दावली के मास्टर।';

  @override
  String get commitmentPactTestChampion => 'परीक्षा के चैंपियन।';

  @override
  String get commitmentPactCareerAchiever => 'कैरियर में सफल।';

  @override
  String get commitmentPactLifelongLearner => 'जीवन भर का शिक्षार्थी।';

  @override
  String get commitmentPactTrust =>
      'मैं चाहता हूं और मुझे विश्वास है कि वर्डस्टॉक AI मुझे मार्गदर्शन करेगा और मेरी सभी प्रतिबद्धताओं को पूरा करने में मेरी मदद करेगा।';

  @override
  String get commitmentPactButton => 'मैं अपने लक्ष्यों के प्रति प्रतिबद्ध हूं';

  @override
  String get commitmentCongratulationsTitle => 'बधाई हो!';

  @override
  String get commitmentCongratulationsMessage =>
      'आपने शब्दावली सीखने की अपनी यात्रा में पहला कदम उठाया है। आपकी प्रतिबद्धता आपको अपने लक्ष्यों को प्राप्त करने में मदद करेगी!';

  @override
  String get nextButton => 'अगला';

  @override
  String get goalSelectionTitle => 'आपका मुख्य सीखने का लक्ष्य क्या है?';

  @override
  String get goalSelectionDescription =>
      'वह लक्ष्य चुनें जो आपके मुख्य सीखने के लक्ष्य का सबसे अच्छा वर्णन करता है।';

  @override
  String get goalMasteringWords => '📚 नए शब्दों में महारत हासिल करना';

  @override
  String get goalImprovingMemory => '🧠 स्मृति में सुधार करना';

  @override
  String get goalSpeakingConfidence => '🗣️ आत्मविश्वास से बोलना';

  @override
  String get goalWritingClearly => '✍️ स्पष्ट रूप से लिखना';

  @override
  String get goalUnderstandingContent => '🧩 सामग्री को समझना';

  @override
  String get goalReachingLanguageGoals => '🎯 भाषा के लक्ष्यों को प्राप्त करना';

  @override
  String get weeklyProgress => 'साप्ताहिक प्रगति';

  @override
  String currentStreakSingular(int count) {
    return 'वर्तमान स्ट्रीक: $count दिन';
  }

  @override
  String currentStreakPlural(int count) {
    return 'वर्तमान स्ट्रीक: $count दिन';
  }

  @override
  String get current => 'वर्तमान';

  @override
  String get goal => 'लक्ष्य';

  @override
  String daysText(int count) {
    return '$count दिन';
  }

  @override
  String percentToGoal(int percent) {
    return 'आपके लक्ष्य का $percent%';
  }

  @override
  String get streakMotivationMessage =>
      'बेहतर सीखने के परिणामों के लिए अपनी स्ट्रीक बनाए रखें!';

  @override
  String get pointsProgressTitle => 'अंकों की प्रगति';

  @override
  String get totalPoints => 'कुल अंक';

  @override
  String get pointsLearningJourney => 'आपकी सीखने की यात्रा';

  @override
  String get achievementWordExplorer => 'शब्द अन्वेषक';

  @override
  String get achievementVocabularyBuilder => 'शब्दावली निर्माता';

  @override
  String get achievementLanguageMaster => 'भाषा के मास्टर';

  @override
  String pointsFormat(int count) {
    return '$count अंक';
  }

  @override
  String get pointsMotivationMessage =>
      'नए उपलब्धियों को अनलॉक करने के लिए अंक अर्जित करना जारी रखें!';

  @override
  String get closeButton => 'बंद करें';

  @override
  String chatWithAITitle(String word) {
    return '\"$word\" के बारे में चैट करें';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return '\"$word\" के बारे में कोई प्रश्न पूछें...';
  }

  @override
  String chatWithAIError(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get aiAssistantSystemMessage =>
      'मैं शब्दावली सीखने का एक विशेषज्ञ हूँ जो शिक्षार्थियों को व्यापक और आकर्षक व्याख्याओं के माध्यम से नए शब्दों में माहिर बनने में मदद करता हूँ। मैं स्पष्ट परिभाषाएँ, व्यावहारिक उदाहरण, याददाश्त तकनीक और सांस्कृतिक संदर्भ प्रदान करता हूँ। मैं शब्दों को वास्तविक स्थितियों से जोड़कर और विभिन्न सीखने के दृष्टिकोण प्रदान करके शब्दावली की शिक्षा को आनंददायक और यादगार बनाता हूँ।';

  @override
  String aiVocabularySystemMessage(String word) {
    return 'आप शब्दावली सीखने के विशेषज्ञ हैं जो एक छात्र को शब्द \'$word\' सिखा रहे हैं। व्यापक, शिक्षाप्रद व्याख्या प्रदान करें जिसमें शामिल हो: 1) स्पष्ट, सरल परिभाषा 2) उपयोगी होने पर व्युत्पत्ति या शब्द की उत्पत्ति 3) विभिन्न संदर्भों में कई उदाहरण वाक्य 4) समानार्थी और विपरीतार्थी शब्द 5) सामान्य प्रयोग और वाक्यांश 6) उपयोग की युक्तियाँ और बचने योग्य आम गलतियाँ 7) संभव होने पर याददाश्त तकनीक या स्मृति सहायक 8) प्रासंगिक होने पर उच्चारण मार्गदर्शन। अपने व्याख्यानों को आकर्षक, व्यावहारिक और छात्र को शब्द को वास्तव में समझने और याद रखने में मदद करने के लिए बनाएं। असंबंधित विषयों के बारे में पूछे जाने पर विनम्रता से मार्गदर्शन करें: \'मैं आपकी शब्दावली में माहिर बनने में मदद करने के लिए यहाँ हूँ! आइए शब्दों को समझने और आपके भाषाई कौशल में सुधार पर ध्यान देते हैं।\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return 'मैं शब्द \'$word\' सीख रहा हूँ और इसे वास्तव में समझना चाहता हूँ। शब्दकोश के अनुसार इसका अर्थ \'$definition\' है और यहाँ एक उदाहरण है: \'$example\'। क्या आप इस शब्द को स्पष्ट रूप से समझाकर और व्यावहारिक उदाहरण, समानार्थी शब्द, आम उपयोग के पैटर्न और इसे याद रखने के लिए सुझाव देकर मास्टर करने में मेरी मदद कर सकते हैं? मैं वास्तविक बातचीत और लेखन में इस शब्द का उपयोग करने में आत्मविश्वास महसूस करना चाहता हूँ।';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      'मैं आपकी शब्दावली में माहिर बनने में मदद करने के लिए यहाँ हूँ! आइए शब्दों को समझने और आपके भाषाई कौशल में सुधार पर ध्यान देते हैं। क्या आप इस शब्द के अर्थ के बारे में और अधिक जानना चाहते हैं, और उदाहरण देखना चाहते हैं, या संबंधित शब्द सीखना चाहते हैं?';

  @override
  String get practiceButtonText => 'अभ्यास करें';

  @override
  String get goProButtonText => 'प्रो बनें';

  @override
  String get letsGrowTogether => 'आइए साथ बढ़ें! 🌱';

  @override
  String get reviewMotivationText =>
      'आपकी प्रतिक्रिया हमें एक बेहतर सीखने का अनुभव बनाने में मदद करती है। अपने विचार साझा करें और दूसरों को सीखने की खुशी खोजने में मदद करें!';

  @override
  String get letsGrowTogetherButton => 'आइए साथ बढ़ें';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get favoriteWords => 'पसंदीदा शब्द';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get reviewUs => 'हमें रेट करें';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get onboardingStarted => 'ऑनबोर्डिंग शुरू हुई';

  @override
  String get onboardingCompleted => 'ऑनबोर्डिंग पूर्ण हुई';

  @override
  String onboardingPageView(String pageName) {
    return 'ऑनबोर्डिंग पेज दृश्य: $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return 'प्रगति: $progress%';
  }

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingBack => 'वापस';

  @override
  String get onboardingStar => 'तारा';

  @override
  String get onboardingNext => 'अगला';

  @override
  String get onboardingPrevious => 'पिछला';

  @override
  String get onboardingProgressLabel => 'प्रगति';

  @override
  String get onboardingReviewTitle =>
      'सीखने के लिए तैयार? दूसरों को हमें खोजने में मदद करें! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'हम जानते हैं कि आप अभी-अभी अपनी WordStock यात्रा शुरू कर रहे हैं, लेकिन आपका प्रारंभिक समर्थन अन्य भाषा सीखने वालों को हमारा ऐप खोजने में मदद करता है। आइए मिलकर शब्द प्रेमियों का एक समुदाय बनाते हैं!';

  @override
  String get onboardingReviewButton => '🌱 हमारी वृद्धि में मदद करें';

  @override
  String get onboardingReviewSkip => 'मुझे पहले इसे आजमाने दें';

  @override
  String get onboardingEnglishTestTitle => 'त्वरित अंग्रेजी मूल्यांकन 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      'आइए 10-प्रश्न परीक्षा के साथ आपके शब्दावली स्तर का आकलन करते हैं। यह हमें आपके सीखने के अनुभव को व्यक्तिगत बनाने में मदद करता है!';

  @override
  String get onboardingEnglishTestStart => '🚀 मूल्यांकन शुरू करें';

  @override
  String get onboardingEnglishTestSkip => 'अभी के लिए छोड़ें';

  @override
  String get onboardingEnglishTestIcon => 'अंग्रेजी परीक्षा';

  @override
  String get onboardingEnglishTestExcellent => 'उत्कृष्ट! 🌟';

  @override
  String get onboardingEnglishTestGood => 'शानदार काम! 👍';

  @override
  String get onboardingEnglishTestOkay => 'अच्छी शुरुआत! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return 'आपने $correct में से $total अंक प्राप्त किए';
  }

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsNotifications => 'सूचनाएं';

  @override
  String get settingsNotificationsDescription =>
      'नियंत्रित करें कि आपको कब और कैसे सूचनाएं प्राप्त हों';

  @override
  String get settingsEnableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get settingsEnableNotificationsDescription =>
      'सभी सूचनाओं को चालू या बंद करें';

  @override
  String get settingsDailyReminders => 'दैनिक रिमाइंडर';

  @override
  String get settingsDailyRemindersDescription =>
      'रोज़ाना अभ्यास के लिए रिमाइंडर प्राप्त करें';

  @override
  String get settingsPracticeReminders => 'अभ्यास रिमाइंडर';

  @override
  String get settingsPracticeRemindersDescription =>
      'जब आपने अभ्यास नहीं किया हो तो रिमाइंडर पाएं';

  @override
  String get settingsNewWords => 'नए शब्द';

  @override
  String get settingsNewWordsDescription =>
      'नई शब्दावली के बारे में सूचनाएं प्राप्त करें';

  @override
  String get settingsStreakReminders => 'स्ट्रीक रिमाइंडर';

  @override
  String get settingsStreakRemindersDescription =>
      'अपना सीखने का स्ट्रीक न तोड़ें';

  @override
  String get settingsResetToDefaults => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get settingsResetTitle => 'सेटिंग्स रीसेट करें';

  @override
  String get settingsResetMessage =>
      'क्या आप वाकई सभी सेटिंग्स को उनके डिफ़ॉल्ट मानों पर रीसेट करना चाहते हैं? इस कार्य को पूर्ववत नहीं किया जा सकता।';

  @override
  String get settingsLoadingMessage => 'सेटिंग्स लोड हो रही हैं...';

  @override
  String get settingsError => 'सेटिंग्स त्रुटि';

  @override
  String get settingsRetry => 'पुनः प्रयास करें';

  @override
  String get settingsRecover => 'पुनर्प्राप्त करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get reset => 'रीसेट करें';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return 'शब्दावली स्तर को $levelName में अपडेट किया गया';
  }

  @override
  String get somethingWentWrong => 'कुछ गलत हुआ';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get vocabularyLevel => 'शब्दावली स्तर';

  @override
  String get supportAndInfo => 'सहायता और जानकारी';

  @override
  String get copyUserID => 'उपयोगकर्ता ID कॉपी करें';

  @override
  String get userIDCopied => 'उपयोगकर्ता ID क्लिपबोर्ड पर कॉपी की गई';

  @override
  String get legal => 'कानूनी';

  @override
  String get vocabularyLevelDialogTitle => 'आपका शब्दावली स्तर क्या है?';

  @override
  String get vocabularyLevelDialogDescription =>
      'वह स्तर चुनें जो आपकी वर्तमान शब्दावली का सबसे अच्छा वर्णन करता है।';

  @override
  String get saveButton => 'सेव करें';
}
