import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_header.dart';
import '../widgets/content_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.args});

  /// The name and email passed in through the route arguments.
  final HomeArgs args;

  String get _initials {
    final parts = args.fullName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: AppColors.accent),
        title: const Text('Log out?'),
        content: const Text(
          'You will need to log in again to come back to this screen.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // Closing a dialog is also a pop, with a result sent back.
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size(120, 44),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Replace Home with Login and pass a message for Login to show.
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
      arguments: 'You have been logged out.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = args.email.split('@').first;

    return Scaffold(
      body: OverlappingLayout(
        header: BrandHeader(
          trailing: IconButton(
            tooltip: 'Log out',
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.accent,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${args.fullName}!',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                args.isNewAccount
                    ? 'Your account is ready. Glad to have you here.'
                    : 'Good to see you again.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        children: [
          ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.account_circle_outlined,
                  title: 'Account details',
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Full name',
                  value: args.fullName,
                ),
                _InfoRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: args.email,
                ),
                _InfoRow(
                  icon: Icons.alternate_email_rounded,
                  label: 'Username',
                  value: username,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.route_outlined,
                  title: 'Your route here',
                ),
                const SizedBox(height: 4),
                const Text(
                  'The screens you passed through, by route name.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                _RouteTrail(
                  stops: args.isNewAccount
                      ? const [
                          ('Login', AppRoutes.login),
                          ('Sign Up', AppRoutes.signUp),
                          ('Home', AppRoutes.home),
                        ]
                      : const [
                          ('Login', AppRoutes.login),
                          ('Home', AppRoutes.home),
                        ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the route names the user passed through, joined by a line.
class _RouteTrail extends StatelessWidget {
  const _RouteTrail({required this.stops});

  /// Each stop is (screen title, route name).
  final List<(String, String)> stops;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < stops.length; i++) {
      final (title, routeName) = stops[i];
      final isCurrent = i == stops.length - 1;
      children.add(
        _RouteStop(title: title, routeName: routeName, isCurrent: isCurrent),
      );
      if (!isCurrent) {
        children.add(
          Expanded(
            child: Container(
              height: 2,
              // 15 = half the 32px circle, minus half the line's height.
              margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
        );
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _RouteStop extends StatelessWidget {
  const _RouteStop({
    required this.title,
    required this.routeName,
    required this.isCurrent,
  });

  final String title;
  final String routeName;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? AppColors.accent : AppColors.primary,
          ),
          child: Icon(
            isCurrent ? Icons.place_rounded : Icons.check_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          routeName,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
