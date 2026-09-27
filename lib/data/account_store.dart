/// A user created on the Sign-Up screen.
class Account {
  const Account({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  /// The part of the email before the "@", so users can log in with either.
  String get username => email.split('@').first;
}

/// Keeps the accounts created while the app is running.
///
/// There is no backend in this lab, so accounts live in memory and are
/// cleared when the app restarts.
class AccountStore {
  AccountStore._();

  static final List<Account> _accounts = [];

  static bool isEmailTaken(String email) => _findByEmail(email) != null;

  static void register(Account account) => _accounts.add(account);

  /// Finds an account by its email or its username (case-insensitive).
  static Account? find(String emailOrUsername) {
    final key = emailOrUsername.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.email.toLowerCase() == key ||
          account.username.toLowerCase() == key) {
        return account;
      }
    }
    return null;
  }

  static Account? _findByEmail(String email) {
    final key = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.email.toLowerCase() == key) return account;
    }
    return null;
  }
}
