# 1999 wala (UPI SplitPay)

A modern, fintech-style Flutter application prototype that takes any total payment amount, automatically splits it into manageable payment portions of **₹1,999**, and generates a separate UPI QR code for each portion. 

Because why pay 1.1% UPI MDR charges on wallet transactions above ₹2,000 when you can just write a `while(amount > 2000)` loop? 🤷‍♂️

## 🚀 Features

- **Automatic Amount Splitting**: Instantly splits any large amount into exact ₹1,999 chunks (with the remainder dynamically calculated).
- **Dynamic QR Code Generation**: Uses `qr_flutter` to generate highly accurate UPI URIs that can be scanned by any UPI app (GPay, PhonePe, Paytm).
- **Auto-Fill Transaction Notes**: Add an optional reason for the payment (e.g., "Dinner"), and the app will append chunk indexes (e.g., `Dinner (1/3)`) and pass it via the `tn` parameter directly to the UPI app.
- **Payee Identification**: Add a name to the payee, which is also embedded in the UPI URI.
- **Direct UPI Launching**: One-tap button to directly open compatible UPI apps installed on the device.
- **Shareable QR Codes**: Take high-quality captures of the QR code using the `screenshot` package and share them immediately via `share_plus`.
- **Modern Fintech UI**: Built entirely with Flutter and Material 3 design principles for a premium feel.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Architecture**: Clean UI separation with scoped models and utility classes.
- **Packages Used**:
  - `qr_flutter`: For rendering the UPI URIs into visual QR codes.
  - `url_launcher`: For deep-linking into native UPI applications.
  - `share_plus`: For sharing generated QR images and plan summaries.
  - `screenshot`: For capturing QR UI elements as shareable image files.
  - `path_provider`: For temporary file storage during sharing.
  - `intl`: For Indian Rupee (₹) currency formatting.

## 📱 Screenshots & Demo

*(Add your screenshots or Loom video link here!)*

## 💻 How to Run

1. Make sure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/1999-wala.git
   ```
3. Navigate to the project directory:
   ```bash
   cd 1999-wala
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app (Web recommended for quick testing, Android/iOS for full UPI launch support):
   ```bash
   flutter run -d chrome
   ```

## 🔒 Security & Privacy

This application is a **frontend prototype** meant for demonstration purposes. It does **not**:
- Contain a backend or database.
- Store or request UPI PINs, OTPs, or bank passwords.
- Verify whether the payment was actually successful.
It simply generates mathematically accurate UPI intent URIs based on user input.

---
*Built with ❤️ (and a little bit of spite for transaction fees).*
