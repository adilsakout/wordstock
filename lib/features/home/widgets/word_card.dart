import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

class WordCard extends StatefulWidget {
  const WordCard({required this.word, super.key});
  final Word word;

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final TextToSpeech tts = TextToSpeech();

  Future<void> speak() async {
    await tts.speak(widget.word.word);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
                  onTap: speak,
                ),
                PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  iconSize: 25,
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  suffixIcon: Icons.favorite_border_outlined,
                  onTap: () {},
                ),
                PushableButton(
                  width: 50,
                  height: 50,
                  text: '',
                  iconSize: 25,
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  suffixIcon: Icons.bookmark_border_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
