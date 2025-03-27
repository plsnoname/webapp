# Pet Hotel Booking Web App

A Flutter web application for booking pet services and accommodations.

## Overview

This web application is a comprehensive booking platform that connects pet owners with hotels and service providers offering pet-friendly accommodations and care services. The application allows users to browse hotels, book rooms for their pets, manage reservations, and communicate with service providers.

> **Note:** This is a training webapp and not intended for production use.

## Features

- **User Authentication**: Secure login and registration system using Auth0 PKCE (currently inactive)
- **Hotel Browsing**: Search and filter pet-friendly accommodations
- **Room Booking**: Interactive calendar with availability checking (work in progress)
- **Pet Profiles**: Manage multiple pet profiles with detailed information
- **Reservation Management**: View, modify, and cancel existing reservations
- **Messaging System**: Direct communication with service providers
- **Review System**: Submit and read reviews for hotels and services
- **Responsive Design**: Optimized for both mobile and web platforms

## Technology Stack

- **Frontend Framework**: Flutter
- **Authentication**: Auth0 (PKCE flow)
- **State Management**: Provider
- **Routing**: go_router
- **HTTP Client**: http

## Getting Started

### Prerequisites

- Flutter SDK (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)
- Web browser (Chrome recommended for development)
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/plsnoname/webapp.git
cd fertcher_app_client
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment variables:
   - Create a `.env` file in the root directory (use `.env.example` as a template)
   - Update Auth0 credentials and API endpoints

### Running the Application

1. Start the local server:
```bash
./start_server.sh
```

2. Access the application at:
```
http://localhost:8888
```

#### For Development

```bash
flutter run -d chrome
```

#### For Production Build

```bash
flutter build web
```

The built web app will be available in the `build/web` directory.

## Authentication Details

The application implements Auth0 authentication using the PKCE (Proof Key for Code Exchange) flow, but **this functionality is currently inactive**. If you want to use Auth0:

- You'll need to update the Auth0 variables in the `auth.dart` file with your own credentials
- The mobile implementation uses an in-app web view for authentication
- **Important:** There is no web-specific alternative implementation for authentication

### Using Login Guard

The application includes a LoginGuard component that can be used to restrict access to screens for unauthenticated users:

```dart
// Example of using LoginGuard to protect a screen
LoginGuard(
  child: YourProtectedScreen(),
)
```

Simply wrap any view or screen with the LoginGuard to ensure that only authenticated users can access it. Unauthenticated users will be redirected to the login page.

## Project Structure

```
lib/
├── components/             # Shared reusable components
├── design_system/          # Design system with colors, typography, spacing
├── features/               # Feature-specific modules
│   ├── authentication/     # Authentication screens and logic
│   ├── history/            # Reservation history
│   ├── home/               # Main screens and discovery
│   ├── hotel/              # Hotel details and room selection
│   ├── make_reservation/   # Reservation creation flow
│   ├── messaging/          # Messaging functionality
│   ├── profile/            # User profile management
│   ├── room_details/       # Room information
│   └── search/             # Search functionality
├── providers/              # Application state management
├── routes/                 # Routing configuration
├── screens/                # Various app screens
├── services/               # API services and business logic
├── shared/                 # Shared utilities and helpers
│   ├── utils/              # Utility functions
│   └── widgets/            # Common widgets
└── main.dart              # Application entry point
```

## Key Components

### Calendar Date Picker

The app includes a custom calendar date picker that is currently a work in progress:
- Supports date range selection
- Shows blocked/unavailable dates
- Validates date selections based on availability
- Offers a responsive UI for both mobile and web

> **Important:** The availability calendar functionality is not yet fully implemented and some features may not work as expected.

### Hotel Cards

Interactive cards display essential information about hotels:
- Images of facilities
- Pricing information
- Ratings and reviews
- Distance and location details

### Pet Profiles

Users can manage multiple pet profiles with detailed information:
- Pet type (dog, cat, etc.)
- Breed information
- Size and weight
- Medical requirements
- Feeding schedules

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Dependencies

Here's a list of all dependencies used in the project and their purpose:

### Core Dependencies

- **flutter**: The main framework for building the user interface
- **go_router (^14.8.1)**: Handles application routing with named routes and navigation
- **provider (^6.1.2)**: State management solution for sharing data across the widget tree
- **http (^1.3.0)**: Used for making HTTP requests to APIs

### Authentication & Security

- **auth0 (^2.2.1)**: Main Auth0 SDK for authentication functionality
- **auth0_flutter (^1.7.2)**: Flutter-specific Auth0 implementation
- **flutter_appauth (^8.0.3)**: OpenID Connect and OAuth2 implementation for mobile authentication
- **flutter_secure_storage (^9.0.2)**: Securely stores sensitive information like tokens
- **crypto (^3.0.6)**: Handles cryptographic operations for authentication

### UI Components & Utilities

- **cupertino_icons (^1.0.8)**: Provides iOS-style icons
- **intl (^0.20.2)**: Internationalization and date formatting utilities
- **flutter_inappwebview (^6.1.5)**: In-app browser for authentication flows

### Web & Platform Integration

- **url_launcher (^6.3.1)**: Opens URLs in the device browser
- **app_links (^6.0.0)**: Handles deep linking and app-to-app communication
- **universal_html (^2.2.4)**: HTML and DOM manipulation for web platform

### Development Dependencies

- **flutter_test**: Testing framework for Flutter applications
- **flutter_lints (^5.0.0)**: Provides linting rules for maintaining code quality
- **dart_code_metrics (^4.19.2)**: Advanced static analysis tool for measuring code metrics

## How Dependencies Are Used

- **Authentication Flow**: The app uses a combination of `auth0`, `auth0_flutter`, `flutter_appauth`, and `flutter_inappwebview` to implement the PKCE authentication flow. The `flutter_secure_storage` stores authentication tokens securely.

- **Navigation**: `go_router` handles application routing, including nested navigation, path parameters, and query parameters.

- **State Management**: `provider` is used throughout the app to manage and share state between components, particularly for user authentication and profile data.

- **Data Fetching**: `http` is used to fetch data from mock APIs (would connect to real APIs in production).

- **Date & Time Handling**: `intl` formats dates for reservations, booking calendars, and user interfaces.

- **Web Compatibility**: `universal_html` and `app_links` ensure proper functioning in web environments, while `url_launcher` manages external navigation.
