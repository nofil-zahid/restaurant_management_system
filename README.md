# Restaurant Management App

A comprehensive Restaurant Management System built using Flutter and Firebase, designed to streamline the operations of a restaurant, including managing orders, reservations, inventory, and customer interactions.

## Features

- **Order Management**: Create, update, and track orders efficiently.
- **Reservation System**: Manage table reservations with ease.
- **Inventory Management**: Keep track of stock levels and manage supplies.
- **Customer Management**: Maintain customer profiles and interaction history.
- **Analytics Dashboard**: Visualize key metrics and performance indicators.
- **Multi-Platform**: Available on both Android and iOS platforms.

## Technologies Used

- **Flutter**: The UI toolkit for building natively compiled applications for mobile from a single codebase.
- **Firebase**:
  - **Cloud Firestore**: Store and sync app data in real-time.
  - **Firebase Storage**: Store user-generated content such as images.
  - **Firebase Analytics**: Track user behavior and app usage.

## Folder Structure

```plaintext
lib
│   firebase_options.dart
│   main.dart
│
├───classes
│       menu_item.dart
│       route.dart
│
├───database
│       firestore_services.dart
│
├───model
│       customer_model.dart
│       food_menu_model.dart
│       order_placement_model.dart
│       role_model.dart
│       table_model.dart
│       user_model.dart
│
├───routes
│       footer_routes.dart
│       routes.dart
│       sidebar_routes.dart
│
├───screen
│   │   Home.dart
│   │   LoadingPage.dart
│   │   Login.dart
│   │   Logout.dart
│   │   Register.dart
│   │
│   ├───Manager
│   │       emp_register.dart
│   │       emp_work.dart
│   │       food.dart
│   │       manager.dart
│   │       stats.dart
│   │
│   └───Waiter
│           bill.dart
│           order_manage.dart
│           table_manage.dart
│           waiter.dart
│
├───services
│       SharedPref_Helper.dart
│
├───utils
└───widgets
        drawer.dart
        footer.dart
        table_grid.dart
```
