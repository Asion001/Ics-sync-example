# UI Mockup - ICS Calendar Sync App

```
┌─────────────────────────────────────────────────┐
│  ICS Calendar Sync                         🔙 ⋮│  <- App Bar
├─────────────────────────────────────────────────┤
│                                                 │
│  Enter ICS Calendar Link:                      │  <- Section Title
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │ 🔗  https://calendar.google.com/....    │  │  <- Text Input Field
│  └─────────────────────────────────────────┘  │     (Pre-filled with example)
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │     📅  Add to Calendar                  │  │  <- Primary Action Button
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │  ✓ Successfully added 12 event(s) to    │  │  <- Status Message Card
│  │    calendar!                             │  │     (Green for success)
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ────────────────────────────────────────────  │  <- Divider
│                                                 │
│  How to use:                                   │  <- Help Section
│                                                 │
│  1. Enter or paste your ICS calendar           │
│     subscription link                          │
│  2. Tap "Add to Calendar" button               │
│  3. Select your preferred calendar app         │
│  4. Events will be added to your device        │
│     calendar                                    │
│                                                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Loading State

```
┌─────────────────────────────────────────────────┐
│  ICS Calendar Sync                         🔙 ⋮│
├─────────────────────────────────────────────────┤
│                                                 │
│  Enter ICS Calendar Link:                      │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │ 🔗  https://calendar.google.com/....    │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │     ⟳  Processing...                    │  │  <- Button (Disabled)
│  └─────────────────────────────────────────┘  │     with spinner
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │  Fetching calendar data...               │  │  <- Status Message
│  └─────────────────────────────────────────┘  │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Error State

```
┌─────────────────────────────────────────────────┐
│  ICS Calendar Sync                         🔙 ⋮│
├─────────────────────────────────────────────────┤
│                                                 │
│  Enter ICS Calendar Link:                      │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │ 🔗  https://invalid-url.com             │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │     📅  Add to Calendar                  │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │  ✗ Failed to fetch calendar. Status:    │  │  <- Error Message Card
│  │    404                                   │  │     (Red background)
│  └─────────────────────────────────────────┘  │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Material Design 3 Features Used

- **Color Scheme**: Blue seed color with Material 3 dynamic theming
- **Typography**: Material 3 text styles
- **Components**:
  - OutlineInputBorder for text field
  - ElevatedButton with icon
  - Card for status messages
  - Divider for section separation
- **Icons**: Material Icons (link, calendar_today)
- **Spacing**: Consistent 8-16px padding and margins
- **Interactive States**: 
  - Disabled button during loading
  - Loading spinner in button
  - Color-coded status messages

## User Interaction Flow

### Step 1: Open App
User sees the main screen with:
- Pre-filled example ICS URL
- Clear "Add to Calendar" button
- Usage instructions

### Step 2: Enter/Modify URL
User can:
- Clear the field and enter their own ICS URL
- Paste a URL from clipboard
- Keep the example URL to test

### Step 3: Tap Button
When user taps "Add to Calendar":
1. Button becomes disabled
2. Shows "Processing..." with spinner
3. Status updates: "Fetching calendar data..."

### Step 4: Processing
App performs:
1. HTTP GET request to the ICS URL
2. Parse the ICS content
3. Extract all VEVENT entries
4. Status updates: "Found X event(s). Adding to calendar..."

### Step 5: Calendar Integration
For each event:
1. Opens native calendar picker (first event only)
2. User selects which calendar to use (Google Calendar, Outlook, etc.)
3. Event is added with all details:
   - Title
   - Start/End date & time
   - Location
   - Description

### Step 6: Completion
Success message shows:
- "Successfully added X event(s) to calendar!"
- Green background for positive feedback
- User can add more calendars or exit

## Cross-Platform Behavior

### Android
- Uses native Android calendar intent
- Works with: Google Calendar, Samsung Calendar, Outlook, any calendar app
- Requires calendar permissions (requested at runtime)

### iOS
- Uses native iOS EventKit
- Works with: Apple Calendar, Google Calendar, Outlook
- Permission dialog shown on first use

### Web
- Downloads .ics file for import
- User can open with web calendar services
- Or import into local calendar app
