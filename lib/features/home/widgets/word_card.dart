import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordstock/features/home/cubit/home_cubit.dart';
import 'package:wordstock/features/home/widgets/chat_ai_button.dart';
import 'package:wordstock/features/home/widgets/shareable_word_card.dart';
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

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _moveAnimation;

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: const Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );

    _moveAnimation = Tween<double>(
      begin: 0,
      end: 200,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Future<void> shareWord() async {
    Gaimon.soft();
    await _screenshotController
        .captureFromWidget(
      ShareableWordCard(word: widget.word),
    )
        .then((capturedImage) async {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/wordstock_${widget.word.word}.png');
      await file.writeAsBytes(capturedImage);
      await Share.shareXFiles([XFile(file.path)]);
    });
  }

  void _handleFavoriteClick() {
    final isCurrentlyFavorite = widget.word.isFavorite ?? false;
    widget.onToggleFavorite();

    if (!isCurrentlyFavorite) {
      Gaimon.soft();
      _heartController.forward().then((_) {
        _heartController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.word.isFavorite ?? false;
    return GestureDetector(
      onDoubleTap: () {
        if (!isFavorite) {
          _handleFavoriteClick();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
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
                    const SizedBox(height: 15),
                    Text(
                      widget.word.definition,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.word.example?.replaceAll('"', '') ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                return Positioned(
                  bottom: 150 + _moveAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: const Icon(
                        Icons.favorite,
                        size: 150,
                        color: Color(0xffE94E77),
                      ),
                    ),
                  ),
                );
              },
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
                    buttonColor: isFavorite
                        ? const Color(0xffE94E77)
                        : const Color(0xff1CB0F6),
                    shadowColor: isFavorite
                        ? const Color(0xffA8002C)
                        : const Color(0xff1899D6),
                    suffixIcon: isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    onTap: _handleFavoriteClick,
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
                    onTap: () =>
                        context.read<HomeCubit>().speakWord(widget.word.word),
                  ),
                  ChatAIButton(word: widget.word),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
