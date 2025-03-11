import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordstock/features/favorite_words/cubit/favorite_words_cubit.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

class FavoriteWordCard extends StatefulWidget {
  const FavoriteWordCard({
    required this.word,
    required this.onToggleFavorite,
    super.key,
  });

  final Word word;
  final VoidCallback onToggleFavorite;

  @override
  State<FavoriteWordCard> createState() => _FavoriteWordCardState();
}

class _FavoriteWordCardState extends State<FavoriteWordCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
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

  Future<void> _handleToggleFavorite() async {
    await _heartController.forward();
    widget.onToggleFavorite();
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
                    onTap: () => context
                        .read<FavoriteWordsCubit>()
                        .speakWord(widget.word.word),
                  ),
                  const SizedBox(width: 8),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: PushableButton(
                        width: 40,
                        height: 40,
                        text: '',
                        buttonColor: const Color(0xffE94E77),
                        shadowColor: const Color(0xffA8002C),
                        suffixIcon: Icons.favorite,
                        onTap: _handleToggleFavorite,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.word.definition,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
  }
}
