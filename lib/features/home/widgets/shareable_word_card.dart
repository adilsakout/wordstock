import 'package:flutter/material.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/model/word.dart';

class ShareableWordCard extends StatelessWidget {
  const ShareableWordCard({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Image.asset(
                  Assets.images.branding.path,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Wordstock AI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            word.word,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            word.definition,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            word.example?.replaceAll('"', '') ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'Poppins',
                ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
