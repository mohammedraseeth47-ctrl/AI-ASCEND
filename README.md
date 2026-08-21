# AI ASCEND

# TrackGo – Real-Time Public Transport Tracking System

## Overview

**TrackGo** is a real-time public transport tracking system designed to improve the public transportation experience by allowing passengers to view buses on a live map while enabling drivers to share their current location.

The system consists of two Flutter mobile applications:

* **Driver App** – Used by bus drivers to share their live GPS location and manage their assigned bus.
* **Passenger App** – Used by passengers to view available buses, routes, and real-time bus locations.

The applications use **Firebase** as the backend for authentication and real-time data synchronization.

---

## Project Structure

```text
AI ASCEND/
│
├── driver_app/
│   └── Driver Mobile Application
│
├── passenger_app/
│   └── Passenger Mobile Application
│
├── .gitignore
└── README.md
```

> Note: The final repository should contain only the actual submission versions of the Driver and Passenger applications.

---

## System Architecture

```text
                    ┌──────────────────────┐
                    │       Firebase       │
                    │                      │
                    │ Authentication       │
                    │ Realtime Database     │
                    │ Cloud Data Storage    │
                    └──────────┬───────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
                ▼                             ▼
      ┌──────────────────┐          ┌──────────────────┐
      │    Driver App    │          │   Passenger App  │
      │                  │          │                  │
      │ GPS Location     │          │ Live Bus Map     │
      │ Bus Assignment   │          │ Bus Tracking     │
      │ Driver Status     │          │ Route Information│
      └──────────────────┘          └──────────────────┘
```

---

## Key Features

### Driver Application

* Driver authentication
* Driver profile and account management
* Bus assignment
* GPS location tracking
* Real-time location updates
* Driver/bus status management
* Firebase-based synchronization

### Passenger Application

* Passenger authentication
* View available buses
* View bus routes
* Real-time bus location tracking
* Map-based bus visualization
* Route-based bus information
* Live tracking of buses

---

## Real-Time Tracking

The Driver App obtains the driver's current GPS coordinates from the mobile device.

The location information is periodically synchronized with Firebase.

The Passenger App listens for the latest bus location data and updates the map accordingly.

```text
Driver GPS
    │
    ▼
Driver App
    │
    ▼
Firebase
    │
    ▼
Passenger App
    │
    ▼
Live Bus Location on Map
```

This allows passengers to monitor the approximate real-time location of buses.

---

## Technology Stack

### Mobile Applications

* Flutter
* Dart
* Android SDK

### Backend

* Firebase Authentication
* Firebase Realtime Database / Firebase services

### Location

* Device GPS
* Flutter location/geolocation services

### Maps

* Map-based visualization for displaying buses and routes

### Development Tools

* Android Studio
* Visual Studio Code
* Git
* GitHub

---

## Applications

### 1. Driver App

The Driver App is responsible for:

1. Driver login/authentication
2. Receiving or managing bus assignments
3. Obtaining the driver's GPS location
4. Sending location information to Firebase
5. Updating the driver's/bus status
6. Maintaining real-time synchronization with the backend

### 2. Passenger App

The Passenger App is responsible for:

1. Passenger login/authentication
2. Displaying available buses
3. Displaying bus routes
4. Receiving real-time bus location data
5. Displaying buses on the map
6. Helping passengers identify and track their required bus

---

## Firebase Integration

Firebase acts as the communication layer between the two applications.

The Driver App writes the latest bus/location information to Firebase, while the Passenger App reads or listens to the corresponding data.

This eliminates the need for the Driver App and Passenger App to communicate directly with each other.

```text
Driver App
    │
    │ Location Update
    ▼
Firebase
    │
    │ Real-Time Data
    ▼
Passenger App
```

---

## Getting Started

### Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio
* Android SDK
* Git
* A Firebase project

Check Flutter installation:

```bash
flutter doctor
```

---

## Running the Driver App

Navigate to the Driver App directory:

```bash
cd driver_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Running the Passenger App

Navigate to the Passenger App directory:

```bash
cd passenger_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Firebase Configuration

Each application requires the appropriate Firebase configuration to connect to the project's Firebase backend.

Before running the applications, ensure that the required Firebase configuration files and Firebase project settings are correctly configured.

Do not commit private service-account credentials, private keys, passwords, or other sensitive secrets to the repository.

---

## Project Workflow

```text
                 DRIVER
                   │
                   ▼
          Driver Authentication
                   │
                   ▼
             Bus Assignment
                   │
                   ▼
             GPS Tracking
                   │
                   ▼
        Firebase Location Update
                   │
                   ▼
              ┌─────────┐
              │ Firebase│
              └────┬────┘
                   │
                   ▼
         Passenger Application
                   │
                   ▼
             Live Bus Map
                   │
                   ▼
          Passenger Tracking
```

---

## Future Enhancements

The system can be extended with:

* ETA prediction
* Push notifications
* Bus arrival notifications
* Route optimization
* Driver trip history
* Passenger feedback
* Admin dashboard
* Analytics and reporting
* Multiple transport operators
* Advanced geofencing
* Improved location prediction

---

## Team

**Team Name:** AI ASCEND

**Project:** TrackGo – Real-Time Public Transport Tracking System

---

## License

This project was developed as an academic/project submission.

© 2026 AI ASCEND. All rights reserved.
