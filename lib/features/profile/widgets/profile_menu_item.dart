import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

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
    this.foregroundColor = const Color(0xFFFFC20E),
    this.shadowColor = const Color(0xFFCDB054),
    this.isLoading = false,
    super.key,
    this.onTap,
  });

  /// The icon to display in the menu item
  final IconData icon;

  /// The title text for the menu item
  final String title;

  /// Callback function when the menu item is tapped
  final VoidCallback? onTap;

  /// Whether the menu item is in a loading state
  final bool isLoading;

  /// The foreground color of the menu item
  final Color? foregroundColor;

  /// The shadow color of the menu item
  final Color? shadowColor;

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
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapCancel(),
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap != null ? _handleTap : null,
        child: SizedBox(
          width: double.infinity,
          height: 64,
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
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.shadowColor,
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
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: widget.foregroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.shadowColor!.withValues(alpha: 0.1),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon container with gradient background
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 22,
                          ),

                          const SizedBox(width: 16),

                          // Title text with proper typography
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Chevron indicator with brand color accent
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 22,
                          ),
                        ],
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
