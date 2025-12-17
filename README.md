# ICS Calendar Sync

A Flutter application for subscribing to ICS calendar links and adding events to your device calendar.

## Features

- 📅 Subscribe to any ICS calendar link
- 🔄 Fetch and parse ICS calendar events
- 📲 Add events to any calendar app on your device
- 🌐 Works on Android, iOS, and Web
- 🚀 Automated APK builds and releases
- 🌍 Web app deployed on GitHub Pages

## How to Use

1. Enter or paste your ICS calendar subscription link
2. Tap the "Add to Calendar" button
3. Select your preferred calendar app
4. Events will be added to your device calendar

## Example ICS Links

You can test the app with these public ICS calendar links:
- US Holidays: `https://calendar.google.com/calendar/ical/en.usa%23holiday%40group.v.calendar.google.com/public/basic.ics`
- Your own Google Calendar public ICS link
- Any other ICS calendar subscription link

## Installation

### Android
Download the latest APK from the [Releases](https://github.com/Asion001/Ics-sync-example/releases) page.

### Web
Visit the live web app: [https://asion001.github.io/Ics-sync-example/](https://asion001.github.io/Ics-sync-example/)

## Building from Source

### Prerequisites
- Flutter SDK (3.24.0 or higher)
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)

### Steps

1. Clone the repository:
```bash
git clone https://github.com/Asion001/Ics-sync-example.git
cd Ics-sync-example
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

4. Build for specific platform:
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## GitHub Actions

This project includes automated workflows for:

### APK Build and Release
- Automatically builds APK on push to main branch
- Creates GitHub releases with APK artifact
- Trigger: Push to main, Pull requests, Manual dispatch

### Web Deployment
- Builds and deploys web app to GitHub Pages
- Accessible at: https://asion001.github.io/Ics-sync-example/
- Trigger: Push to main, Pull requests, Manual dispatch

## Permissions

### Android
- `INTERNET` - To fetch ICS calendar data from URLs
- `READ_CALENDAR` - To read calendar data
- `WRITE_CALENDAR` - To add events to calendar

### iOS
- `NSCalendarsUsageDescription` - To access and add events to calendar

## Dependencies

- `http` - For fetching ICS calendar data
- `add_2_calendar` - For adding events to device calendar
- `intl` - For date formatting

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.