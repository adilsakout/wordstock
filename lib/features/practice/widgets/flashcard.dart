import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/widgets/button.dart';

/// Full-screen flashcard practice session.
class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip(BuildContext context) {
    Gaimon.light();
    context.read<PracticeCubit>().flipCard();
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  void _resetFlip() {
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PracticeCubit, PracticeState>(
      listener: (context, state) {
        if (state is PracticeFlashcardLoaded && !state.isFlipped) {
          _resetFlip();
        }
      },
      builder: (context, state) {
        if (state is! PracticeFlashcardLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffE94E77)),
          );
        }

        final isComplete = state.isComplete;

        if (isComplete) {
          return _FlashcardComplete(state: state);
        }

        final word = state.currentWord;
        final total = state.words.length;
        final current = state.currentIndex + 1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress bar
                Row(
                  children: [
                    Text(
                      '$current / $total',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (current - 1) / total,
                          backgroundColor: const Color(0xffEEEEEE),
                          color: const Color(0xff1CB0F6),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Flip hint
                const Text(
                  'Tap card to reveal definition',
                  style: TextStyle(fontSize: 13, color: Colors.black38),
                ),
                const SizedBox(height: 12),

                // Card
                GestureDetector(
                  onTap: () => _flip(context),
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      final angle = _flipAnimation.value * math.pi;
                      final isFrontVisible = angle < math.pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: isFrontVisible
                            ? _CardFace.front(word: word)
                            : Transform(
                                transform: Matrix4.identity()..rotateY(math.pi),
                                alignment: Alignment.center,
                                child: _CardFace.back(word: word),
                              ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Rate buttons — only show when card is flipped
                AnimatedSlide(
                  offset: state.isFlipped
                      ? Offset.zero
                      : const Offset(0, 1),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: state.isFlipped ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      children: [
                        Expanded(
                          child: PushableButton(
                            height: 56,
                            buttonColor: const Color(0xffFF4B4B),
                            shadowColor: const Color(0xffE94E77),
                            text: "Didn't know",
                            onTap: () {
                              Gaimon.error();
                              context
                                  .read<PracticeCubit>()
                                  .rateCard(knew: false);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PushableButton(
                            height: 56,
                            buttonColor: const Color(0xff58CC02),
                            shadowColor: const Color(0xff58A700),
                            text: 'I knew it!',
                            onTap: () {
                              Gaimon.success();
                              context
                                  .read<PracticeCubit>()
                                  .rateCard(knew: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace.front({required this.word})
      : isFront = true;
  const _CardFace.back({required this.word})
      : isFront = false;

  final Word word;
  final bool isFront;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFront ? const Color(0xffE94E77) : const Color(0xff1CB0F6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isFront
                    ? const Color(0xffE94E77)
                    : const Color(0xff1CB0F6))
                .withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (isFront
                      ? const Color(0xffE94E77)
                      : const Color(0xff1CB0F6))
                  .withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isFront ? 'WORD' : 'DEFINITION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isFront
                    ? const Color(0xffE94E77)
                    : const Color(0xff1CB0F6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (isFront) ...[
            Text(
              word.word,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (word.phonetic != null) ...[
              const SizedBox(height: 8),
              Text(
                word.phonetic!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ] else ...[
            Text(
              word.definition,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            if (word.example != null) ...[
              const SizedBox(height: 12),
              Text(
                '"${word.example}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ],
      ),
    ).animate().fadeIn(duration: 150.ms);
  }
}

/// Shown when all flashcards have been rated.
class _FlashcardComplete extends StatelessWidget {
  const _FlashcardComplete({required this.state});

  final PracticeFlashcardLoaded state;

  @override
  Widget build(BuildContext context) {
    final knew =
        state.results.values.where((v) => v).length;
    final total = state.words.length;
    final percent = total > 0 ? (knew / total * 100).round() : 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 64, color: Color(0xffFFC800)),
            const SizedBox(height: 16),
            const Text(
              'Session Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You knew $knew out of $total words ($percent%)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            PushableButton(
              width: double.infinity,
              height: 56,
              buttonColor: const Color(0xff1CB0F6),
              shadowColor: const Color(0xff1899D6),
              text: 'Practice Again',
              onTap: () =>
                  context.read<PracticeCubit>().startFlashcards(),
            ),
            const SizedBox(height: 12),
            PushableButton(
              width: double.infinity,
              height: 56,
              buttonColor: const Color(0xff58CC02),
              shadowColor: const Color(0xff58A700),
              text: 'Done',
              onTap: () => context.read<PracticeCubit>().resetQuiz(),
            ),
          ],
        ),
      ),
    );
  }
}
