// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get welcomeTitle => '歡迎使用 Wordstock';

  @override
  String get welcomeDescription => 'Wordstock 是一個幫助您學習新單字的工具。';

  @override
  String get infoTitle => '建立自訂單字清單';

  @override
  String get infoDescription => 'Wordstock 是一個幫助您學習新單字的工具。';

  @override
  String get getStarted => '開始使用';

  @override
  String get continueText => '繼續';

  @override
  String get makeYoursTitle => '讓我們個人化您的 WordStock';

  @override
  String makeYoursWithNameTitle(String name) {
    return '讓我們個人化您的 WordStock，$name';
  }

  @override
  String get personalizeDescription => '最後幾個問題，幫助我們個人化您的學習體驗。';

  @override
  String get favoriteWordsTitle => '您的最愛單字';

  @override
  String get tryAgain => '重試';

  @override
  String get noFavoritesTitle => '尚無最愛單字';

  @override
  String get noFavoritesDescription => '開始將單字加入您的最愛';

  @override
  String get timeCommitmentTitle => '您每天會花多少時間學習？';

  @override
  String get timeCommitmentDescription => '選擇您每天可以投入學習的時間。';

  @override
  String get fiveMinutes => '⚡️ 每天 5 分鐘';

  @override
  String get tenMinutes => '⏱️ 每天 10 分鐘';

  @override
  String get fifteenMinutes => '⏳ 每天 15 分鐘';

  @override
  String get thirtyMinutes => '🕰️ 每天 30 分鐘';

  @override
  String get topicSelectionTitle => '您對哪些主題感興趣？';

  @override
  String get topicSelectionDescription => '選擇您最感興趣的學習主題。';

  @override
  String get topicSociety => '👥 社會';

  @override
  String get topicForeignLanguages => '🌏 外語';

  @override
  String get topicHumanBody => '💪 人體';

  @override
  String get topicEmotions => '😃 情感';

  @override
  String get topicOther => '🔍 其他';

  @override
  String customizationLoadingTitleWithName(String name) {
    return '請稍等，$name！我們正在個人化您的 Wordstock 體驗。';
  }

  @override
  String get customizationLoadingTitle => '請稍等！我們正在個人化您的 Wordstock 體驗。';

  @override
  String customizationCompleteTitleWithName(String name) {
    return '完成了，$name！您的 Wordstock 體驗已準備就緒！';
  }

  @override
  String get customizationCompleteTitle => '完成了！您的 Wordstock 體驗已準備就緒！';

  @override
  String get craftingExperienceTitle => '我們正在為您打造';

  @override
  String get learningExperienceSubtitle => '學習體驗...';

  @override
  String get profileSetupTitle => '設定您的個人檔案';

  @override
  String get forgetWordsQuestion => '您是否經常在複習數次後仍忘記新單字？';

  @override
  String get learningPreferencesTitle => '調整您的學習偏好';

  @override
  String get readingConversationQuestion => '您是否在閱讀時理解某個單字，但在對話中卻無法使用時感到沮喪？';

  @override
  String get growthAreasTitle => '分析您的成長領域';

  @override
  String get progressFrustrationQuestion => '您是否努力學習但仍覺得進步不夠快？';

  @override
  String get buttonYes => '是';

  @override
  String get buttonNo => '否';

  @override
  String get toMoveForwardSpecify => '要繼續，請指定';

  @override
  String get startLearning => '開始學習';

  @override
  String get analyzingPreferences => '分析您的偏好...';

  @override
  String get selectingWords => '根據您的程度選擇單字...';

  @override
  String get personalizingPath => '個人化您的學習路徑...';

  @override
  String get creatingWordList => '建立您的自訂單字清單...';

  @override
  String get finalizingExperience => '完成您的體驗...';

  @override
  String get practiceReminderTitle => '很棒的進步！';

  @override
  String practiceReminderDescription(int count) {
    return '您已學會 $count 個新單字！現在是練習和鞏固學習的絕佳時機。';
  }

  @override
  String get startPractice => '開始練習';

  @override
  String get continueLearning => '繼續學習';

  @override
  String get streakMilestoneTitle => '連續學習里程碑！';

  @override
  String streakDaysCount(int count) {
    return '$count 天';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return '恭喜！您已連續學習 $count 天。繼續保持！';
  }

  @override
  String get streakCongratulationsMessageSingular => '恭喜！您今天開始了學習之旅。繼續加油！';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return '恭喜！您已連續學習 $count 天。繼續保持！';
  }

  @override
  String get keepGoing => '繼續加油！';

  @override
  String get streakCongratulationsSingular => '恭喜！您今天開始了學習之旅。繼續加油！';

  @override
  String get quizResultExcellent => '優秀！';

  @override
  String get quizResultGoodJob => '做得好！';

  @override
  String get quizResultNiceTry => '不錯的嘗試！';

  @override
  String get quizResultKeepPracticing => '繼續練習！';

  @override
  String get quizCompleteMessage => '您已完成單字測驗。';

  @override
  String coinsEarned(int count) {
    return '獲得 $count 個金幣';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return '您在 $total 題中答對了 $correct 題。';
  }

  @override
  String get playAgain => '再玩一次';

  @override
  String get home => '首頁';

  @override
  String get exitConfirmationTitle => '您確定要退出嗎？';

  @override
  String get exitConfirmationMessage => '您的進度將不會被儲存。';

  @override
  String get exit => '退出';

  @override
  String get continueAction => '繼續';

  @override
  String get vocabularyQuiz => '單字測驗';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord => '選擇正確的單字來完成句子。';

  @override
  String get next => '下一個';

  @override
  String get finish => '完成';

  @override
  String get noQuizQuestions => '沒有可用的測驗題目';

  @override
  String errorWithMessage(String message) {
    return '錯誤：$message';
  }

  @override
  String get commitmentPactTitle => '學習承諾';

  @override
  String get commitmentPactIntro => '我想要';

  @override
  String get commitmentPactInnerNeeds => '與內心需求保持連結';

  @override
  String get commitmentPactByLearning => '，透過每天學習';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count 個單字';
  }

  @override
  String get commitmentPactHelpBecome => '，幫助我成為';

  @override
  String get commitmentPactVocabularyMaster => '單字達人。';

  @override
  String get commitmentPactTestChampion => '考試冠軍。';

  @override
  String get commitmentPactCareerAchiever => '職涯成功者。';

  @override
  String get commitmentPactLifelongLearner => '終身學習者。';

  @override
  String get commitmentPactTrust => '我願意並相信 Wordstock AI 會引導我前進，幫助我實現所有的目標。';

  @override
  String get commitmentPactButton => '我承諾達成目標';

  @override
  String get commitmentCongratulationsTitle => '恭喜！';

  @override
  String get commitmentCongratulationsMessage => '您已踏出單字學習之旅的第一步。您的承諾將幫助您達成目標！';

  @override
  String get nextButton => '下一個';

  @override
  String get goalSelectionTitle => '您的主要學習目標是什麼？';

  @override
  String get goalSelectionDescription => '選擇最符合您主要學習目標的選項。';

  @override
  String get goalMasteringWords => '📚 掌握新單字';

  @override
  String get goalImprovingMemory => '🧠 改善記憶力';

  @override
  String get goalSpeakingConfidence => '🗣️ 自信地說話';

  @override
  String get goalWritingClearly => '✍️ 更清楚地寫作';

  @override
  String get goalUnderstandingContent => '🧩 理解內容';

  @override
  String get goalReachingLanguageGoals => '🎯 達成語言目標';

  @override
  String get weeklyProgress => '每週進度';

  @override
  String currentStreakSingular(int count) {
    return '目前連續天數：$count 天';
  }

  @override
  String currentStreakPlural(int count) {
    return '目前連續天數：$count 天';
  }

  @override
  String get current => '目前';

  @override
  String get goal => '目標';

  @override
  String daysText(int count) {
    return '$count 天';
  }

  @override
  String percentToGoal(int percent) {
    return '距離目標 $percent%';
  }

  @override
  String get streakMotivationMessage => '保持連續學習以獲得更好的學習成果！';

  @override
  String get pointsProgressTitle => '積分進度';

  @override
  String get totalPoints => '總積分';

  @override
  String get pointsLearningJourney => '您的學習歷程';

  @override
  String get achievementWordExplorer => '單字探索者';

  @override
  String get achievementVocabularyBuilder => '單字建構者';

  @override
  String get achievementLanguageMaster => '語言大師';

  @override
  String pointsFormat(int count) {
    return '$count 分';
  }

  @override
  String get pointsMotivationMessage => '繼續賺取積分以解鎖新成就！';

  @override
  String get closeButton => '關閉';

  @override
  String chatWithAITitle(String word) {
    return '與 AI 討論「$word」';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return '詢問關於「$word」的問題...';
  }

  @override
  String chatWithAIError(String message) {
    return '錯誤：$message';
  }

  @override
  String get aiAssistantSystemMessage =>
      '我是一位詞彙學習專家，幫助學習者通過全面、吸引人的解釋來掌握新單詞。我提供清晰的定義、實用的例子、記憶技巧和文化背景。我通過將單詞與現實情境聯繫並提供多種學習方法，使詞彙學習變得愉快且難忘。';

  @override
  String aiVocabularySystemMessage(String word) {
    return '你是一位詞彙學習專家，正在幫助學生學習單詞\'$word\'。請提供全面、教育性的解釋，包括：1) 清晰、簡單的定義 2) 有幫助時的詞源或單詞起源 3) 顯示不同語境的多個例句 4) 同義詞和反義詞 5) 常用的搭配和片語 6) 使用技巧和常見錯誤的避免方法 7) 可能時的記憶技巧或記憶法 8) 相關時的發音指導。請使你的解釋具有吸引力、實用性，並針對學生真正理解和記住單詞而量身定制。如果被問及不相關的話題，請禮貌地引導：\'我在這裡幫助你掌握詞彙！讓我們專注於理解單詞和提高你的語言技能。\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return '我正在學習單詞\'$word\'，希望真正理解它。字典說它的意思是\'$definition\'，這裡有一個例子：\'$example\'。你能幫我清晰地解釋這個單詞，提供實用的例子、同義詞、常用的用法模式和記住的技巧，幫我掌握這個單詞嗎？我希望在真正的對話和寫作中使用這個單詞時能感到自信。';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      '我在這裡幫助你掌握詞彙！讓我們專注於理解單詞和提高你的語言技能。你想進一步探索這個單詞的意義、看更多例子，或者學習相關單詞嗎？';

  @override
  String get practiceButtonText => '練習';

  @override
  String get goProButtonText => '升級專業版';

  @override
  String get letsGrowTogether => '讓我們一起成長！🌱';

  @override
  String get reviewMotivationText => '您的回饋幫助我們創造更好的學習體驗。分享您的想法並幫助其他人發現學習的樂趣！';

  @override
  String get letsGrowTogetherButton => '讓我們一起成長';

  @override
  String get profileTitle => '個人檔案';

  @override
  String get favoriteWords => '最愛單字';

  @override
  String get termsOfService => '服務條款';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get reviewUs => '評價我們';

  @override
  String get contactSupport => '聯絡客服';

  @override
  String get onboardingStarted => '引導開始';

  @override
  String get onboardingCompleted => '引導完成';

  @override
  String onboardingPageView(String pageName) {
    return '引導頁面檢視：$pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return '進度：$progress%';
  }

  @override
  String get onboardingSkip => '跳過';

  @override
  String get onboardingBack => '返回';

  @override
  String get onboardingStar => '星星';

  @override
  String get onboardingNext => '下一個';

  @override
  String get onboardingPrevious => '上一個';

  @override
  String get onboardingProgressLabel => '進度';

  @override
  String get onboardingReviewTitle => '準備好學習了嗎？幫助其他人找到我們！🌱';

  @override
  String get onboardingReviewSubtitle =>
      '我們知道您剛開始 WordStock 的學習旅程，但您的早期支持能幫助其他語言學習者發現我們的應用程式。讓我們一起建立單字愛好者的社群！';

  @override
  String get onboardingReviewButton => '🌱 幫助我們成長';

  @override
  String get onboardingReviewSkip => '讓我先試用看看';

  @override
  String get onboardingEnglishTestTitle => '快速英語評估 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      '讓我們透過 10 道快速測驗來評估您的單字程度。這有助於我們個人化您的學習體驗！';

  @override
  String get onboardingEnglishTestStart => '🚀 開始評估';

  @override
  String get onboardingEnglishTestSkip => '暫時跳過';

  @override
  String get onboardingEnglishTestIcon => '英語測驗';

  @override
  String get onboardingEnglishTestExcellent => '優秀！🌟';

  @override
  String get onboardingEnglishTestGood => '做得很好！👍';

  @override
  String get onboardingEnglishTestOkay => '良好的開始！💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return '您在 $total 題中得到 $correct 分';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsNotificationsDescription => '控制接收通知的時間和方式';

  @override
  String get settingsEnableNotifications => '啟用通知';

  @override
  String get settingsEnableNotificationsDescription => '開啟或關閉所有通知';

  @override
  String get settingsDailyReminders => '每日提醒';

  @override
  String get settingsDailyRemindersDescription => '提醒您每日練習';

  @override
  String get settingsPracticeReminders => '練習提醒';

  @override
  String get settingsPracticeRemindersDescription => '在您沒有練習時提醒您';

  @override
  String get settingsNewWords => '新單字';

  @override
  String get settingsNewWordsDescription => '收到新單字的通知';

  @override
  String get settingsStreakReminders => '連續學習提醒';

  @override
  String get settingsStreakRemindersDescription => '不要中斷您的學習連續紀錄';

  @override
  String get settingsResetToDefaults => '重設為預設值';

  @override
  String get settingsResetTitle => '重設設定';

  @override
  String get settingsResetMessage => '您確定要將所有設定重設為預設值嗎？此操作無法復原。';

  @override
  String get settingsLoadingMessage => '載入設定中...';

  @override
  String get settingsError => '設定錯誤';

  @override
  String get settingsRetry => '重試';

  @override
  String get settingsRecover => '恢復';

  @override
  String get cancel => '取消';

  @override
  String get reset => '重設';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return '單字程度已更新為 $levelName';
  }

  @override
  String get somethingWentWrong => '發生錯誤';

  @override
  String get retry => '重試';

  @override
  String get quickActions => '快速操作';

  @override
  String get vocabularyLevel => '單字程度';

  @override
  String get supportAndInfo => '支援與資訊';

  @override
  String get copyUserID => '複製使用者 ID';

  @override
  String get userIDCopied => '使用者 ID 已複製到剪貼簿';

  @override
  String get legal => '法律條款';

  @override
  String get vocabularyLevelDialogTitle => '您的單字程度是什麼？';

  @override
  String get vocabularyLevelDialogDescription => '選擇最符合您目前單字程度的選項。';

  @override
  String get saveButton => '儲存';

  @override
  String get notificationPermissionTitle => '每日提醒學習單字';

  @override
  String get notificationPermissionDescription => '允許通知以接收每日提醒，從不錯過您的學習連續記錄。';

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get requestingPermission => '正在請求權限...';
}
