import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/features/profile/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template profile_body}
/// Body of the ProfilePage.
///
/// Displays user profile options and settings in a modern, animated interface
/// that matches the app's design language.
/// {@endtemplate}
class ProfileBody extends StatelessWidget {
  /// {@macro profile_body}
  const ProfileBody({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Show vocabulary level selection bottom sheet
  Future<void> _showVocabularyLevelBottomSheet(BuildContext context) async {
    int? selectedLevel;

    // Try to get current vocabulary level from user profile
    try {
      final userProfile = await UserRepository().getProfile();
      selectedLevel = userProfile.level.index;
    } catch (e) {
      // Default to beginner if unable to fetch profile
      selectedLevel = 0;
    }

    if (!context.mounted) return;

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VocabularyLevelBottomSheet(
        currentLevel: selectedLevel!,
      ),
    );

    if (result != null && context.mounted) {
      // Update vocabulary level in backend
      try {
        final vocabularyLevel = VocabularyLevel.values[result];
        await UserRepository().updateVocabularyLevel(vocabularyLevel);

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Vocabulary level updated to ${VocabularyLevels.getById(result)?.displayName ?? 'Unknown'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xffF9C835),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(20),
          ),
        );
      } catch (e) {
        // Show error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to update vocabulary level. Please try again.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PushableButton(
                        width: 50,
                        height: 50,
                        buttonColor: const Color(0xffF9C835),
                        shadowColor: const Color(0xffCDB054),
                        text: '',
                        suffixIcon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ).animate().fadeIn(
                            duration: 300.milliseconds,
                            delay: 50.milliseconds,
                          ),
                      Text(
                        l10n.profileTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ).animate().fadeIn(
                            duration: 300.milliseconds,
                            delay: 100.milliseconds,
                          ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ).animate().fadeIn(
                            duration: 250.milliseconds,
                            delay: 150.milliseconds,
                          ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: l10n.settingsNotifications,
                        onTap: () {
                          Gaimon.soft();
                          context.push('/settings');
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 200.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite,
                        title: l10n.favoriteWords,
                        onTap: () {
                          Gaimon.soft();
                          context.push('/home/favorites');
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 250.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.school,
                        title: 'Vocabulary Level',
                        onTap: () {
                          Gaimon.soft();
                          _showVocabularyLevelBottomSheet(context);
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 300.milliseconds,
                          ),

                      const SizedBox(height: 24),
                      // Support Section
                      const Text(
                        'Support & Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ).animate().fadeIn(
                            duration: 250.milliseconds,
                            delay: 350.milliseconds,
                          ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        context,
                        icon: Icons.star,
                        title: l10n.reviewUs,
                        onTap: () async {
                          Gaimon.soft();
                          final inAppReview = InAppReview.instance;
                          if (await inAppReview.isAvailable()) {
                            await inAppReview.openStoreListing(
                              appStoreId: '6743778895',
                            );
                          }
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 400.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.copy,
                        title: 'Copy User ID',
                        onTap: () async {
                          Gaimon.soft();
                          final userId = UserRepository().getUserId();
                          await Clipboard.setData(ClipboardData(text: userId));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'User ID copied to clipboard',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: const Color(0xffF9C835),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.all(20),
                              ),
                            );
                          }
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 450.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.support_agent,
                        title: l10n.contactSupport,
                        onTap: () {
                          Gaimon.soft();
                          _launchURL('https://wordstockaiapp.com/contact');
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 500.milliseconds,
                          ),

                      const SizedBox(height: 24),
                      // Legal Section
                      Text(
                        'Legal',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ).animate().fadeIn(
                            duration: 250.milliseconds,
                            delay: 550.milliseconds,
                          ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        context,
                        icon: Icons.description,
                        title: l10n.termsOfService,
                        onTap: () {
                          Gaimon.soft();
                          _launchURL(
                            'https://wordstockaiapp.com/terms-of-service',
                          );
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 600.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: l10n.privacyPolicy,
                        onTap: () {
                          Gaimon.soft();
                          _launchURL(
                            'https://wordstockaiapp.com/privacy-policy',
                          );
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 650.milliseconds,
                          ),

                      // Bottom spacing for better UX
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xffF9C835).withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffF9C835), Color(0xffCDB054)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffCDB054).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xffF9C835).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Color(0xffCDB054),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for vocabulary level selection
class _VocabularyLevelBottomSheet extends StatefulWidget {
  const _VocabularyLevelBottomSheet({
    required this.currentLevel,
  });

  final int currentLevel;

  @override
  State<_VocabularyLevelBottomSheet> createState() =>
      _VocabularyLevelBottomSheetState();
}

class _VocabularyLevelBottomSheetState
    extends State<_VocabularyLevelBottomSheet> {
  late int selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

  void _selectVocabularyLevel(int level) {
    setState(() {
      selectedLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().fadeIn(
                  duration: 300.milliseconds,
                ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'What is your Vocabulary Level?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ).animate().fadeIn(
                  duration: 400.milliseconds,
                  delay: 100.milliseconds,
                ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Select the level that best describes your current vocabulary.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ).animate().fadeIn(
                  duration: 400.milliseconds,
                  delay: 200.milliseconds,
                ),
            const SizedBox(height: 32),

            // Vocabulary level selectors
            ...List.generate(
              VocabularyLevels.all.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Selector(
                  text: VocabularyLevels.all[index].fullDisplayText,
                  selected: selectedLevel == index,
                  onTap: () => _selectVocabularyLevel(index),
                ).animate().fadeIn(
                      duration: 300.milliseconds,
                      delay: Duration(milliseconds: 300 + (index * 100)),
                    ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: PushableButton(
                    width: double.infinity,
                    height: 50,
                    text: 'Cancel',
                    textColor: Colors.black87,
                    buttonColor: Colors.grey[200]!,
                    shadowColor: Colors.grey[400]!,
                    onTap: () => Navigator.of(context).pop(),
                  ).animate().fadeIn(
                        duration: 300.milliseconds,
                        delay: const Duration(milliseconds: 600),
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PushableButton(
                    width: double.infinity,
                    height: 50,
                    text: 'Save',
                    buttonColor: const Color(0xffF9C835),
                    shadowColor: const Color(0xffCDB054),
                    onTap: () => Navigator.of(context).pop(selectedLevel),
                  ).animate().fadeIn(
                        duration: 300.milliseconds,
                        delay: const Duration(milliseconds: 700),
                      ),
                ),
              ],
            ),

            // Bottom spacing for safe area
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
