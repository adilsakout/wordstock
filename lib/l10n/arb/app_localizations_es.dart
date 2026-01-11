// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => 'Bienvenido a Wordstock';

  @override
  String get welcomeDescription =>
      'Wordstock es una herramienta que te ayuda a aprender nuevas palabras.';

  @override
  String get infoTitle => 'Crea una lista personalizada de palabras';

  @override
  String get infoDescription =>
      'Wordstock es una herramienta que te ayuda a aprender nuevas palabras.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get continueText => 'Continuar';

  @override
  String get makeYoursTitle => 'Hagamos WordStock tuyo';

  @override
  String makeYoursWithNameTitle(String name) {
    return 'Hagamos WordStock tuyo, $name';
  }

  @override
  String get personalizeDescription =>
      'Algunas preguntas finales para ayudarnos a personalizar tu experiencia.';

  @override
  String get favoriteWordsTitle => 'Tus Palabras Favoritas';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get noFavoritesTitle => 'Aún no hay palabras favoritas';

  @override
  String get noFavoritesDescription =>
      'Comienza a agregar palabras a tus favoritas';

  @override
  String get timeCommitmentTitle => '¿Cuánto tiempo dedicarás al aprendizaje?';

  @override
  String get timeCommitmentDescription =>
      'Elige la cantidad de tiempo que puedes dedicar al aprendizaje cada día.';

  @override
  String get fiveMinutes => '⚡️ 5 minutos al día';

  @override
  String get tenMinutes => '⏱️ 10 minutos al día';

  @override
  String get fifteenMinutes => '⏳ 15 minutos al día';

  @override
  String get thirtyMinutes => '🕰️ 30 minutos al día';

  @override
  String get topicSelectionTitle => '¿Qué temas te interesan?';

  @override
  String get topicSelectionDescription =>
      'Selecciona los temas que más te interesan aprender.';

  @override
  String get topicSociety => '👥 Sociedad';

  @override
  String get topicForeignLanguages => '🌏 Idiomas extranjeros';

  @override
  String get topicHumanBody => '💪 Cuerpo humano';

  @override
  String get topicEmotions => '😃 Emociones';

  @override
  String get topicOther => '🔍 Otros';

  @override
  String customizationLoadingTitleWithName(String name) {
    return '¡Espera un momento, $name! Estamos personalizando tu experiencia Wordstock.';
  }

  @override
  String get customizationLoadingTitle =>
      '¡Espera un momento! Estamos personalizando tu experiencia Wordstock.';

  @override
  String customizationCompleteTitleWithName(String name) {
    return '¡Listo, $name! Tu experiencia Wordstock está preparada.';
  }

  @override
  String get customizationCompleteTitle =>
      '¡Listo! Tu experiencia Wordstock está preparada.';

  @override
  String get craftingExperienceTitle => 'Estamos creando tu';

  @override
  String get learningExperienceSubtitle => 'Experiencia de aprendizaje...';

  @override
  String get profileSetupTitle => 'Configurando tu perfil';

  @override
  String get forgetWordsQuestion =>
      '¿A menudo olvidas palabras nuevas incluso después de repasarlas varias veces?';

  @override
  String get learningPreferencesTitle =>
      'Ajustando tus preferencias de aprendizaje';

  @override
  String get readingConversationQuestion =>
      '¿Te sientes frustrado cuando entiendes una palabra al leer, pero no puedes usarla en conversación?';

  @override
  String get growthAreasTitle => 'Analizando tus áreas de crecimiento';

  @override
  String get progressFrustrationQuestion =>
      '¿Estás poniendo esfuerzo pero aún sientes que no progresas rápidamente?';

  @override
  String get buttonYes => 'Sí';

  @override
  String get buttonNo => 'No';

  @override
  String get toMoveForwardSpecify => 'Para continuar, especifica';

  @override
  String get startLearning => 'Comenzar a Aprender';

  @override
  String get analyzingPreferences => 'Analizando tus preferencias...';

  @override
  String get selectingWords => 'Seleccionando palabras según tu nivel...';

  @override
  String get personalizingPath => 'Personalizando tu camino de aprendizaje...';

  @override
  String get creatingWordList =>
      'Creando tu lista personalizada de palabras...';

  @override
  String get finalizingExperience => 'Finalizando tu experiencia...';

  @override
  String get practiceReminderTitle => '¡Excelente progreso!';

  @override
  String practiceReminderDescription(int count) {
    return '¡Has aprendido $count palabras nuevas! Ahora es el momento perfecto para practicar y reforzar tu aprendizaje.';
  }

  @override
  String get startPractice => 'Comenzar Práctica';

  @override
  String get continueLearning => 'Continuar Aprendiendo';

  @override
  String get streakMilestoneTitle => '¡Hito de Racha!';

  @override
  String streakDaysCount(int count) {
    return '$count días';
  }

  @override
  String streakCongratulationsMessage(int count) {
    return '¡Felicidades! Has estado aprendiendo consistentemente por $count días. ¡Sigue así!';
  }

  @override
  String get streakCongratulationsMessageSingular =>
      '¡Felicidades! Has comenzado tu viaje de aprendizaje hoy. ¡Sigue así!';

  @override
  String streakCongratulationsMessagePlural(int count) {
    return '¡Felicidades! Has estado aprendiendo consistentemente por $count días. ¡Sigue así!';
  }

  @override
  String get keepGoing => '¡Sigue Adelante!';

  @override
  String get streakCongratulationsSingular =>
      '¡Felicidades! Has comenzado tu viaje de aprendizaje hoy. ¡Sigue así!';

  @override
  String get quizResultExcellent => '¡Excelente!';

  @override
  String get quizResultGoodJob => '¡Buen trabajo!';

  @override
  String get quizResultNiceTry => '¡Buen intento!';

  @override
  String get quizResultKeepPracticing => '¡Sigue practicando!';

  @override
  String get quizCompleteMessage =>
      'Has terminado el cuestionario de vocabulario.';

  @override
  String coinsEarned(int count) {
    return '$count monedas ganadas';
  }

  @override
  String quizResultSummary(int correct, int total) {
    return 'Has respondido $correct de $total preguntas correctamente.';
  }

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get home => 'Inicio';

  @override
  String get exitConfirmationTitle => '¿Estás seguro de que quieres salir?';

  @override
  String get exitConfirmationMessage => 'Tu progreso no se guardará.';

  @override
  String get exit => 'Salir';

  @override
  String get continueAction => 'Continuar';

  @override
  String get vocabularyQuiz => 'Cuestionario de Vocabulario';

  @override
  String questionCounter(int current, int total) {
    return '$current/$total';
  }

  @override
  String get selectCorrectWord =>
      'Selecciona la palabra correcta para completar la oración.';

  @override
  String get next => 'Siguiente';

  @override
  String get finish => 'Terminar';

  @override
  String get noQuizQuestions => 'No hay preguntas disponibles';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get commitmentPactTitle => 'Pacto de Compromiso';

  @override
  String get commitmentPactIntro => 'Quiero ';

  @override
  String get commitmentPactInnerNeeds =>
      'mantenerme conectado con mis necesidades internas';

  @override
  String get commitmentPactByLearning => ' aprendiendo';

  @override
  String commitmentPactWordsPerDay(int count) {
    return ' $count palabras por día';
  }

  @override
  String get commitmentPactHelpBecome => ' para ayudarme a convertirme en ';

  @override
  String get commitmentPactVocabularyMaster => 'maestro del vocabulario.';

  @override
  String get commitmentPactTestChampion => 'campeón de exámenes.';

  @override
  String get commitmentPactCareerAchiever => 'triunfador profesional.';

  @override
  String get commitmentPactLifelongLearner => 'aprendiz de por vida.';

  @override
  String get commitmentPactTrust =>
      'Quiero y confío en que Wordstock AI me guíe en el camino y me ayude a cumplir todas mis resoluciones.';

  @override
  String get commitmentPactButton => 'Me comprometo con mis Metas';

  @override
  String get commitmentCongratulationsTitle => '¡Felicidades!';

  @override
  String get commitmentCongratulationsMessage =>
      'Has dado el primer paso en tu viaje de aprendizaje de vocabulario. ¡Tu compromiso te ayudará a alcanzar tus metas!';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get goalSelectionTitle =>
      '¿Cuál es tu objetivo principal de aprendizaje?';

  @override
  String get goalSelectionDescription =>
      'Selecciona el objetivo que mejor describa tu principal objetivo de aprendizaje.';

  @override
  String get goalMasteringWords => '📚 Dominar palabras nuevas';

  @override
  String get goalImprovingMemory => '🧠 Mejorar la memoria';

  @override
  String get goalSpeakingConfidence => '🗣️ Hablar con confianza';

  @override
  String get goalWritingClearly => '✍️ Escribir con claridad';

  @override
  String get goalUnderstandingContent => '🧩 Entender el contenido';

  @override
  String get goalReachingLanguageGoals => '🎯 Alcanzar metas lingüísticas';

  @override
  String get weeklyProgress => 'Progreso Semanal';

  @override
  String currentStreakSingular(int count) {
    return 'Racha actual: $count día';
  }

  @override
  String currentStreakPlural(int count) {
    return 'Racha actual: $count días';
  }

  @override
  String get current => 'Actual';

  @override
  String get goal => 'Meta';

  @override
  String daysText(int count) {
    return '$count días';
  }

  @override
  String percentToGoal(int percent) {
    return '$percent% de tu meta';
  }

  @override
  String get streakMotivationMessage =>
      '¡Mantén tu racha para mejores resultados de aprendizaje!';

  @override
  String get pointsProgressTitle => 'Progreso de Puntos';

  @override
  String get totalPoints => 'Puntos Totales';

  @override
  String get pointsLearningJourney => 'Tu Viaje de Aprendizaje';

  @override
  String get achievementWordExplorer => 'Explorador de Palabras';

  @override
  String get achievementVocabularyBuilder => 'Constructor de Vocabulario';

  @override
  String get achievementLanguageMaster => 'Maestro del Idioma';

  @override
  String pointsFormat(int count) {
    return '$count pts';
  }

  @override
  String get pointsMotivationMessage =>
      '¡Sigue ganando puntos para desbloquear nuevos logros!';

  @override
  String get closeButton => 'Cerrar';

  @override
  String chatWithAITitle(String word) {
    return 'Chatea sobre \"$word\"';
  }

  @override
  String chatWithAIPlaceholder(String word) {
    return 'Haz una pregunta sobre \"$word\"...';
  }

  @override
  String chatWithAIError(String message) {
    return 'Error: $message';
  }

  @override
  String get aiAssistantSystemMessage =>
      'Soy un experto en aprendizaje de vocabulario que ayuda a los estudiantes a dominar nuevas palabras a través de explicaciones completas y atractivas. Proporciono definiciones claras, ejemplos prácticos, técnicas de memoria y contexto cultural. Hago que el aprendizaje de vocabulario sea agradable y memorable conectando las palabras con situaciones de la vida real y ofreciendo múltiples enfoques de aprendizaje.';

  @override
  String aiVocabularySystemMessage(String word) {
    return 'Eres un experto en aprendizaje de vocabulario que ayuda a un estudiante a aprender la palabra \'$word\'. Proporciona explicaciones completas y educativas que incluyan: 1) Definición clara y simple 2) Etimología u origen de la palabra cuando sea útil 3) Múltiples oraciones de ejemplo mostrando diferentes contextos 4) Sinónimos y antónimos 5) Colocaciones y frases comunes 6) Consejos de uso y errores comunes a evitar 7) Técnicas de memoria o mnemotécnicos cuando sea posible 8) Guía de pronunciación si es relevante. Haz tus explicaciones atractivas, prácticas y adaptadas para ayudar al estudiante a entender y recordar verdaderamente la palabra. Si preguntan sobre temas no relacionados, redirige cortésmente: \'¡Estoy aquí para ayudarte a dominar el vocabulario! Enfoquémonos en entender las palabras y mejorar tus habilidades lingüísticas.\'';
  }

  @override
  String aiInitialPrompt(String word, String definition, String example) {
    return 'Estoy aprendiendo la palabra \'$word\' y quiero entenderla realmente. El diccionario dice que significa \'$definition\' y aquí hay un ejemplo: \'$example\'. ¿Podrías ayudarme a dominar esta palabra explicándola claramente y proporcionando ejemplos prácticos, sinónimos, patrones de uso comunes y consejos para recordarla? Quiero sentirme seguro usando esta palabra en conversaciones reales y al escribir.';
  }

  @override
  String get aiVocabularyOnlyResponse =>
      '¡Estoy aquí para ayudarte a dominar el vocabulario! Enfoquémonos en entender las palabras y mejorar tus habilidades lingüísticas. ¿Te gustaría explorar más sobre el significado de esta palabra, ver más ejemplos o aprender sobre palabras relacionadas?';

  @override
  String get practiceButtonText => 'Practicar';

  @override
  String get goProButtonText => 'Hazte Pro';

  @override
  String get letsGrowTogether => '¡Crezcamos Juntos! 🌱';

  @override
  String get reviewMotivationText =>
      'Tu feedback nos ayuda a crear una mejor experiencia de aprendizaje. ¡Comparte tus pensamientos y ayuda a otros a descubrir la alegría de aprender!';

  @override
  String get letsGrowTogetherButton => 'Crezcamos Juntos';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get favoriteWords => 'Palabras Favoritas';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get reviewUs => 'Reseñanos';

  @override
  String get contactSupport => 'Contactar Soporte';

  @override
  String get onboardingStarted => 'Onboarding Iniciado';

  @override
  String get onboardingCompleted => 'Onboarding Completado';

  @override
  String onboardingPageView(String pageName) {
    return 'Vista de Página de Onboarding: $pageName';
  }

  @override
  String onboardingProgress(int progress) {
    return 'Progreso: $progress%';
  }

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingStar => 'Estrella';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingPrevious => 'Anterior';

  @override
  String get onboardingProgressLabel => 'Progreso';

  @override
  String get onboardingReviewTitle =>
      '¿Listo para aprender? ¡Ayuda a otros a encontrarnos! 🌱';

  @override
  String get onboardingReviewSubtitle =>
      'Sabemos que apenas estás comenzando tu viaje con WordStock, pero tu apoyo temprano ayuda a otros estudiantes de idiomas a descubrir nuestra app. ¡Juntos podemos construir una comunidad de entusiastas de las palabras!';

  @override
  String get onboardingReviewButton => '🌱 Ayúdanos a crecer';

  @override
  String get onboardingReviewSkip => 'Déjame probarlo primero';

  @override
  String get onboardingEnglishTestTitle => 'Evaluación Rápida de Inglés 📝';

  @override
  String get onboardingEnglishTestSubtitle =>
      'Midamos tu nivel de vocabulario con una prueba rápida de 5 preguntas. ¡Esto nos ayuda a personalizar tu experiencia de aprendizaje!';

  @override
  String get onboardingEnglishTestStart => '🚀 Comenzar Evaluación';

  @override
  String get onboardingEnglishTestSkip => 'Omitir por Ahora';

  @override
  String get onboardingEnglishTestIcon => 'Prueba de Inglés';

  @override
  String get onboardingEnglishTestExcellent => '¡Excelente! 🌟';

  @override
  String get onboardingEnglishTestGood => '¡Gran Trabajo! 👍';

  @override
  String get onboardingEnglishTestOkay => '¡Buen Comienzo! 💡';

  @override
  String onboardingEnglishTestScore(int correct, int total) {
    return 'Obtuviste $correct de $total';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsNotificationsDescription =>
      'Controla cuándo y cómo recibir notificaciones';

  @override
  String get settingsEnableNotifications => 'Activar notificaciones';

  @override
  String get settingsEnableNotificationsDescription =>
      'Activar o desactivar todas las notificaciones';

  @override
  String get settingsDailyReminders => 'Recordatorios diarios';

  @override
  String get settingsDailyRemindersDescription =>
      'Recibe recordatorios para practicar diariamente';

  @override
  String get settingsPracticeReminders => 'Recordatorios de práctica';

  @override
  String get settingsPracticeRemindersDescription =>
      'Recibe recordatorios cuando no hayas practicado';

  @override
  String get settingsNewWords => 'Nuevas palabras';

  @override
  String get settingsNewWordsDescription =>
      'Recibe notificaciones sobre nuevo vocabulario';

  @override
  String get settingsStreakReminders => 'Recordatorios de racha';

  @override
  String get settingsStreakRemindersDescription =>
      'No rompas tu racha de aprendizaje';

  @override
  String get settingsResetToDefaults => 'Restablecer valores por defecto';

  @override
  String get settingsResetTitle => 'Restablecer configuración';

  @override
  String get settingsResetMessage =>
      '¿Estás seguro de que quieres restablecer toda la configuración a sus valores por defecto? Esta acción no se puede deshacer.';

  @override
  String get settingsLoadingMessage => 'Cargando configuración...';

  @override
  String get settingsError => 'Error de configuración';

  @override
  String get settingsRetry => 'Reintentar';

  @override
  String get settingsRecover => 'Recuperar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Restablecer';

  @override
  String vocabularyLevelUpdated(String levelName) {
    return 'Nivel de vocabulario actualizado a $levelName';
  }

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get retry => 'Reintentar';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get vocabularyLevel => 'Nivel de vocabulario';

  @override
  String get supportAndInfo => 'Soporte e información';

  @override
  String get copyUserID => 'Copiar ID de usuario';

  @override
  String get userIDCopied => 'ID de usuario copiado al portapapeles';

  @override
  String get legal => 'Legal';

  @override
  String get vocabularyLevelDialogTitle => '¿Cuál es tu nivel de vocabulario?';

  @override
  String get vocabularyLevelDialogDescription =>
      'Selecciona el nivel que mejor describa tu vocabulario actual.';

  @override
  String get saveButton => 'Guardar';

  @override
  String get notificationPermissionTitle =>
      'Aprende palabras con recordatorios diarios';

  @override
  String get notificationPermissionDescription =>
      'Permite las notificaciones para recibir recordatorios diarios y nunca perder tu racha de aprendizaje.';

  @override
  String get enableNotifications => 'Habilitar Notificaciones';

  @override
  String get requestingPermission => 'Solicitando Permiso...';

  @override
  String get swipeUp => 'Desliza hacia arriba';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeDescription => 'Elige tu tema preferido';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';
}
