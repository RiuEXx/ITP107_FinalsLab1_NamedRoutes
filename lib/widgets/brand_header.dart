import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// The app logo and name, shown at the top of every screen.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.explore_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Waypoint',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

/// The teal gradient header used by all three screens.
///
/// [leading] and [trailing] sit beside the logo. [child] sits at the bottom of
/// the header (or in its centre, with [centerChild]), so the header can grow
/// to fill a tall screen. The extra bottom padding leaves room for the card
/// that overlaps the header.
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.showBrandMark = true,
    this.centerChild = false,
  });

  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  /// Hide the small logo when [child] already shows a big one.
  final bool showBrandMark;

  /// Centre [child] in the header instead of pinning it to the bottom.
  final bool centerChild;

  static const double overlap = 48;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: Stack(
          children: [
            // A large, faint compass in the corner as decoration.
            Positioned(
              top: -30,
              right: -60,
              child: Icon(
                Icons.explore_outlined,
                size: 260,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, overlap + 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          if (leading != null) ...[
                            leading!,
                            const SizedBox(width: 4),
                          ],
                          if (showBrandMark) const BrandMark(),
                          const Spacer(),
                          ?trailing,
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Spacer(),
                    child,
                    if (centerChild) const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The big centred logo on the Login and Sign-Up headers.
class AuthHero extends StatelessWidget {
  const AuthHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: AppColors.primary,
              size: 46,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Waypoint',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Every screen, one clear path.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays out a screen as a header with content cards overlapping its bottom
/// edge, inside one scroll view.
///
/// On a tall screen the header stretches to fill the spare space. On a short
/// screen, or with the keyboard open, the whole page scrolls instead.
class OverlappingLayout extends StatelessWidget {
  const OverlappingLayout({
    super.key,
    required this.header,
    required this.children,
  });

  final BrandHeader header;
  final List<Widget> children;

  /// Light status bar icons over the dark header.
  static const _systemBars = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemBars,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(child: header),
                  Transform.translate(
                    offset: const Offset(0, -BrandHeader.overlap),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: children),
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
