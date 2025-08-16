// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get welcomeTitle => 'Wordstock에 오신 것을 환영합니다';

  @override
  String get welcomeDescription => 'Wordstock은 새로운 단어를 학습하는 데 도움을 주는 도구입니다.';

  @override
  String get infoTitle => '맞춤 단어 목록 만들기';

  @override
  String get infoDescription => 'Wordstock은 새로운 단어를 학습하는 데 도움을 주는 도구입니다.';

  @override
  String get getStarted => '시작하기';

  @override
  String get continueText => '계속';

  @override
  String get makeYoursTitle => 'WordStock을 개인화해 보세요';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'WordStock을 개인화해 보세요, $name님';
  }

  @override
  String get personalizeDescription => '학습 경험을 개인화하기 위한 마지막 몇 가지 질문입니다.';

  @override
  String get favoriteWordsTitle => '즐겨찾는 단어';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get noFavoritesTitle => '아직 즐겨찾는 단어가 없습니다';

  @override
  String get noFavoritesDescription => '단어를 즐겨찾기에 추가해 보세요';

  @override
  String get timeCommitmentTitle => '하루에 얼마나 많은 시간을 학습에 투자하실 건가요?';

  @override
  String get timeCommitmentDescription => '매일 학습에 투자할 수 있는 시간을 선택하세요.';

  @override
  String get fiveMinutes => '⚡️ 하루 5분';

  @override
  String get tenMinutes => '⏱️ 하루 10분';

  @override
  String get fifteenMinutes => '⏳ 하루 15분';

  @override
  String get thirtyMinutes => '🕰️ 하루 30분';

  @override
  String get topicSelectionTitle => '어떤 주제에 관심이 있으신가요?';

  @override
  String get topicSelectionDescription => '가장 관심 있는 학습 주제를 선택하세요.';

  @override
  String get topicSociety => '👥 사회';

  @override
  String get topicForeignLanguages => '🌏 외국어';

  @override
  String get topicHumanBody => '💪 인체';

  @override
  String get topicEmotions => '😃 감정';

  @override
  String get topicOther => '🔍 기타';

  @override
  String customizationLoadingTitleWithName(String name) {
    return '잠시만 기다려 주세요, $name님! Wordstock 경험을 개인화하고 있습니다.';
  }

  @override
  String get customizationLoadingTitle =>
      '잠시만 기다려 주세요! Wordstock 경험을 개인화하고 있습니다.';

  @override
  String customizationCompleteTitleWithName(String name) {
    return '완료되었습니다, $name님! Wordstock 경험이 준비되었습니다!';
  }

  @override
  String get customizationCompleteTitle => '완료되었습니다! Wordstock 경험이 준비되었습니다!';

  @override
  String get craftingExperienceTitle => '귀하의';

  @override
  String get learningExperienceSubtitle => '학습 경험을 만들고 있습니다...';

  @override
  String get profileSetupTitle => '프로필 설정 중';

  @override
  String get forgetWordsQuestion => '여러 번 복습해도 새로운 단어를 자주 잊어버리시나요?';

  @override
  String get learningPreferencesTitle => '학습 선호도 조정 중';

  @override
  String get readingConversationQuestion =>
      '읽을 때는 단어를 이해하지만 대화에서는 사용할 수 없을 때 좌절감을 느끼시나요?';

  @override
  String get growthAreasTitle => '성장 영역 분석 중';

  @override
  String get progressFrustrationQuestion =>
      '노력하고 있지만 여전히 충분히 빠른 진전을 보이지 못한다고 느끼시나요?';

  @override
  String get buttonYes => '예';

  @override
  String get buttonNo => '아니오';

  @override
  String get toMoveForwardSpecify => '계속하려면 지정해 주세요';

  @override
  String get startLearning => '학습 시작';

  @override
  String get analyzingPreferences => '선호도 분석 중...';

  @override
  String get selectingWords => '레벨에 따른 단어 선택 중...';

  @override
  String get personalizingPath => '학습 경로 개인화 중...';

  @override
  String get creatingWordList => '맞춤 단어 목록 생성 중...';

  @override
  String get finalizingExperience => '경험 마무리 중...';

  @override
  String get practiceReminderTitle => '훌륭한 진전이에요!';

  @override
  String practiceReminderDescription(int count) {
    return '$count개의 새로운 단어를 배우셨어요! 지금이 연습하고 학습을 강화할 완벽한 시간입니다.';
  }

  @override
  String get startPractice => '연습 시작';

  @override
  String get continueLearning => '학습 계속하기';

  @override
  String get streakMilestoneTitle => '연속 학습 기록!';

  @override
  String streakDaysCount(int count) {
    return '$count일';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return '축하합니다! $count일 동안 꾸준히 학습하셨습니다. 계속 잘하고 계세요!';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      '축하합니다! 오늘 학습 여정을 시작하셨네요. 계속 하세요!';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return '축하합니다! $count일 동안 꾸준히 학습하셨습니다. 계속 잘하고 계세요!';
  }

  @override
  String get keepGoing => '계속 하세요!';

  @override
  String get streakCongratulationsSingular =>
      '축하합니다! 오늘 학습 여정을 시작하셨네요. 계속 하세요!';

  @override
  String get quizResultExcellent => '훌륭해요!';

  @override
  String get quizResultGoodJob => '잘했어요!';

  @override
  String get quizResultNiceTry => '좋은 시도예요!';

  @override
  String get quizResultKeepPracticing => '계속 연습하세요!';

  @override
  String get quizCompleteMessage => '단어 퀴즈를 완료하셨습니다.';

  @override
  String coinsEarned(int count) {
    return '$count개의 코인을 획득했습니다';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return '총 $total문제 중 $correct문제를 맞히셨습니다.';
  }

  @override
  String get playAgain => '다시 하기';

  @override
  String get home => '홈';

  @override
  String get exitConfirmationTitle => '정말 종료하시겠습니까?';

  @override
  String get exitConfirmationMessage => '진행 상황이 저장되지 않습니다.';

  @override
  String get exit => '종료';

  @override
  String get continueAction => '계속';

  @override
  String get vocabularyQuiz => '단어 퀴즈';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord => '문장을 완성할 올바른 단어를 선택하세요.';

  @override
  String get next => '다음';

  @override
  String get finish => '완료';

  @override
  String get noQuizQuestions => '사용 가능한 퀴즈 문제가 없습니다';

  @override
  String errorWithMessage(String message) {
    return '오류: $message';
  }

  @override
  String get commitmentPactTitle => '학습 다짐';

  @override
  String get commitmentPactIntro => '저는 ';

  @override
  String get commitmentPactInnerNeeds => '내면의 필요와 연결되고 싶습니다';

  @override
  String get commitmentPactByLearning => '. 매일';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count개의 단어를 학습하여';
  }

  @override
  String get commitmentPactHelpBecome => ' ';

  @override
  String get commitmentPactVocabularyMaster => '단어 달인이 되고 싶습니다.';

  @override
  String get commitmentPactTestChampion => '시험 챔피언이 되고 싶습니다.';

  @override
  String get commitmentPactCareerAchiever => '경력 성취자가 되고 싶습니다.';

  @override
  String get commitmentPactLifelongLearner => '평생 학습자가 되고 싶습니다.';

  @override
  String get commitmentPactTrust =>
      '저는 Wordstock AI가 저를 안내하고 모든 목표를 달성하는 데 도움을 줄 것이라고 믿고 원합니다.';

  @override
  String get commitmentPactButton => '목표 달성을 다짐합니다';

  @override
  String get commitmentCongratulationsTitle => '축하합니다!';

  @override
  String get commitmentCongratulationsMessage =>
      '단어 학습 여정의 첫 걸음을 내디뎠습니다. 귀하의 다짐이 목표 달성에 도움이 될 것입니다!';

  @override
  String get nextButton => '다음';

  @override
  String get goalSelectionTitle => '주요 학습 목표는 무엇인가요?';

  @override
  String get goalSelectionDescription => '주요 학습 목표를 가장 잘 설명하는 항목을 선택하세요.';

  @override
  String get goalMasteringWords => '📚 새로운 단어 마스터하기';

  @override
  String get goalImprovingMemory => '🧠 기억력 향상';

  @override
  String get goalSpeakingConfidence => '🗣️ 자신 있게 말하기';

  @override
  String get goalWritingClearly => '✍️ 더 명확하게 쓰기';

  @override
  String get goalUnderstandingContent => '🧩 내용 이해하기';

  @override
  String get goalReachingLanguageGoals => '🎯 언어 목표 달성';

  @override
  String get weeklyProgress => '주간 진도';

  @override
  String currentStreakSingular(int count) {
    return '현재 연속 기록: $count일';
  }

  @override
  String currentStreakPlural(int count) {
    return '현재 연속 기록: $count일';
  }

  @override
  String get current => '현재';

  @override
  String get goal => '목표';

  @override
  String daysText(int count) {
    return '$count일';
  }

  @override
  String percentToGoal(int percent) {
    return '목표까지 $percent%';
  }

  @override
  String get streakMotivationMessage => '더 나은 학습 결과를 위해 연속 기록을 유지하세요!';

  @override
  String get pointsProgressTitle => '포인트 진행률';

  @override
  String get totalPoints => '총 포인트';

  @override
  String get pointsLearningJourney => '학습 여정';

  @override
  String get achievementWordExplorer => '단어 탐험가';

  @override
  String get achievementVocabularyBuilder => '단어 구축자';

  @override
  String get achievementLanguageMaster => '언어 마스터';

  @override
  String pointsFormat(int count) {
    return '$count점';
  }

  @override
  String get pointsMotivationMessage => '새로운 성취를 잠금 해제하기 위해 계속 포인트를 획득하세요!';

  @override
  String get closeButton => '닫기';

  @override
  String chatWithAITitle(String word) {
    return '\"$word\"에 대해 AI와 채팅';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return '\"$word\"에 대해 질문하세요...';
  }

  @override
  String chatWithAIError(String message) {
    return '오류: $message';
  }

  @override
  String get aiAssistantSystemMessage =>
      '저는 학습자들이 종합적이고 매력적인 설명을 통해 새로운 단어를 마스터할 수 있도록 돕는 어휘 학습 전문가입니다. 명확한 정의, 실질적인 예시, 기억 기법, 문화적 맥락을 제공합니다. 단어를 실생활 상황과 연결하고 다양한 학습 접근법을 제공함으로써 어휘 학습을 즉겁고 기억에 남도록 만듭니다.';

  @override
  String aiVocabularySystemMessage(String word) {
    return '당신은 학생에게 \'$word\' 단어를 가르치는 어휘 학습 전문가입니다. 다음을 포함하는 종합적이고 교육적인 설명을 제공하세요: 1) 명확하고 간단한 정의 2) 도움이 될 때 어원이나 단어 기원 3) 다양한 맥락을 보여주는 여러 예문 4) 동의어와 반의어 5) 일반적인 연어 관계와 구문 6) 사용 팁과 피해야 할 일반적인 실수 7) 가능할 때 기억 기법이나 연상법 8) 관련이 있을 때 발음 안내. 설명을 매력적이고 실용적이며 학생이 단어를 진정으로 이해하고 기억할 수 있도록 맞춤화하세요. 관련 없는 주제에 대한 질문을 받으면 정중하게 안내하세요: \'어휘를 마스터할 수 있도록 도와드리기 위해 여기 있습니다! 단어를 이해하고 언어 능력을 향상시키는 데 집중합시다.\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return '\'$word\' 단어를 배우고 있는데 진짜로 이해하고 싶습니다. 사전에서는 \'$definition\'라고 하고 여기 예시가 있습니다: \'$example\'. 이 단어를 명확하게 설명하고 실용적인 예시, 동의어, 일반적인 사용 패턴, 그리고 기억하는 방법을 제공해서 마스터할 수 있도록 도와주실 수 있나요? 진짜 대화와 글쓰기에서 이 단어를 사용하는 데 자신감을 느끼고 싶습니다.';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      '어휘를 마스터할 수 있도록 도와드리기 위해 여기 있습니다! 단어를 이해하고 언어 능력을 향상시키는 데 집중합시다. 이 단어의 의미에 대해 더 알아보거나, 더 많은 예시를 보거나, 관련 단어를 배우고 싶으신가요?';

  @override
  String get practiceButtonText => '연습';

  @override
  String get goProButtonText => '프로 버전으로 업그레이드';

  @override
  String get letsGrowTogether => '함께 성장해요! 🌱';

  @override
  String get reviewMotivationText =>
      '귀하의 피드백은 더 나은 학습 경험을 만드는 데 도움이 됩니다. 생각을 공유하고 다른 사람들이 학습의 즐거움을 발견할 수 있도록 도와주세요!';

  @override
  String get letsGrowTogetherButton => '함께 성장하기';

  @override
  String get profileTitle => '프로필';

  @override
  String get favoriteWords => '즐겨찾는 단어';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get reviewUs => '리뷰 작성';

  @override
  String get contactSupport => '고객 지원 문의';

  @override
  String get onboardingStarted => '온보딩 시작됨';

  @override
  String get onboardingCompleted => '온보딩 완료됨';

  @override
  String onboardingPageView(String pageName) {
    return '온보딩 페이지 조회: $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return '진행률: $progress%';
  }

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingBack => '뒤로';

  @override
  String get onboardingStar => '별';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingPrevious => '이전';

  @override
  String get onboardingProgressLabel => '진행률';

  @override
  String get onboardingReviewTitle => '학습 준비 완료? 다른 분들이 저희를 찾도록 도와주세요! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'WordStock 여정을 이제 막 시작하신다는 것을 알고 있지만, 초기 지원이 다른 언어 학습자들이 저희 앱을 발견하는 데 도움이 됩니다. 함께 단어 애호가들의 커뮤니티를 만들어요!';

  @override
  String get onboardingReviewButton => '🌱 성장 도움 주기';

  @override
  String get onboardingReviewSkip => '먼저 사용해보고 결정할게요';

  @override
  String get onboardingEnglishTestTitle => '빠른 영어 평가 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      '10문제의 빠른 테스트로 어휘 수준을 측정해 보겠습니다. 이를 통해 학습 경험을 개인화할 수 있습니다!';

  @override
  String get onboardingEnglishTestStart => '🚀 평가 시작';

  @override
  String get onboardingEnglishTestSkip => '지금은 건너뛰기';

  @override
  String get onboardingEnglishTestIcon => '영어 테스트';

  @override
  String get onboardingEnglishTestExcellent => '훌륭해요! 🌟';

  @override
  String get onboardingEnglishTestGood => '잘하셨어요! 👍';

  @override
  String get onboardingEnglishTestOkay => '좋은 시작이에요! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return '$total문제 중 $correct문제를 맞히셨습니다';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsNotifications => '알림';

  @override
  String get settingsNotificationsDescription => '알림을 언제 어떻게 받을지 제어하세요';

  @override
  String get settingsEnableNotifications => '알림 활성화';

  @override
  String get settingsEnableNotificationsDescription => '모든 알림을 켜거나 끄기';

  @override
  String get settingsDailyReminders => '일일 알림';

  @override
  String get settingsDailyRemindersDescription => '매일 연습하라는 알림 받기';

  @override
  String get settingsPracticeReminders => '연습 알림';

  @override
  String get settingsPracticeRemindersDescription => '연습하지 않았을 때 알림 받기';

  @override
  String get settingsNewWords => '새로운 단어';

  @override
  String get settingsNewWordsDescription => '새로운 어휘에 대한 알림 받기';

  @override
  String get settingsStreakReminders => '연속 기록 알림';

  @override
  String get settingsStreakRemindersDescription => '학습 연속 기록을 놓치지 마세요';

  @override
  String get settingsResetToDefaults => '기본값으로 재설정';

  @override
  String get settingsResetTitle => '설정 재설정';

  @override
  String get settingsResetMessage =>
      '모든 설정을 기본값으로 재설정하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get settingsLoadingMessage => '설정 로딩 중...';

  @override
  String get settingsError => '설정 오류';

  @override
  String get settingsRetry => '다시 시도';

  @override
  String get settingsRecover => '복구';

  @override
  String get cancel => '취소';

  @override
  String get reset => '재설정';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return '어휘 수준이 $levelName(으)로 업데이트되었습니다';
  }

  @override
  String get somethingWentWrong => '문제가 발생했습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get vocabularyLevel => '어휘 수준';

  @override
  String get supportAndInfo => '지원 및 정보';

  @override
  String get copyUserID => '사용자 ID 복사';

  @override
  String get userIDCopied => '사용자 ID가 클립보드에 복사되었습니다';

  @override
  String get legal => '법적 고지';

  @override
  String get vocabularyLevelDialogTitle => '어휘 수준이 어떻게 되시나요?';

  @override
  String get vocabularyLevelDialogDescription =>
      '현재 어휘 수준을 가장 잘 설명하는 레벨을 선택하세요.';

  @override
  String get saveButton => '저장';

  @override
  String get notificationPermissionTitle => '일일 알림으로 단어 학습하기';

  @override
  String get notificationPermissionDescription =>
      '일일 알림을 받아 학습 연속 기록을 놓치지 않으려면 알림을 허용하세요.';

  @override
  String get enableNotifications => '알림 활성화';

  @override
  String get requestingPermission => '권한 요청 중...';
}
