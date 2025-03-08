// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordstock/features/home/cubit/cubit.dart';
import 'package:wordstock/features/home/widgets/word_card.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template home_body}
/// Body of the HomePage.
///
/// This widget displays a list of vocabulary words.
/// {@endtemplate}
class HomeBody extends StatefulWidget {
  /// {@macro home_body}
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchWords();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is HomeLoaded && state.celebration) {}
      },
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: state.words.length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    context.read<HomeCubit>().onWordRead();
                  },
                  itemBuilder: (context, index) {
                    return WordCard(
                      word: state.words[index],
                    );
                  },
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: const Color(0xffF97316),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(Assets.icons.flame),
                              const SizedBox(width: 5),
                              Text(
                                '100',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffF97316),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: const Color(0xffFFC20E),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(Assets.icons.coin),
                              const SizedBox(width: 5),
                              Text(
                                '192',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffFFC20E),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PushableButton(
                          width: 50,
                          height: 50,
                          text: '',
                          iconSize: 25,
                          suffixIcon: Icons.category,
                          buttonColor: const Color(0xffF9C835),
                          shadowColor: const Color(0xffCDB054),
                          onTap: () {},
                        ),
                        const SizedBox(width: 20),
                        PushableButton(
                          width: 50,
                          height: 50,
                          text: '',
                          iconSize: 25,
                          suffixIcon: Icons.person,
                          buttonColor: const Color(0xffF9C835),
                          shadowColor: const Color(0xffCDB054),
                          onTap: () {},
                        ),
                        const Spacer(),
                        PushableButton(
                          width: 140,
                          height: 50,
                          text: 'Practice',
                          spacing: 10,
                          iconSize: 25,
                          prefixIcon: Icons.gamepad_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
