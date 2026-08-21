# TrackGo Driver Mobile App (Phase 1: Foundation & UI Architecture)

TrackGo is a real-time public transit tracking ecosystem composed of Driver Mobile Apps, Passenger Mobile Apps, Dispatcher/Admin Web Portals, and real-time transit synchronization services.

This repository contains the **Flutter Driver Mobile Application (Phase 1)**.

---

## 🚌 Phase 1 Overview

Phase 1 establishes a production-grade, extensible UI architecture and mock data layer for the Driver Mobile App.

### Completed Features

1. **Splash Screen**: Brand logo treatment, dynamic session check, and smooth navigation transition.
2. **Authentication Flow**:
   - Mock Driver login with form validation, error handling, password visibility toggle, and test credential auto-fill helper.
   - Mock Forgot Password recovery flow with input validation and feedback dialogs.
3. **App Shell Navigation**:
   - Persistent 4-tab bottom navigation (`Home`, `Trips`, `Notifications`, `Profile`) with unread badge counter.
4. **Driver Dashboard (Home)**:
   - Dynamic time-based greeting (`Good morning / afternoon / evening`) with driver status toggle (`Available`, `On Duty`, `On Break`).
   - Shift performance metrics (Trips completed, On-time punctuality rate, Driving hours).
   - Today's Assignment Card (Assigned vehicle, route number & name, battery/fuel status, shift timing).
   - Next Upcoming Trip Card with route origin/destination and direct manifest action.
   - Quick Action tiles to jump to trips, notifications, profile, or contact dispatch.
5. **Trips Management**:
   - Filterable trip list (`All`, `Scheduled`, `Completed`, `Cancelled`).
   - Comprehensive Trip Cards displaying vehicle code, distance, stop count, and status badges.
   - **Trip Manifest & Detail Screen**: Itinerary timeline of planned route stops with sequence numbers, terminal badges, landmarks, vehicle specs, and Phase 1 placeholder actions.
6. **Notifications System**:
   - Driver bulletins and alerts categorized by type (`Assignment`, `Route Detour`, `Maintenance Diagnostics`, `Safety Announcement`, `Shift Log`).
   - Filter by `All` vs `Unread`.
   - "Mark as read" interaction on tap, and "Mark all as read" top action.
7. **Driver Profile**:
   - Driver credentials, rating, experience badge, CDL license number, expiry, assigned depot, and vehicle authorization class.
   - Application & system info.
   - Sign Out flow with confirmation modal that resets mock session state and redirects to Login.

---

## 🔑 Phase 1 Test Credentials

For testing and demonstration, use the following pre-configured driver account:

* **Email / ID**: `driver@trackgo.com` (or `driver123`)
* **Password**: `password123`

*(Note: The Login screen includes a convenient **"Auto-fill Test Account"** button)*.

---

## 🏗️ Project Architecture & Folder Structure

The project follows a **Feature-First Clean Architecture** with strict separation of concerns:

```text
lib/
├── app/
│   ├── app.dart                   # MultiProvider dependency injection root & MaterialApp
│   ├── presentation/
│   │   └── main_shell_screen.dart # Persistent 4-tab Bottom Navigation Shell
│   └── router/
│       └── app_router.dart        # Centralized route generator
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart        # Transit blue, emerald, amber, and slate color tokens
│   │   ├── app_radius.dart        # Standard border radii tokens
│   │   ├── app_spacing.dart       # 8pt/4pt responsive grid system
│   │   ├── app_typography.dart    # Plus Jakarta Sans / Inter typography hierarchy
│   │   └── app_theme.dart         # Material 3 ThemeData definition
│   └── widgets/                   # Reusable UI components
│       ├── driver_avatar.dart
│       ├── empty_state_view.dart
│       ├── error_state_view.dart
│       ├── loading_state_view.dart
│       ├── section_header.dart
│       ├── status_badge.dart
│       ├── trackgo_button.dart
│       ├── trackgo_card.dart
│       └── trackgo_text_field.dart
│
└── features/
    ├── authentication/
    │   ├── data/                  # MockAuthDataSource, MockAuthRepository
    │   ├── domain/                # DriverUser entity, AuthRepository interface
    │   └── presentation/          # AuthController, SplashScreen, LoginScreen, ForgotPasswordScreen
    │
    ├── home/
    │   ├── data/                  # MockDriverDataSource, MockDriverRepository
    │   ├── domain/                # DriverAssignment, DriverMetrics, DriverRepository interface
    │   └── presentation/          # HomeController, HomeScreen
    │
    ├── trips/
    │   ├── data/                  # MockTripDataSource, MockTripRepository
    │   ├── domain/                # Trip, TransitRoute, Vehicle, TripStop, TripRepository interface
    │   └── presentation/          # TripsController, TripsScreen, TripDetailScreen
    │
    ├── notifications/
    │   ├── data/                  # MockNotificationDataSource, MockNotificationRepository
    │   ├── domain/                # DriverNotification, NotificationRepository interface
    │   └── presentation/          # NotificationsController, NotificationsScreen
    │
    └── profile/
        └── presentation/          # ProfileScreen
```

---

## 🔄 State Management

The application utilizes **Provider** (`ChangeNotifier` / `ValueNotifier` controllers) with dependency injection at the root level (`lib/app/app.dart`).

Each controller is isolated to its feature domain:
- `AuthController`: Manages session status, current driver profile, login/logout, and error states.
- `HomeController`: Manages today's assignment, metrics, and duty availability.
- `TripsController`: Manages trip filtering, upcoming trip detection, and individual trip details.
- `NotificationsController`: Manages unread badge counters and notification read states.

---

## 🔌 Future Backend Integration (Phase 2+)

All feature domains interface solely through abstract repository contracts:
- `AuthRepository`
- `DriverRepository`
- `TripRepository`
- `NotificationRepository`

To connect to a live backend in later phases, implement remote repositories:
```text
TripRepository (Abstract Contract)
       │
       ├── MockTripRepository (Phase 1 - In Memory)
       └── RemoteTripRepository (Phase 2 - REST API / WebSocket Stream)
```

No UI widgets depend on mock data sources directly.

---

## 🚫 Phase 1 Scope Boundaries & Limitations

The following capabilities are intentionally deferred to future phases:
- **Phase 2**: Real-time GPS location streaming, live turn-by-turn map navigation, live trip execution (`Start Trip` / `End Trip`), and stop arrival geo-fencing.
- **Phase 3**: Real-time passenger boardings sync, automated passenger counter (APC) telemetry, and WebSocket dispatch push alerts.
- **Phase 4**: Production Firebase authentication, offline cached route bundles, and biometric login.

---

## 🧪 Testing & Verification

Run the test suite:
```bash
flutter test
```

Run static analysis:
```bash
dart analyze .
# or
flutter analyze
```

---

## 🚀 Running the App

```bash
flutter pub get
flutter run
```
