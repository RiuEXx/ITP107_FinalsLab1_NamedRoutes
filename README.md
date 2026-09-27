# Waypoint — ITP107 Finals Laboratory 1

**Routes and Navigation in Flutter: Login → Sign-Up → Home**

ITP107 – Mobile Application Development · Section 3-ITA · Group 15 · Sir Albert Alforja

A three-screen Flutter app where every screen is a named route. The name entered
on the Sign-Up screen is passed to the Home screen as a route argument, and the
app uses four different `Navigator` methods to move between screens.

## Group 15 members and roles

| Member | Role |
| --- | --- |
| Cosme, Liuri Lien P. | Navigation & Routing Lead |
| Baculinao, Mark Joseph | UI/UX Designer |
| Del Rosario, Mikaela Denisse | Integration & Testing Lead |

## Screenshots

Full flow: Login → Sign-Up → Home → Logout → Login, then logging back in.

<p align="center">
  <img src="screenshots/01_login.png" width="200" alt="Login screen">
  <img src="screenshots/02_signup_filled.png" width="200" alt="Sign-Up screen, filled in">
  <img src="screenshots/03_home_after_signup.png" width="200" alt="Home screen after signing up">
  <img src="screenshots/04_logout_confirm.png" width="200" alt="Logout confirmation">
</p>
<p align="center">
  <img src="screenshots/05_login_after_logout.png" width="200" alt="Back on Login after logging out">
  <img src="screenshots/06_login_filled.png" width="200" alt="Logging in with the new account">
  <img src="screenshots/07_home_after_login.png" width="200" alt="Home screen after logging in">
</p>

## Named routes

All routes are defined in [`lib/routes/app_routes.dart`](lib/routes/app_routes.dart)
and registered in `MaterialApp` through `onGenerateRoute`.

| Route name | Screen | Arguments |
| --- | --- | --- |
| `/login` | `LoginScreen` (initial route) | Optional `String` message, e.g. "You have been logged out." |
| `/signup` | `SignUpScreen` | None |
| `/home` | `HomeScreen` | `HomeArgs` (full name, email, and whether the user just signed up) |

Opening `/home` without `HomeArgs` redirects to Login, and any unknown route
name falls back to Login through `onUnknownRoute`. Every route uses the same
fade-and-slide transition.

## Navigator methods used

| Method | Where | Why |
| --- | --- | --- |
| `Navigator.pushNamed` | Login → Sign Up link | Sign-Up opens on top of Login, so it can go back |
| `Navigator.pop` | Sign-Up → "Log In" link and back arrow; closing the logout dialog | Returns to the screen underneath |
| `Navigator.pushNamedAndRemoveUntil` | Sign-Up → Home | Clears Login and Sign-Up from the stack and passes the entered name to Home |
| `Navigator.pushReplacementNamed` | Login → Home, and Home → Login on Logout | Replaces the current screen, so Back cannot return to it |

## Features

- **Login:** email or username field and a password field with a show/hide button.
  Checks the details against the accounts created on the Sign-Up screen.
- **Sign-Up:** full name, email, password and confirm password, with validation
  (valid email, at least 6 characters, passwords must match, no duplicate emails).
- **Home:** "Welcome, *name*!" built from the route arguments, the account's details,
  the route names the user passed through, and a Logout button that asks for
  confirmation first.
- One shared theme (`lib/theme/`): teal and coral colours and the bundled Poppins
  font on all three screens.

Accounts are kept in memory only (there is no backend in this lab), so they are
cleared when the app restarts. Sign up first, then you can log in with the email
or the username (the part of the email before the `@`).

## Project structure

```
lib/
├── main.dart                   MaterialApp: theme, initial route, onGenerateRoute
├── routes/app_routes.dart      Route names, HomeArgs, route builder, transition
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── home_screen.dart
├── data/account_store.dart     In-memory accounts created on Sign-Up
├── theme/
│   ├── app_colors.dart         Colour palette
│   └── app_theme.dart          ThemeData shared by every screen
└── widgets/                    Header, card, text field and link shared by the screens
assets/fonts/                   Poppins (SIL Open Font License)
test/widget_test.dart           Navigation and validation tests
```

## How to run

```bash
flutter pub get
flutter run
```

Runs on an Android emulator or device, or in Chrome (`flutter run -d chrome`).

## Tests

```bash
flutter test
```

The widget tests cover the full navigation flow (Sign-Up → Home → Logout → Login),
the name reaching Home through the route arguments, logging in with a created
account, and the form validation on both screens.
