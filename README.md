# MyFinance - Personal Finance Tracker

## 📌 Overview
**MyFinance** is a Flutter-based personal finance tracker that helps users manage their income and expenses effectively. Users can add transactions, categorize them, view financial history, and generate basic reports. The app also includes authentication, data synchronization, and notifications for due payments.

<p align="center">
  <img src="https://github.com/Shashank-grd/My_Finance/blob/main/screenshots/finance.png" alt="example1" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/Shashank-grd/My_Finance/blob/main/screenshots/finance1.png" alt="example2" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

</p>

  <!-- Add space between rows -->
<br><br>

<p align="center">
  <img src="https://github.com/Shashank-grd/My_Finance/blob/main/screenshots/finance2.png" alt="example4" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/Shashank-grd/My_Finance/blob/main/screenshots/finance3.png" alt="example5" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>


## ✨ Features
### 🔹 Transaction Management
- Add new transactions with fields: **Title, Amount, Type (Income/Expense), Category, Date**.
- Edit or delete existing transactions.
- View transaction history with filtering options.

### 🔹 Category Management
- Create, edit, and delete custom categories (e.g., Groceries, Rent, Salary, Entertainment).

### 🔹 Financial Dashboard
- Displays **Total Income, Total Expenses, and Net Balance**.
- A chart showing spending per category.

### 🔹 Data Persistence
- Ensures that data is preserved when the app is closed and reopened.

### 🔹 Authentication & Data Sync
- User authentication for secure access.
- Cloud sync to keep financial data updated across devices.

### 🔹 Notifications & Reminders
- Sends notifications for due payments and recurring expenses.

## 🛠 Tech Stack
- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod / Provider
- **Database:** Firebase Firestore / SQLite (for offline support)
- **Authentication:** Firebase Authentication
- **Charting Library:** fl_chart
- **Notifications:** Flutter Local Notifications / Firebase Cloud Messaging

## 🚀 Getting Started
### Prerequisites
- Flutter SDK installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Firebase project setup (for authentication & Firestore integration)

### 🔧 Installation Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/myfinance.git
   cd myfinance
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Setup Firebase:
    - Create a Firebase project.
    - Enable **Firestore**, **Authentication**, and **Cloud Messaging**.
    - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective directories.
4. Run the app:
   ```sh
   flutter run
   ```


💡 **Developed by:** Shashank Kumar Sinha

