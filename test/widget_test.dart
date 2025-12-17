// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import 'package:ics_sync_example/main.dart';

void main() {
  testWidgets('ICS Calendar app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('ICS Calendar Sync'), findsOneWidget);
    
    // Verify that the input field is present
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify that the button is present
    expect(find.text('Add to Calendar'), findsOneWidget);
  });

  test('Parse ICS with all-day event (VALUE=DATE)', () {
    // Create a test ICS content with VALUE=DATE (all-day event)
    final icsContent = '''BEGIN:VCALENDAR
PRODID:-//MyApp//Calendar 1.0//EN
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH

BEGIN:VEVENT
UID:holiday-20251225@example.local
SUMMARY:Christmas Day
DTSTAMP:20251201T120000Z
DTSTART;VALUE=DATE:20251225
DTEND;VALUE=DATE:20251226
DESCRIPTION:All-day holiday.
STATUS:CONFIRMED
END:VEVENT

END:VCALENDAR''';

    // Create an instance of the page state to access the parsing method
    final state = _IcsCalendarPageState();
    
    // Call the parsing method
    final events = state.parseIcsContentForTest(icsContent);
    
    // Verify that one event was parsed
    expect(events.length, 1, reason: 'Should parse exactly one event');
    
    // Verify event properties
    final event = events[0];
    expect(event.title, 'Christmas Day');
    expect(event.description, 'All-day holiday.');
    expect(event.allDay, true, reason: 'Event with VALUE=DATE should be all-day');
    
    // Verify dates
    expect(event.startDate.year, 2025);
    expect(event.startDate.month, 12);
    expect(event.startDate.day, 25);
    
    expect(event.endDate.year, 2025);
    expect(event.endDate.month, 12);
    expect(event.endDate.day, 26);
  });

  test('Parse ICS with timed event', () {
    // Create a test ICS content with timed event
    final icsContent = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN

BEGIN:VEVENT
UID:test-event@example.com
SUMMARY:Meeting
DTSTART:20251217T140000Z
DTEND:20251217T150000Z
DESCRIPTION:Team meeting
END:VEVENT

END:VCALENDAR''';

    // Create an instance of the page state to access the parsing method
    final state = _IcsCalendarPageState();
    
    // Call the parsing method
    final events = state.parseIcsContentForTest(icsContent);
    
    // Verify that one event was parsed
    expect(events.length, 1, reason: 'Should parse exactly one event');
    
    // Verify event properties
    final event = events[0];
    expect(event.title, 'Meeting');
    expect(event.description, 'Team meeting');
    expect(event.allDay, false, reason: 'Event without VALUE=DATE should not be all-day');
  });
}

// Extension to make the private method accessible for testing
extension _IcsCalendarPageStateTestExtension on _IcsCalendarPageState {
  List<Event> parseIcsContentForTest(String icsContent) {
    return _parseIcsContent(icsContent);
  }
}
