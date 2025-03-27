# Pet Hotel Booking Web App

A Flutter web application for booking pet services and accommodations.

## Overview

This web application is a comprehensive booking platform that connects pet owners with hotels and service providers offering pet-friendly accommodations and care services. The application allows users to browse hotels, book rooms for their pets, manage reservations, and communicate with service providers.

> **Note:** This is a training webapp and not intended for production use.

## Features

- **User Authentication**: Secure login and registration system using Auth0 PKCE
- **Hotel Browsing**: Search and filter pet-friendly accommodations
- **Room Booking**: Interactive calendar with availability checking (work in progress)
- **Pet Profiles**: Manage multiple pet profiles with detailed information
- **Reservation Management**: View, modify, and cancel existing reservations
- **Messaging System**: Direct communication with service providers
- **Review System**: Submit and read reviews for hotels and services
- **Responsive Design**: Optimized for both mobile and web platforms

## Technology Stack

- **Frontend Framework**: Flutter
- **Authentication**: Auth0
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
