import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordstock/features/profile/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
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
                        horizontal: 24, vertical: 20),
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

                      const SizedBox(height: 24),
                      // Support Section
                      Text(
                        'Support & Info',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ).animate().fadeIn(
                            duration: 250.milliseconds,
                            delay: 300.milliseconds,
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
                            delay: 350.milliseconds,
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
                            delay: 400.milliseconds,
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
                            delay: 450.milliseconds,
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
                            delay: 500.milliseconds,
                          ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        context,
                        icon: Icons.description,
                        title: l10n.termsOfService,
                        onTap: () {
                          Gaimon.soft();
                          _launchURL(
                              'https://wordstockaiapp.com/terms-of-service');
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 550.milliseconds,
                          ),
                      _buildMenuItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: l10n.privacyPolicy,
                        onTap: () {
                          Gaimon.soft();
                          _launchURL(
                              'https://wordstockaiapp.com/privacy-policy');
                        },
                      ).animate().fadeIn(
                            duration: 200.milliseconds,
                            delay: 600.milliseconds,
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
