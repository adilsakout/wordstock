import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordstock/features/favorite_words/favorite_words.dart';
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
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                children: [
                  // Header with title and close button
                  Row(
                    children: [
                      Text(
                        l10n.profileTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                      ).animate().fadeIn().slideY(
                            begin: 1,
                            duration: 400.milliseconds,
                          ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Gaimon.soft();
                          context.pop();
                        },
                        icon: const Icon(Icons.close),
                      ).animate().fadeIn().slideY(
                            begin: 1,
                            duration: 400.milliseconds,
                          ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Menu Items
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite,
                    title: l10n.favoriteWords,
                    onTap: () {
                      Gaimon.soft();
                      context
                        ..pop()
                        ..push(FavoriteWordsPage.name);
                    },
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 100.milliseconds,
                        duration: 400.milliseconds,
                      ),
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
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 200.milliseconds,
                        duration: 400.milliseconds,
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
                          const SnackBar(
                            content: Text('User ID copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 300.milliseconds,
                        duration: 400.milliseconds,
                      ),
                  _buildMenuItem(
                    context,
                    icon: Icons.support_agent,
                    title: l10n.contactSupport,
                    onTap: () {
                      Gaimon.soft();
                      _launchURL('https://wordstockaiapp.com/contact');
                    },
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 400.milliseconds,
                        duration: 400.milliseconds,
                      ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description,
                    title: l10n.termsOfService,
                    onTap: () {
                      Gaimon.soft();
                      _launchURL('https://wordstockaiapp.com/terms-of-service');
                    },
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 500.milliseconds,
                        duration: 400.milliseconds,
                      ),
                  _buildMenuItem(
                    context,
                    icon: Icons.privacy_tip,
                    title: l10n.privacyPolicy,
                    onTap: () {
                      Gaimon.soft();
                      _launchURL('https://wordstockaiapp.com/privacy-policy');
                    },
                  ).animate().fadeIn().slideY(
                        begin: 1,
                        delay: 600.milliseconds,
                        duration: 400.milliseconds,
                      ),
                ],
              ),
            );
          },
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
      padding: const EdgeInsets.only(bottom: 16),
      child: PushableButton(
        width: double.infinity,
        height: 60,
        text: title,
        buttonColor: const Color(0xff1CB0F6),
        shadowColor: const Color(0xff1899D6),
        onTap: onTap,
        prefixIcon: icon,
        suffixIcon: Icons.chevron_right,
        spacing: 16,
        iconSize: 24,
      ),
    );
  }
}
