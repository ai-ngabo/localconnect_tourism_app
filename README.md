# Community Touring Rwanda 🇷🇼

A Flutter mobile app for discovering and booking authentic community tours in Rwanda.

## Screens

| Screen            | Description                                                      |
| ----------------- | ---------------------------------------------------------------- |
| **Splash**        | Welcome screen with "Get Started" and "Log In" buttons           |
| **Sign Up**       | Registration form with name, email, password, Google sign-in     |
| **Log In**        | Login form with email, password, forgot password, Google sign-in |
| **Home**          | Main screen with search, popular tours, local guides, bottom nav |
| **Tour Detail**   | Full tour info with description, duration, price, "Book Now"     |
| **Booking**       | Date picker, guest counter, total cost, special requests         |
| **Bookings List** | Upcoming (Confirmed) and Past (Completed) bookings               |
| **Profile**       | User info, My Tours, Favorites, Settings, Support, Log Out       |

## Navigation Flow

```
Splash → Sign Up ↔ Log In → Home
                              ├── Tour Detail → Booking → Confirmation
                              ├── Bookings List
                              └── Profile → Log Out → Splash
```

## Setup & Run

### Prerequisites

- Flutter SDK (3.0+)
- Android Studio / Xcode
- A connected device or emulator

### Steps

```bash
# 1. Navigate to project
cd community_touring_rwanda

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Create empty assets folder (required)

```bash
mkdir -p assets/images
touch assets/images/.gitkeep
```

## Project Structure

```
lib/
├── main.dart                    # App entry point, routes, theme
├── models/
│   └── tour_model.dart          # Tour, Guide, Booking models
└── screens/
    ├── splash_screen.dart       # Welcome/landing screen
    ├── signup_screen.dart       # Registration screen
    ├── login_screen.dart        # Login screen
    ├── home_screen.dart         # Main home with bottom nav
    ├── tour_detail_screen.dart  # Tour details page
    ├── booking_screen.dart      # Booking form
    ├── bookings_list_screen.dart# Upcoming & past bookings
    └── profile_screen.dart      # User profile & settings
```

## Features

- ✅ Full navigation between all screens
- ✅ Form validation on Sign Up & Log In
- ✅ Date picker for booking
- ✅ Guest counter with dynamic pricing
- ✅ Booking confirmation dialog
- ✅ Bottom navigation bar
- ✅ Logout with confirmation
- ✅ Green nature-themed UI matching the design
- ✅ Placeholder graphics (gradient + icons) — replace with real images

To add real images, place them in `assets/images/` and update the image references in the tour cards and detail screens to use `Image.asset()` instead of the gradient containers.
