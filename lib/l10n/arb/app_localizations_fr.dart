// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeTitle => 'Bienvenue sur Wordstock';

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
  String get infoTitle => 'Créez une liste personnalisée de mots';

  @override
  String get infoDescription =>
      'Wordstock est un outil qui vous aide à apprendre de nouveaux mots.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get continueText => 'Continuer';

  @override
  String get makeYoursTitle => 'Personnalisons WordStock pour vous';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'Personnalisons WordStock pour vous, $name';
  }

  @override
  String get personalizeDescription =>
      'Quelques questions finales pour nous aider à personnaliser votre expérience.';

  @override
  String get favoriteWordsTitle => 'Vos Mots Favoris';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get noFavoritesTitle => 'Pas encore de mots favoris';

  @override
  String get noFavoritesDescription =>
      'Commencez à ajouter des mots à vos favoris';

  @override
  String get timeCommitmentTitle =>
      'Combien de temps allez-vous consacrer à l\'apprentissage ?';

  @override
  String get timeCommitmentDescription =>
      'Choisissez le temps que vous pouvez consacrer à l\'apprentissage chaque jour.';

  @override
  String get fiveMinutes => '⚡️ 5 minutes par jour';

  @override
  String get tenMinutes => '⏱️ 10 minutes par jour';

  @override
  String get fifteenMinutes => '⏳ 15 minutes par jour';

  @override
  String get thirtyMinutes => '🕰️ 30 minutes par jour';

  @override
  String get topicSelectionTitle => 'Quels sujets vous intéressent ?';

  @override
  String get topicSelectionDescription =>
      'Sélectionnez les sujets qui vous intéressent le plus.';

  @override
  String get topicSociety => '👥 Société';

  @override
  String get topicForeignLanguages => '🌏 Langues étrangères';

  @override
  String get topicHumanBody => '💪 Corps humain';

  @override
  String get topicEmotions => '😃 Émotions';

  @override
  String get topicOther => '🔍 Autres';

  @override
  String customizationLoadingTitleWithName(String name) {
    return 'Un instant, $name ! Nous personnalisons votre expérience Wordstock.';
  }

  @override
  String get customizationLoadingTitle =>
      'Un instant ! Nous personnalisons votre expérience Wordstock.';

  @override
  String customizationCompleteTitleWithName(String name) {
    return 'Voilà, $name ! Votre expérience Wordstock est prête.';
  }

  @override
  String get customizationCompleteTitle =>
      'Voilà ! Votre expérience Wordstock est prête.';

  @override
  String get craftingExperienceTitle => 'Nous créons votre';

  @override
  String get learningExperienceSubtitle => 'Expérience d\'apprentissage...';

  @override
  String get profileSetupTitle => 'Configuration de votre profil';

  @override
  String get forgetWordsQuestion =>
      'Oubliez-vous souvent de nouveaux mots même après les avoir revus plusieurs fois ?';

  @override
  String get learningPreferencesTitle =>
      'Ajustement de vos préférences d\'apprentissage';

  @override
  String get readingConversationQuestion =>
      'Vous sentez-vous frustré lorsque vous comprenez un mot en lecture mais ne pouvez pas l\'utiliser en conversation ?';

  @override
  String get growthAreasTitle => 'Analyse de vos domaines de croissance';

  @override
  String get progressFrustrationQuestion =>
      'Faites-vous des efforts mais avez l\'impression de ne pas progresser rapidement ?';

  @override
  String get buttonYes => 'Oui';

  @override
  String get buttonNo => 'Non';

  @override
  String get toMoveForwardSpecify => 'Pour continuer, spécifiez';

  @override
  String get startLearning => 'Commencer à Apprendre';

  @override
  String get analyzingPreferences => 'Analyse de vos préférences...';

  @override
  String get selectingWords => 'Sélection des mots selon votre niveau...';

  @override
  String get personalizingPath =>
      'Personnalisation de votre parcours d\'apprentissage...';

  @override
  String get creatingWordList =>
      'Création de votre liste personnalisée de mots...';

  @override
  String get finalizingExperience => 'Finalisation de votre expérience...';

  @override
  String get practiceReminderTitle => 'Excellent progrès !';

  @override
  String practiceReminderDescription(int count) {
    return 'Vous avez appris $count nouveaux mots ! C\'est le moment idéal pour pratiquer et renforcer votre apprentissage.';
  }

  @override
  String get startPractice => 'Commencer la Pratique';

  @override
  String get continueLearning => 'Continuer l\'Apprentissage';

  @override
  String get streakMilestoneTitle => 'Objectif de Série Atteint !';

  @override
  String streakDaysCount(int count) {
    return '$count jours';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return 'Félicitations ! Vous apprenez de manière constante depuis $count jours. Continuez ainsi !';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      'Félicitations ! Vous avez commencé votre parcours d\'apprentissage aujourd\'hui. Continuez ainsi !';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return 'Félicitations ! Vous apprenez de manière constante depuis $count jours. Continuez ainsi !';
  }

  @override
  String get keepGoing => 'Continuez !';

  @override
  String get streakCongratulationsSingular =>
      'Félicitations ! Vous avez commencé votre parcours d\'apprentissage aujourd\'hui. Continuez ainsi !';

  @override
  String get quizResultExcellent => 'Excellent !';

  @override
  String get quizResultGoodJob => 'Bon travail !';

  @override
  String get quizResultNiceTry => 'Bien essayé !';

  @override
  String get quizResultKeepPracticing => 'Continuez à pratiquer !';

  @override
  String get quizCompleteMessage => 'Vous avez terminé le quiz de vocabulaire.';

  @override
  String coinsEarned(int count) {
    return '$count pièces gagnées';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return 'Vous avez répondu correctement à $correct questions sur $total.';
  }

  @override
  String get playAgain => 'Rejouer';

  @override
  String get home => 'Accueil';

  @override
  String get exitConfirmationTitle => 'Êtes-vous sûr de vouloir quitter ?';

  @override
  String get exitConfirmationMessage =>
      'Votre progression ne sera pas sauvegardée.';

  @override
  String get exit => 'Quitter';

  @override
  String get continueAction => 'Continuer';

  @override
  String get vocabularyQuiz => 'Quiz de Vocabulaire';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord =>
      'Sélectionnez le mot correct pour compléter la phrase.';

  @override
  String get next => 'Suivant';

  @override
  String get finish => 'Terminer';

  @override
  String get noQuizQuestions => 'Aucune question disponible';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get commitmentPactTitle => 'Pacte d\'Engagement';

  @override
  String get commitmentPactIntro => 'Je veux ';

  @override
  String get commitmentPactInnerNeeds =>
      'rester connecté à mes besoins intérieurs';

  @override
  String get commitmentPactByLearning => ' en apprenant';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count mots par jour';
  }

  @override
  String get commitmentPactHelpBecome => ' pour m\'aider à devenir ';

  @override
  String get commitmentPactVocabularyMaster => 'maître du vocabulaire.';

  @override
  String get commitmentPactTestChampion => 'champion des tests.';

  @override
  String get commitmentPactCareerAchiever => 'professionnel accompli.';

  @override
  String get commitmentPactLifelongLearner => 'apprenant à vie.';

  @override
  String get commitmentPactTrust =>
      'Je veux et je fais confiance à Wordstock AI pour me guider et m\'aider à atteindre toutes mes résolutions.';

  @override
  String get commitmentPactButton => 'Je m\'engage à atteindre mes Objectifs';

  @override
  String get commitmentCongratulationsTitle => 'Félicitations !';

  @override
  String get commitmentCongratulationsMessage =>
      'Vous avez fait le premier pas dans votre parcours d\'apprentissage du vocabulaire. Votre engagement vous aidera à atteindre vos objectifs !';

  @override
  String get nextButton => 'Suivant';

  @override
  String get goalSelectionTitle =>
      'Quel est votre objectif principal d\'apprentissage ?';

  @override
  String get goalSelectionDescription =>
      'Sélectionnez l\'objectif qui décrit le mieux votre principal objectif d\'apprentissage.';

  @override
  String get goalMasteringWords => '📚 Maîtriser de nouveaux mots';

  @override
  String get goalImprovingMemory => '🧠 Améliorer la mémoire';

  @override
  String get goalSpeakingConfidence => '🗣️ Parler avec confiance';

  @override
  String get goalWritingClearly => '✍️ Écrire plus clairement';

  @override
  String get goalUnderstandingContent => '🧩 Comprendre le contenu';

  @override
  String get goalReachingLanguageGoals =>
      '🎯 Atteindre les objectifs linguistiques';

  @override
  String get weeklyProgress => 'Progrès Hebdomadaire';

  @override
  String currentStreakSingular(int count) {
    return 'Série actuelle : $count jour';
  }

  @override
  String currentStreakPlural(int count) {
    return 'Série actuelle : $count jours';
  }

  @override
  String get current => 'Actuel';

  @override
  String get goal => 'Objectif';

  @override
  String daysText(int count) {
    return '$count jours';
  }

  @override
  String percentToGoal(int percent) {
    return '$percent% de votre objectif';
  }

  @override
  String get streakMotivationMessage =>
      'Maintenez votre série pour de meilleurs résultats d\'apprentissage !';

  @override
  String get pointsProgressTitle => 'Progrès des Points';

  @override
  String get totalPoints => 'Points Totaux';

  @override
  String get pointsLearningJourney => 'Votre Parcours d\'Apprentissage';

  @override
  String get achievementWordExplorer => 'Explorateur de Mots';

  @override
  String get achievementVocabularyBuilder => 'Constructeur de Vocabulaire';

  @override
  String get achievementLanguageMaster => 'Maître des Langues';

  @override
  String pointsFormat(int count) {
    return '$count pts';
  }

  @override
  String get pointsMotivationMessage =>
      'Continuez à gagner des points pour débloquer de nouveaux accomplissements !';

  @override
  String get closeButton => 'Fermer';

  @override
  String chatWithAITitle(String word) {
    return 'Discutez à propos de \"$word\"';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return 'Posez une question à propos de \"$word\"...';
  }

  @override
  String chatWithAIError(String message) {
    return 'Erreur : $message';
  }

  @override
  String get aiAssistantSystemMessage =>
      'Je suis un expert en apprentissage du vocabulaire qui aide les apprenants à maîtriser de nouveaux mots grâce à des explications complètes et engageantes. Je fournis des définitions claires, des exemples pratiques, des techniques de mémorisation et du contexte culturel. Je rends l\'apprentissage du vocabulaire agréable et mémorable en reliant les mots aux situations réelles et en offrant plusieurs approches d\'apprentissage.';

  @override
  String aiVocabularySystemMessage(String word) {
    return 'Tu es un expert en apprentissage du vocabulaire qui aide un étudiant à apprendre le mot \'$word\'. Fournis des explications complètes et éducatives qui incluent : 1) Définition claire et simple 2) Étymologie ou origine du mot si utile 3) Multiples phrases d\'exemple montrant différents contextes 4) Synonymes et antonymes 5) Collocations et expressions courantes 6) Conseils d\'usage et erreurs communes à éviter 7) Techniques de mémorisation ou mnémotechniques si possible 8) Guide de prononciation si pertinent. Rends tes explications engageantes, pratiques et adaptées pour aider l\'étudiant à vraiment comprendre et retenir le mot. Si on te pose des questions hors sujet, redirige poliment : \'Je suis là pour t\'aider à maîtriser le vocabulaire ! Concentrons-nous sur la compréhension des mots et l\'amélioration de tes compétences linguistiques.\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return 'J\'apprends le mot \'$word\' et je veux vraiment le comprendre. Le dictionnaire dit qu\'il signifie \'$definition\' et voici un exemple : \'$example\'. Pourrais-tu m\'aider à maîtriser ce mot en l\'expliquant clairement et en fournissant des exemples pratiques, des synonymes, des modèles d\'usage courants et des conseils pour le retenir ? Je veux me sentir confiant en utilisant ce mot dans de vraies conversations et en écrivant.';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      'Je suis là pour t\'aider à maîtriser le vocabulaire ! Concentrons-nous sur la compréhension des mots et l\'amélioration de tes compétences linguistiques. Aimerais-tu explorer davantage la signification de ce mot, voir plus d\'exemples ou apprendre des mots connexes ?';

  @override
  String get practiceButtonText => 'Pratiquer';

  @override
  String get goProButtonText => 'Passez Pro';

  @override
  String get letsGrowTogether => 'Grandissons Ensemble ! 🌱';

  @override
  String get reviewMotivationText =>
      'Votre retour nous aide à créer une meilleure expérience d\'apprentissage. Partagez vos pensées et aidez les autres à découvrir la joie d\'apprendre !';

  @override
  String get letsGrowTogetherButton => 'Grandissons Ensemble';

  @override
  String get profileTitle => 'Profil';

  @override
  String get favoriteWords => 'Mots Favoris';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get reviewUs => 'Évaluez-nous';

  @override
  String get contactSupport => 'Contacter le Support';

  @override
  String get onboardingStarted => 'Onboarding Commencé';

  @override
  String get onboardingCompleted => 'Onboarding Terminé';

  @override
  String onboardingPageView(String pageName) {
    return 'Vue de Page d\'Onboarding : $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return 'Progrès : $progress%';
  }

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingBack => 'Retour';

  @override
  String get onboardingStar => 'Étoile';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingPrevious => 'Précédent';

  @override
  String get onboardingProgressLabel => 'Progrès';

  @override
  String get onboardingReviewTitle =>
      'Prêt à apprendre ? Aidez les autres à nous trouver ! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'Nous savons que vous commencez tout juste votre voyage WordStock, mais votre soutien précoce aide d\'autres apprenants de langues à découvrir notre application. Ensemble, nous pouvons construire une communauté de passionnés de mots !';

  @override
  String get onboardingReviewButton => '🌱 Aidez-nous à grandir';

  @override
  String get onboardingReviewSkip => 'Laissez-moi d\'abord l\'essayer';

  @override
  String get onboardingEnglishTestTitle => 'Évaluation Rapide d\'Anglais 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      'Évaluons votre niveau de vocabulaire avec un test rapide de 5 questions. Cela nous aide à personnaliser votre expérience d\'apprentissage !';

  @override
  String get onboardingEnglishTestStart => '🚀 Commencer l\'Évaluation';

  @override
  String get onboardingEnglishTestSkip => 'Ignorer pour l\'instant';

  @override
  String get onboardingEnglishTestIcon => 'Test d\'Anglais';

  @override
  String get onboardingEnglishTestExcellent => 'Excellent ! 🌟';

  @override
  String get onboardingEnglishTestGood => 'Excellent Travail ! 👍';

  @override
  String get onboardingEnglishTestOkay => 'Bon Début ! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return 'Vous avez obtenu $correct sur $total';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsDescription =>
      'Contrôlez quand et comment recevoir les notifications';

  @override
  String get settingsEnableNotifications => 'Activer les notifications';

  @override
  String get settingsEnableNotificationsDescription =>
      'Activer ou désactiver toutes les notifications';

  @override
  String get settingsDailyReminders => 'Rappels quotidiens';

  @override
  String get settingsDailyRemindersDescription =>
      'Recevez des rappels pour pratiquer quotidiennement';

  @override
  String get settingsPracticeReminders => 'Rappels de pratique';

  @override
  String get settingsPracticeRemindersDescription =>
      'Recevez des rappels quand vous n\'avez pas pratiqué';

  @override
  String get settingsNewWords => 'Nouveaux mots';

  @override
  String get settingsNewWordsDescription =>
      'Recevez des notifications sur le nouveau vocabulaire';

  @override
  String get settingsStreakReminders => 'Rappels de série';

  @override
  String get settingsStreakRemindersDescription =>
      'Ne cassez pas votre série d\'apprentissage';

  @override
  String get settingsResetToDefaults => 'Réinitialiser aux valeurs par défaut';

  @override
  String get settingsResetTitle => 'Réinitialiser les paramètres';

  @override
  String get settingsResetMessage =>
      'Êtes-vous sûr de vouloir réinitialiser tous les paramètres à leurs valeurs par défaut ? Cette action ne peut pas être annulée.';

  @override
  String get settingsLoadingMessage => 'Chargement des paramètres...';

  @override
  String get settingsError => 'Erreur de paramètres';

  @override
  String get settingsRetry => 'Réessayer';

  @override
  String get settingsRecover => 'Récupérer';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return 'Niveau de vocabulaire mis à jour vers $levelName';
  }

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get retry => 'Réessayer';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get vocabularyLevel => 'Niveau de vocabulaire';

  @override
  String get supportAndInfo => 'Support et informations';

  @override
  String get copyUserID => 'Copier l\'ID utilisateur';

  @override
  String get userIDCopied => 'ID utilisateur copié dans le presse-papiers';

  @override
  String get legal => 'Légal';

  @override
  String get vocabularyLevelDialogTitle =>
      'Quel est votre niveau de vocabulaire ?';

  @override
  String get vocabularyLevelDialogDescription =>
      'Sélectionnez le niveau qui décrit le mieux votre vocabulaire actuel.';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get notificationPermissionTitle =>
      'Apprenez des mots avec des rappels quotidiens';

  @override
  String get notificationPermissionDescription =>
      'Autorisez les notifications pour recevoir des rappels quotidiens et ne jamais manquer votre série d\'apprentissage.';

  @override
  String get enableNotifications => 'Activer les Notifications';

  @override
  String get requestingPermission => 'Demande d\'autorisation...';

  @override
  String get swipeUp => 'Faites glisser vers le haut';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeDescription => 'Choisissez votre thème préféré';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get onboardingGoalTitle => 'Quel est votre objectif avec l\'anglais ?';

  @override
  String get onboardingGoalSubtitle =>
      'Choisissez ce qui compte le plus. Nous adapterons tout.';

  @override
  String get onboardingGoalSpeakConfidently => 'Parler avec confiance';

  @override
  String get onboardingGoalGrowVocabulary => 'Enrichir mon vocabulaire';

  @override
  String get onboardingGoalPrepareWorkExams =>
      'Me préparer au travail ou aux examens';

  @override
  String get onboardingGoalTravelWithoutStress => 'Voyager sans stress';

  @override
  String get onboardingGoalMixSimilarWords => 'I mix up similar words';

  @override
  String get onboardingGoalSoundNatural => 'I want to sound natural';

  @override
  String get onboardingLevelTitle => 'Quel est votre niveau actuel ?';

  @override
  String get onboardingLevelSubtitle =>
      'N\'y réfléchissez pas trop. Vous pouvez le changer à tout moment.';

  @override
  String get onboardingLevelBeginner => 'Débutant';

  @override
  String get onboardingLevelIntermediate => 'Intermédiaire';

  @override
  String get onboardingLevelAdvanced => 'Avancé';

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
  String get onboardingProgressTitle => 'Vous apprenez déjà.';

  @override
  String get onboardingProgressWordLearned => '1 mot appris';

  @override
  String get onboardingProgressStreakStarted => '1 série commencée';

  @override
  String get onboardingProgressYourProgress => 'Votre progression';

  @override
  String get onboardingProgressMotivation =>
      'Imaginez ce que 5 minutes par jour peuvent accomplir.';

  @override
  String get onboardingDailyHabitTitle =>
      'À quelle fréquence voulez-vous pratiquer ?';

  @override
  String get onboardingDailyHabitSubtitle => 'La régularité bat l\'intensité.';

  @override
  String get onboardingDailyHabitHelper =>
      'We\'ll gently coach you to stay consistent.';

  @override
  String get onboardingDailyHabit5min => '5 min/jour';

  @override
  String get onboardingDailyHabit10min => '10 min/jour';

  @override
  String get onboardingDailyHabit15min => '15 min/jour';

  @override
  String get onboardingPlanTitle => 'Votre plan WordStock est prêt';

  @override
  String get onboardingPlanYourPlan => 'Votre Plan';

  @override
  String get onboardingPlanGoalLabel => 'Objectif';

  @override
  String get onboardingPlanLevelLabel => 'Niveau';

  @override
  String get onboardingPlanDailyLabel => 'Quotidien';

  @override
  String onboardingPlanDailyValue(int minutes) {
    return '$minutes min/jour';
  }

  @override
  String get onboardingPlanWhatYouGet => 'Ce que vous obtiendrez';

  @override
  String onboardingPlanDailyLessons(int minutes) {
    return 'Leçons quotidiennes de $minutes minutes';
  }

  @override
  String get onboardingPlanWordsMatchedLevel => 'Mots adaptés à votre niveau';

  @override
  String get onboardingPlanSmartReviews =>
      'Révisions intelligentes pour ne rien oublier';

  @override
  String get onboardingPlanProgressTracking => 'Suivi des progrès et séries';

  @override
  String get onboardingPlanReassurance =>
      'Designed for where most learners start.';

  @override
  String get onboardingProofTitle => 'Vous n\'êtes pas seul';

  @override
  String get onboardingProofLearnerCount => '42 000+';

  @override
  String get onboardingProofSubtitle =>
      'Join 42,000 learners improving their English every day';

  @override
  String get onboardingProofLearnerLabel =>
      'apprenants améliorant leur anglais chaque jour';

  @override
  String get onboardingProofRating => '4,6 note moyenne';

  @override
  String get onboardingProofAppStore => 'sur l\'App Store';

  @override
  String get onboardingContinue => 'Continuer';
}
