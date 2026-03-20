#  OmniBook – Multi-Counter Service Booking System

##  Overview
OmniBook is a Flutter-based booking system for service businesses (salon/clinic/car wash) that manages appointments across multiple independent counters.

The application dynamically calculates time slot availability based on:
- Total duration of selected services
- Existing bookings across multiple counters

---

##  Features

-  Multi-service selection (basket system)
-  Real-time total duration & price calculation
-  Smart slot availability (multi-counter logic)
-  Dynamic slot disabling (based on duration)
-  Capacity indicators (e.g., "2 spots left")
-  Booking confirmation screen
-  Cancel bookings
-  Premium glassmorphism UI

---

##  Slot Availability Logic (Core)

A slot is considered **AVAILABLE** only if:

- At least **one counter is completely free**
- The **entire service duration fits continuously**
- The slot does **not exceed business closing time**

###  Overlap Formula:

(StartA < EndB) && (EndA > StartB)

###  Algorithm Steps:

1. Calculate total duration from selected services
2. For each time slot:
   - Compute end time = start + duration
   - Iterate through all counters (1–3)
   - Check overlap with existing bookings
3. If **any counter has zero overlap → slot is AVAILABLE**

---

##  Architecture

Project follows clean architecture principles:

lib/ ┣ models/        → Data models (Service, Booking) ┣ providers/     → State management (Provider) ┣ services/      → Business logic (SlotService) ┣ screens/       → UI screens ┣ widgets/       → Reusable components

---

##  Screens

- Service Selection Screen
- Time Slot Selection Screen
- Booking Summary Screen
- My Bookings Screen

---

##  Mock Data (Used for Testing)

- Counter 1 → 10:00 AM – 11:00 AM
- Counter 2 → 10:30 AM – 11:30 AM
- Counter 3 → 09:00 AM – 10:30 AM

✔ Verified test case:
- 60-min service at 10:00 AM →  Disabled (Correct)

---

##  Edge Cases Handled

-  Closing time overflow (no booking past 6 PM)
-  No splitting across counters
-  Real-time UI updates on service selection
-  Accurate overlap detection

---

##  Demo

 ( https://drive.google.com/file/d/1ypbjVdSGQaEb8XbR3SUoM7C0tGcqfh2x/view?usp=drivesdk )

---

##  How to Run

```bash
flutter pub get
flutter run

---

Tech Stack
Flutter (Material 3)
Provider (State Management)
Dart

---

## AI Usage

This project was developed with assistance from AI tools:
ChatGPT: Used for UI improvements, debugging, and architecture refinement
AI suggestions were reviewed and adapted manually
All core logic (multi-counter availability and overlap detection) was fully understood and implemented by me.
