import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

class WordCard extends StatelessWidget {
  const WordCard({required this.word, super.key});
  final WordModel word;

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
                  word.word,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                ).animate(delay: 0.5.seconds).slideY(),
                const SizedBox(height: 10),
                Text(
                  word.partOfSpeech,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  word.definition,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xff999999),
                      ),
                  textAlign: TextAlign.center,
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
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  suffixIcon: Icons.volume_down_rounded,
                  onTap: () {},
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
