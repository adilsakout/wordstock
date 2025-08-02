import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/core/services/navigation_service.dart';
import 'package:wordstock/features/profile/cubit/cubit.dart';
import 'package:wordstock/l10n/arb/app_localizations.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template profile_body}
/// Body of the ProfilePage following clean architecture principles.
///
/// This widget is purely presentational and reactive
/// to ProfileCubit state changes.
/// It delegates all business logic to ProfileCubit
///  and navigation to NavigationService.
/// {@endtemplate}
class ProfileBody extends StatefulWidget {
  /// {@macro profile_body}
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = const NavigationService();

    // Load profile data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadProfile();
    });
  }

  /// Handle URL launching (external links)
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Handle vocabulary level menu item tap
  /// Delegates to ProfileCubit for business logic
  void _onVocabularyLevelTap() {
    Gaimon.soft();
    context.read<ProfileCubit>().showVocabularyLevelDialog();
  }

  /// Handle vocabulary level selection from dialog
  /// Delegates to ProfileCubit for business logic
  Future<void> _handleVocabularyLevelDialog(
    VocabularyLevel currentLevel,
  ) async {
    final cubit = context.read<ProfileCubit>();
    final selectedLevel =
        await _navigationService.showVocabularyLevelBottomSheet(
      context,
      currentLevel: currentLevel,
    );

    if (selectedLevel != null && mounted) {
      await cubit.updateVocabularyLevel(selectedLevel);
    }
  }

  /// Handle success state by showing feedback
  void _handleVocabularyLevelUpdated(VocabularyLevel updatedLevel) {
    final levelConfig = VocabularyLevels.getByLevel(updatedLevel);
    _navigationService.showSuccessSnackBar(
      context,
      message: 'Vocabulary level updated to ${levelConfig.displayName}',
    );
  }

  /// Handle error state by showing error message
  void _handleError(String message) {
    _navigationService.showErrorSnackBar(
      context,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // Handle state changes that require side effects
        if (state is ProfileShowVocabularyLevelDialog) {
          _handleVocabularyLevelDialog(state.currentLevel);
        } else if (state is ProfileVocabularyLevelUpdated) {
          _handleVocabularyLevelUpdated(state.updatedLevel);
        } else if (state is ProfileError) {
          _handleError(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                _buildHeader(context, l10n),

                // Main content
                Expanded(
                  child: _buildContent(context, l10n, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the header section with back button and title
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
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
    );
  }

  /// Build the main content based on current state
  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    ProfileState state,
  ) {
    // Show loading indicator while profile is loading
    if (state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xffF9C835),
        ),
      );
    }

    // Show error state with retry option (but not for vocabulary update errors)
    if (state is ProfileError && state is! ProfileVocabularyLevelUpdated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            PushableButton(
              width: 120,
              height: 50,
              text: 'Retry',
              buttonColor: const Color(0xffF9C835),
              shadowColor: const Color(0xffCDB054),
              onTap: () => context.read<ProfileCubit>().loadProfile(),
            ),
          ],
        ),
      );
    }

    // Show main profile content
    return _buildProfileContent(context, l10n, state);
  }

  /// Build the main profile menu content
  Widget _buildProfileContent(
    BuildContext context,
    AppLocalizations l10n,
    ProfileState state,
  ) {
    final isUpdating = state is ProfileUpdatingVocabularyLevel;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      children: [
        // Quick Actions Section
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
            _navigationService.navigateToSettings(context);
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
            _navigationService.navigateToFavorites(context);
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 250.milliseconds,
            ),

        _buildMenuItem(
          context,
          icon: Icons.school,
          title: 'Vocabulary Level',
          onTap: isUpdating ? null : _onVocabularyLevelTap,
          isLoading: isUpdating,
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
              _navigationService.showSuccessSnackBar(
                context,
                message: 'User ID copied to clipboard',
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
        const Text(
          'Legal',
          style: TextStyle(
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
            _launchURL('https://wordstockaiapp.com/terms-of-service');
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
            _launchURL('https://wordstockaiapp.com/privacy-policy');
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 650.milliseconds,
            ),

        // Bottom spacing for better UX
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xffF9C835).withValues(alpha: 0.1),
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
            child: Opacity(
              opacity: onTap == null ? 0.6 : 1.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: onTap == null
                              ? [Colors.grey[400]!, Colors.grey[500]!]
                              : [
                                  const Color(0xffF9C835),
                                  const Color(0xffCDB054),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (onTap == null
                                    ? Colors.grey[500]!
                                    : const Color(0xffCDB054))
                                .withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(
                              icon,
                              color: Colors.white,
                              size: 22,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: onTap == null
                              ? Colors.grey[600]
                              : const Color(0xFF1D1D1F),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (onTap == null
                                ? Colors.grey[400]!
                                : const Color(0xffF9C835))
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: onTap == null
                            ? Colors.grey[600]
                            : const Color(0xffCDB054),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
