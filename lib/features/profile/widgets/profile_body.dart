import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordstock/bootstrap.dart';
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

/// {@template profile_menu_item}
/// A custom menu item widget for the profile page that follows the
/// Selector design pattern
/// while maintaining profile-specific styling and functionality.
///
/// Features:
/// - Consistent shadowed button design matching Selector
/// - Icon integration with gradient backgrounds
/// - Loading state support
/// - Proper opacity handling for disabled states
/// - Apple-style animations and interactions
/// {@endtemplate}
class ProfileMenuItem extends StatefulWidget {
  /// {@macro profile_menu_item}
  const ProfileMenuItem({
    required this.icon,
    required this.title,
    super.key,
    this.onTap,
    this.isLoading = false,
  });

  /// The icon to display in the menu item
  final IconData icon;

  /// The title text for the menu item
  final String title;

  /// Callback function when the menu item is tapped
  final VoidCallback? onTap;

  /// Whether the menu item is in a loading state
  final bool isLoading;

  @override
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for press effect
    // Uses shorter duration for snappy interactions following Apple HIG
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handle tap down - start press animation
  void _handleTapDown() {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  /// Handle tap up/cancel - reverse press animation
  void _handleTapCancel() {
    _animationController.reverse();
  }

  /// Handle successful tap - trigger haptic feedback and callback
  void _handleTap() {
    // Provide tactile feedback following Apple HIG
    Gaimon.selection();
    widget.onTap?.call();
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapCancel(),
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap != null ? _handleTap : null,
        child: SizedBox(
          width: double.infinity,
          height: 80, // Slightly taller than selector for better content fit
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Calculate press effect offset
              final pressOffset = _animationController.value * 4;

              return Stack(
                children: [
                  // Shadow layer - provides depth like Selector
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff999999),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  // Main content layer with press animation
                  Positioned(
                    top: pressOffset,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xffE5E5E7),
                        ),
                        boxShadow: [
                          // Subtle shadow for premium feel
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: Offset(0, 4 - pressOffset),
                          ),
                          // Brand color accent shadow
                          BoxShadow(
                            color:
                                const Color(0xffF9C835).withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: Offset(0, 2 - pressOffset),
                          ),
                        ],
                      ),
                      child: Opacity(
                        // Dim disabled items following accessibility guidelines
                        opacity: widget.onTap == null ? 0.6 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Row(
                            children: [
                              // Icon container with gradient background
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: widget.onTap == null
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
                                      color: (widget.onTap == null
                                              ? Colors.grey[500]!
                                              : const Color(0xffCDB054))
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: widget.isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        widget.icon,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                              ),

                              const SizedBox(width: 16),

                              // Title text with proper typography
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: widget.onTap == null
                                        ? Colors.grey[600]
                                        : const Color(0xFF1D1D1F),
                                  ),
                                ),
                              ),

                              // Chevron indicator with brand color accent
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: (widget.onTap == null
                                          ? Colors.grey[400]!
                                          : const Color(0xffF9C835))
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: widget.onTap == null
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
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
  /// Handles the display and result of the vocabulary level selection dialog.
  /// Logs the process for debugging and traceability.
  Future<void> _handleVocabularyLevelDialog(
    VocabularyLevel currentLevel,
  ) async {
    // Log the start of the dialog handling
    logger.d(
      '[Profile] Opening vocabulary level dialog. '
      'Current level: $currentLevel',
    );

    final cubit = context.read<ProfileCubit>();
    final selectedLevel =
        await _navigationService.showVocabularyLevelBottomSheet(
      context,
      currentLevel: currentLevel,
    );

    // Always reset dialog state after interaction to allow reopening
    if (mounted) {
      cubit.resetDialogState();
    }

    // Log the result of the dialog
    if (selectedLevel != null && mounted) {
      logger.i('[Profile] User selected new vocabulary level: $selectedLevel');
      await cubit.updateVocabularyLevel(selectedLevel);
    } else {
      logger.d('[Profile] Vocabulary level dialog dismissed or not mounted.');
    }
  }

  /// Handle success state by showing feedback and refreshing home screen
  void _handleVocabularyLevelUpdated(VocabularyLevel updatedLevel) {
    final l10n = context.l10n;
    final levelConfig = VocabularyLevels.getByLevel(updatedLevel);

    // Show success feedback to user
    _navigationService
      ..showSuccessSnackBar(
        context,
        message: l10n.vocabularyLevelUpdated(levelConfig.displayName),
      )

      // Refresh home screen to load words for the new vocabulary level
      // This ensures users immediately see words appropriate to their new level
      ..refreshHomeScreen(context);
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
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
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
              l10n.somethingWentWrong,
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
              text: l10n.retry,
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
        Text(
          l10n.quickActions,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
          ),
        ).animate().fadeIn(
              duration: 250.milliseconds,
              delay: 150.milliseconds,
            ),
        const SizedBox(height: 16),

        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: l10n.settingsNotifications,
          onTap: () {
            _navigationService.navigateToSettings(context);
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 200.milliseconds,
            ),

        ProfileMenuItem(
          icon: Icons.favorite,
          title: l10n.favoriteWords,
          onTap: () {
            _navigationService.navigateToFavorites(context);
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 250.milliseconds,
            ),

        ProfileMenuItem(
          icon: Icons.school,
          title: l10n.vocabularyLevel,
          onTap: isUpdating ? null : _onVocabularyLevelTap,
          isLoading: isUpdating,
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 300.milliseconds,
            ),

        const SizedBox(height: 24),

        // Support Section
        Text(
          l10n.supportAndInfo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
          ),
        ).animate().fadeIn(
              duration: 250.milliseconds,
              delay: 350.milliseconds,
            ),
        const SizedBox(height: 16),

        ProfileMenuItem(
          icon: Icons.star,
          title: l10n.reviewUs,
          onTap: () async {
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

        ProfileMenuItem(
          icon: Icons.copy,
          title: l10n.copyUserID,
          onTap: () async {
            final userId = UserRepository().getUserId();
            await Clipboard.setData(ClipboardData(text: userId));
            if (context.mounted) {
              _navigationService.showSuccessSnackBar(
                context,
                message: l10n.userIDCopied,
              );
            }
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 450.milliseconds,
            ),

        ProfileMenuItem(
          icon: Icons.support_agent,
          title: l10n.contactSupport,
          onTap: () {
            _launchURL('https://wordstockaiapp.com/contact');
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 500.milliseconds,
            ),

        const SizedBox(height: 24),

        // Legal Section
        Text(
          l10n.legal,
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

        ProfileMenuItem(
          icon: Icons.description,
          title: l10n.termsOfService,
          onTap: () {
            _launchURL('https://wordstockaiapp.com/terms-of-service');
          },
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 600.milliseconds,
            ),

        ProfileMenuItem(
          icon: Icons.privacy_tip,
          title: l10n.privacyPolicy,
          onTap: () {
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
}
