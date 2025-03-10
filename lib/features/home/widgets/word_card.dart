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
  void initState() {
    super.initState();
    initTTS();
  }

  Future<void> initTTS() async {
    await tts.setLanguage('en-US');
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.word.isFavorite ?? false;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.word.word,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                ).animate(delay: 0.5.seconds).slideY(),
                const SizedBox(height: 10),
                Text(
                  widget.word.definition,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  suffixIcon: Icons.share_rounded,
                  onTap: shareWord,
                ),
                PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  iconSize: 25,
                  shouldPlaySound: false,
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  suffixIcon: Icons.volume_down_rounded,
                  onTap: () async {
                    await speak();
                  },
                ),
                PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  iconSize: 25,
                  buttonColor: isFavorite
                      ? const Color(0xffE94E77)
                      : const Color(0xff1CB0F6),
                  shadowColor: isFavorite
                      ? const Color(0xffA8002C)
                      : const Color(0xff1899D6),
                  suffixIcon: isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  onTap: widget.onToggleFavorite,
                )
                    .animate(target: isFavorite ? 1 : 0)
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
          ),
        ],
      ),
    );
  }
}
