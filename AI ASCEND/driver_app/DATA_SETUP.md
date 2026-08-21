# TrackGo Driver App — Firestore Data Setup Guide

This guide walks you through setting up your operational data in **Firebase Cloud Firestore** and **Firebase Authentication** so that the TrackGo Driver mobile application functions with real data.

---

## Architecture Overview

TrackGo enforces a strict UID-to-Profile document mapping:

```text
Firebase Authentication User (UID)
               │
               ▼
Cloud Firestore Document: drivers/{UID}
               │
       ┌───────┴────────────────────────┐
       ▼                                ▼
vehicles/{assignedBusId}        routes/{assignedRouteId}
       │                                │
       └───────────────┬────────────────┘
                       ▼
            trips (driverId == UID)
```

---

## Step 1: Create a Driver in Firebase Authentication

1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Select your project (**`trackgo-d8fc1`**).
3. In the left navigation, go to **Build > Authentication**.
4. In the **Users** tab, click **Add user**.
5. Enter:
   - **Email**: `driver1@gmail.com` (or any valid email)
   - **Password**: `password123` (or your chosen password)
6. Click **Add user**.
7. **Important**: Copy the generated **User UID** string (for example: `Wb9kL42xXqP81jM...`). You will use this exact string as the document ID in Step 2.

---

## Step 2: Create the Driver Document in Firestore

1. In the Firebase Console, navigate to **Build > Firestore Database**.
2. Click **Start collection** (or click **+ Add collection** if collections already exist).
3. **Collection ID**: `drivers`
4. **Document ID**: Paste the **User UID** copied from Step 1.
5. Add the following fields:

| Field Name | Type | Sample Value | Description |
| :--- | :--- | :--- | :--- |
| `driverId` | string | `DRV-1024` | Public operational driver code |
| `authUid` | string | *(Paste UID)* | Firebase Auth UID |
| `name` | string | `Karthikeyan S` | Driver's full name |
| `email` | string | `driver1@gmail.com` | Driver's email |
| `phone` | string | `+91 98421 78940` | Driver's contact number |
| `region` | string | `Villupuram Region` | Operating transport division |
| `rating` | number | `4.94` | Driver safety rating |
| `experienceYears` | number | `7` | Years of service |
| `status` | string | `available` | `available` \| `on_duty` \| `on_trip` \| `on_break` \| `offline` |
| `depotId` | string | `DEPOT-VPM-01` | Assigned depot reference |
| `assignedDepot` | string | `Villupuram Central Depot (Division 1)` | Depot display label |
| `assignedBusId` | string | `BUS-402` | Reference to vehicle document |
| `assignedRouteId` | string | `VPM-101` | Reference to route document |
| `licenseNumber` | string | `TN-32-2015-0048291` | Commercial Driver License (CDL) |
| `licenseCategory` | string | `Commercial HMV` | License class |
| `licenseValidUntil`| string | `Oct 2030 (Active)` | Expiration date string |
| `medicalCertificate`| string | `Class 1 (Valid thru Oct 2027)` | Medical certificate status |
| `authorizedVehicleClass` | string | `PSV Heavy Passenger Transit` | Authorized vehicle endorsement |

6. Click **Save**.

---

## Step 3: Create Supporting Collections

### Collection: `vehicles`
Click **+ Add collection** > Collection ID: `vehicles`.

**Document ID**: `BUS-402`
- `vehicleId` (string): `BUS-402`
- `vehicleCode` (string): `BUS-402`
- `registrationNumber` (string): `TN-32-AB-4521`
- `model` (string): `Ashok Leyland Viking Ultra BS-VI`
- `vehicleType` (string): `PSV Heavy Passenger Transit`
- `capacity` (number): `68`
- `seatingCapacity` (number): `48`
- `standingCapacity` (number): `20`
- `fuelPercent` (number): `92`
- `fuelOrBatteryStatus` (string): `92% Fuel Level`
- `status` (string): `assigned`
- `depotId` (string): `DEPOT-VPM-01`
- `assignedDepot` (string): `Villupuram Central Depot (Division 1)`
- `emissionClass` (string): `BS-VI Heavy Duty Diesel`
- `fitnessCertificateExpiry` (string): `Nov 2028 (Valid)`
- `lastInspectionDate` (string): `Today, 05:45 AM (Passed)`

---

### Collection: `depots`
Click **+ Add collection** > Collection ID: `depots`.

**Document ID**: `DEPOT-VPM-01`
- `depotId` (string): `DEPOT-VPM-01`
- `name` (string): `Villupuram Central Depot`
- `district` (string): `Villupuram`
- `division` (string): `Division 1`
- `state` (string): `Tamil Nadu`

---

### Collection: `routes`
Click **+ Add collection** > Collection ID: `routes`.

**Document ID**: `VPM-101`
- `routeId` (string): `VPM-101`
- `routeCode` (string): `VPM-101`
- `name` (string): `Villupuram New Bus Stand ↔ Cuddalore Bus Stand`
- `routeName` (string): `Villupuram New Bus Stand ↔ Cuddalore Bus Stand`
- `origin` (string): `Villupuram New Bus Stand`
- `destination` (string): `Cuddalore Bus Stand`
- `districts` (array): `["Villupuram", "Cuddalore"]`
- `state` (string): `Tamil Nadu`
- `distanceKm` (number): `46.5`
- `totalStopsCount` (number): `8`
- `active` (boolean): `true`
- `status` (string): `active`
- `colorHex` (string): `#0284C7`
- `estimatedDurationMinutes` (number): `93`
- `viaMajorStops` (string): `Valavanur, Panruti, Nellikuppam`
- `operatingRegion` (string): `Villupuram – Cuddalore Coastal Belt`
- `stops` (array of maps):
  1. `{"id": "STP-01", "sequenceNumber": 1, "stopName": "Villupuram New Bus Stand", "scheduledTime": "08:15 AM", "isTerminal": true}`
  2. `{"id": "STP-02", "sequenceNumber": 2, "stopName": "Villupuram Collectorate", "scheduledTime": "08:23 AM", "isTerminal": false}`
  3. `{"id": "STP-03", "sequenceNumber": 3, "stopName": "Valavanur Bus Stop", "scheduledTime": "08:37 AM", "isTerminal": false}`
  4. `{"id": "STP-04", "sequenceNumber": 4, "stopName": "Siruvandhadu Junction", "scheduledTime": "08:52 AM", "isTerminal": false}`
  5. `{"id": "STP-05", "sequenceNumber": 5, "stopName": "Panruti Main Bus Terminal", "scheduledTime": "09:08 AM", "isTerminal": false}`
  6. `{"id": "STP-06", "sequenceNumber": 6, "stopName": "Nellikuppam Town Stop", "scheduledTime": "09:24 AM", "isTerminal": false}`
  7. `{"id": "STP-07", "sequenceNumber": 7, "stopName": "Cuddalore Old Town (OT)", "scheduledTime": "09:39 AM", "isTerminal": false}`
  8. `{"id": "STP-08", "sequenceNumber": 8, "stopName": "Cuddalore Central Bus Stand", "scheduledTime": "09:48 AM", "isTerminal": true}`

---

### Collection: `trips`
Click **+ Add collection** > Collection ID: `trips`.

**Document ID**: `TRIP-VPM101-001`
- `tripId` (string): `TRIP-VPM101-001`
- `tripCode` (string): `TRIP-VPM101-001`
- `driverId` (string): *(Paste the Driver User UID from Step 1)*
- `vehicleId` (string): `BUS-402`
- `routeId` (string): `VPM-101`
- `origin` (string): `Villupuram New Bus Stand`
- `destination` (string): `Cuddalore Bus Stand`
- `scheduledDeparture` (string): `08:15 AM`
- `scheduledArrival` (string): `09:48 AM`
- `date` (string): `Today`
- `status` (string): `ready` (or `scheduled` / `in_progress` / `completed`)
- `stopCount` (number): `8`
- `distanceKm` (number): `46.5`
- `passengerCountEstimate` (number): `54`
- `notes` (string): `Peak morning commuter trip via Panruti.`

**Document ID**: `TRIP-VPM101-002`
- `tripId` (string): `TRIP-VPM101-002`
- `tripCode` (string): `TRIP-VPM101-002`
- `driverId` (string): *(Paste the Driver User UID from Step 1)*
- `vehicleId` (string): `BUS-402`
- `routeId` (string): `VPM-101`
- `origin` (string): `Cuddalore Bus Stand`
- `destination` (string): `Villupuram New Bus Stand`
- `scheduledDeparture` (string): `10:30 AM`
- `scheduledArrival` (string): `12:05 PM`
- `date` (string): `Today`
- `status` (string): `scheduled`
- `stopCount` (number): `8`
- `distanceKm` (number): `46.5`
- `passengerCountEstimate` (number): `48`

---

### Collection: `notifications`
Click **+ Add collection** > Collection ID: `notifications`.

**Document ID**: `NOTIF-001`
- `notificationId` (string): `NOTIF-001`
- `driverId` (string): *(Paste the Driver User UID from Step 1)*
- `title` (string): `Shift Assignment Confirmed`
- `message` (string): `Assigned to Route VPM-101 with Bus TN-32-AB-4521 (BUS-402) for today.`
- `type` (string): `assignment`
- `read` (boolean): `false`
- `createdAt` (timestamp): *(Use Current Timestamp)*

**Document ID**: `NOTIF-002`
- `notificationId` (string): `NOTIF-002`
- `driverId` (string): *(Paste the Driver User UID from Step 1)*
- `title` (string): `NH-45 Road Diversion Advisory`
- `message` (string): `Slow traffic near Panruti Overbridge due to road maintenance.`
- `type` (string): `route_alert`
- `read` (boolean): `false`
- `createdAt` (timestamp): *(Use Current Timestamp)*

---

## Step 4: Realtime Database (Live GPS Tracking)

When a driver starts a trip in the app, live location updates stream to:
`liveLocations/{tripId}`

Data structure:
```json
{
  "latitude": 11.9401,
  "longitude": 79.4861,
  "heading": 92.4,
  "speed": 42.5,
  "timestamp": 1729758000000,
  "tripId": "TRIP-VPM101-001",
  "vehicleId": "BUS-402",
  "driverId": "UID_FROM_AUTH"
}
```

---

## Summary Checklist

- [x] User created in Firebase Auth (`driver1@gmail.com`)
- [x] Document created in Firestore `drivers/{UID}` with document ID = User UID
- [x] Vehicle `vehicles/BUS-402` created
- [x] Depot `depots/DEPOT-VPM-01` created
- [x] Route `routes/VPM-101` created
- [x] Trips in `trips` created with `driverId` = User UID
- [x] Notifications in `notifications` created with `driverId` = User UID
- [x] Log in to TrackGo Driver Mobile App using `driver1@gmail.com` and password!
