# SR Classic Transport App

## Overview

SR Classic Transport is a cross‑platform Flutter application that helps users track shipments and manage bookings. The app provides a quick luggage tracking tool, a simple booking page, a history of previously tracked items, and contact information for the company. It also offers multilingual support and dark/light theme preferences.

### Main Features

- Tracking screen to check cargo status by phone number and tracking code
- Booking screen to schedule new shipments
- History tab that stores previously searched shipments
- Contact page with company phone numbers and locations
- Settings page for theme selection and language changes
- Onboarding flow allowing language selection on first launch

## Setup

1. Install the Flutter SDK following the [official installation guide](https://docs.flutter.dev/get-started/install).
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on a connected device or simulator:
   ```bash
   flutter run
   ```
4. Build a release APK for Android:
   ```bash
   flutter build apk --release
   ```
   The generated APK will be located under `build/app/outputs/flutter-apk/`.

## Supported Platforms

The project contains configurations for **Android**, **iOS**, **Web**, **Windows**, **macOS**, and **Linux**. You can run the application on any of these platforms as long as Flutter is properly configured for the target device.

## Running Tests

Unit and widget tests can be executed with:
```bash
flutter test
```
