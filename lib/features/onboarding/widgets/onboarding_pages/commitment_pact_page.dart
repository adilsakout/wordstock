import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/onboarding.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/arb/app_localizations.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

class CommitmentPactPage extends StatefulWidget {
  const CommitmentPactPage({super.key});

  @override
  State<CommitmentPactPage> createState() => _CommitmentPactPageState();
}

class _CommitmentPactPageState extends State<CommitmentPactPage> {
  bool _isCommitted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCommitSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
      Gaimon.success(); // Vibration feedback
    } catch (e) {
      debugPrint('Error playing commit sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<OnboardingCubit>();
    final wordsPerDay = cubit.wordsPerDay;
    final selectedGoals = cubit.selectedGoals;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!_isCommitted) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffF9C835), width: 4),
              ),
              child: SvgPicture.asset(
                Assets.icons.handshake,
                colorFilter:
                    const ColorFilter.mode(Color(0xffF9C835), BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.commitmentPactTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                textAlign: TextAlign.center, // Ensures all text is centered
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                      ),
                  children: [
                    TextSpan(text: l10n.commitmentPactIntro),
                    TextSpan(
                      text: l10n.commitmentPactInnerNeeds,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    TextSpan(text: l10n.commitmentPactByLearning),
                    TextSpan(
                      text: l10n.commitmentPactWordsPerDay(wordsPerDay),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextSpan(text: l10n.commitmentPactHelpBecome),
                    TextSpan(
                      text: _getLocalizedLearningGoal(l10n, selectedGoals),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.commitmentPactTrust,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                  ),
            ),
            const Spacer(),
            PushableButton(
              text: l10n.commitmentPactButton,
              onTap: () async {
                await _playCommitSound();
                setState(() {
                  _isCommitted = true;
                });
              },
              width: MediaQuery.of(context).size.width,
              buttonColor: const Color(0xffF9C835),
              shadowColor: const Color(0xffCDB054),
              height: 50,
            ),
            const SizedBox(height: 40),
          ] else ...[
            // Congratulations UI after commitment
            const Spacer(),
            const Icon(
              Icons.check_circle,
              color: Color(0xFF58CC02),
              size: 100,
            ).animate().scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 30),
            Text(
              l10n.commitmentCongratulationsTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF58CC02),
                  ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 300.ms)
                .slideY(begin: -0.2, end: 0, duration: 500.ms, delay: 300.ms),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.commitmentCongratulationsMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 500.ms),
            const Spacer(),
            PushableButton(
              text: l10n.continueAction,
              onTap: cubit.nextPage,
              width: 300,
              buttonColor: const Color(0xFF58CC02),
              shadowColor: const Color(0xFF58A700),
              height: 50,
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 800.ms)
                .slideY(begin: 0.5, end: 0, duration: 500.ms, delay: 800.ms),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }

  String _getLocalizedLearningGoal(
    AppLocalizations l10n,
    List<String> selectedGoals,
  ) {
    if (selectedGoals.isEmpty) return l10n.commitmentPactVocabularyMaster;

    // Match based on the localized goal strings
    if (selectedGoals.contains(l10n.goalMasteringWords)) {
      return l10n.commitmentPactVocabularyMaster;
    } else if (selectedGoals.contains(l10n.goalImprovingMemory) ||
        selectedGoals.contains(l10n.goalReachingLanguageGoals)) {
      return l10n.commitmentPactTestChampion;
    } else if (selectedGoals.contains(l10n.goalSpeakingConfidence) ||
        selectedGoals.contains(l10n.goalWritingClearly)) {
      return l10n.commitmentPactCareerAchiever;
    } else if (selectedGoals.contains(l10n.goalUnderstandingContent)) {
      return l10n.commitmentPactLifelongLearner;
    }

    // Default fallback
    return l10n.commitmentPactVocabularyMaster;
  }
}
