import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

class WordCard extends StatefulWidget {
  const WordCard({
    required this.word,
    required this.onToggleFavorite,
    super.key,
  });

  final Word word;
  final VoidCallback onToggleFavorite;

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final TextToSpeech tts = TextToSpeech();

  Future<void> speak() async {
    await tts.speak(widget.word.word);
  }

  Future<void> shareWord() async {
    final text = '''
📚 Word of the Day:
${widget.word.word}

📖 Definition:
${widget.word.definition}

#Wordstock #Vocabulary
''';
    await Share.share(text);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.word.word,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Row(
                children: [
                  PushableButton(
                    width: 40,
                    height: 40,
                    text: '',
                    buttonColor: const Color(0xff1CB0F6),
                    shadowColor: const Color(0xff1899D6),
                    suffixIcon: Icons.share_rounded,
                    onTap: shareWord,
                  ),
                  const SizedBox(width: 8),
                  PushableButton(
                    width: 40,
                    height: 40,
                    text: '',
                    shouldPlaySound: false,
                    buttonColor: const Color(0xff1CB0F6),
                    shadowColor: const Color(0xff1899D6),
                    suffixIcon: Icons.volume_down_rounded,
                    onTap: speak,
                  ),
                  const SizedBox(width: 8),
                  PushableButton(
                    width: 40,
                    height: 40,
                    text: '',
                    buttonColor: const Color(0xffE94E77),
                    shadowColor: const Color(0xffA8002C),
                    suffixIcon: Icons.favorite,
                    onTap: widget.onToggleFavorite,
                  )
                      .animate(target: 1)
                      .scaleXY(
                        begin: 0.9,
                        end: 1.1,
                        curve: Curves.easeInOut,
                        duration: 200.ms,
                      )
                      .then()
                      .scaleXY(
                        begin: 1.1,
                        end: 0.9,
                        curve: Curves.easeInOut,
                        duration: 200.ms,
                      ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.word.definition ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
  }
}
