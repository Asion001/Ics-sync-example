import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICS Calendar Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IcsCalendarPage(),
    );
  }
}

class IcsCalendarPage extends StatefulWidget {
  const IcsCalendarPage({super.key});

  @override
  State<IcsCalendarPage> createState() => _IcsCalendarPageState();
}

class _IcsCalendarPageState extends State<IcsCalendarPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    // Pre-fill with an example ICS URL
    _urlController.text = 'https://calendar.google.com/calendar/ical/en.usa%23holiday%40group.v.calendar.google.com/public/basic.ics';
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addEventsToCalendar() async {
    if (_urlController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter an ICS calendar URL';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching calendar data...';
    });

    try {
      final response = await http.get(Uri.parse(_urlController.text));
      
      if (response.statusCode == 200) {
        final icsContent = response.body;
        final events = _parseIcsContent(icsContent);
        
        if (events.isEmpty) {
          setState(() {
            _isLoading = false;
            _statusMessage = 'No events found in the ICS file';
          });
          return;
        }

        setState(() {
          _statusMessage = 'Found ${events.length} event(s). Adding to calendar...';
        });

        int successCount = 0;
        for (var event in events) {
          try {
            final result = await Add2Calendar.addEvent2Cal(event);
            if (result) {
              successCount++;
            }
          } catch (e) {
            debugPrint('Error adding event: $e');
          }
        }

        setState(() {
          _isLoading = false;
          _statusMessage = 'Successfully added $successCount event(s) to calendar!';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Failed to fetch calendar. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  List<Event> _parseIcsContent(String icsContent) {
    final events = <Event>[];
    final lines = icsContent.split('\n');
    
    Event? currentEvent;
    String? currentField;
    StringBuffer fieldValue = StringBuffer();

    for (var line in lines) {
      line = line.trim();
      
      // Handle multi-line values
      if (line.startsWith(' ') || line.startsWith('\t')) {
        fieldValue.write(line.substring(1));
        continue;
      }
      
      // Process previous field if exists
      if (currentField != null && currentEvent != null) {
        _setEventField(currentEvent, currentField, fieldValue.toString());
        currentField = null;
        fieldValue.clear();
      }

      if (line.startsWith('BEGIN:VEVENT')) {
        currentEvent = Event(
          title: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        );
      } else if (line.startsWith('END:VEVENT')) {
        if (currentEvent != null && currentEvent.title.isNotEmpty) {
          events.add(currentEvent);
        }
        currentEvent = null;
      } else if (currentEvent != null && line.contains(':')) {
        final colonIndex = line.indexOf(':');
        currentField = line.substring(0, colonIndex);
        fieldValue.write(line.substring(colonIndex + 1));
      }
    }

    return events;
  }

  void _setEventField(Event event, String field, String value) {
    try {
      if (field.startsWith('SUMMARY')) {
        event.title = value;
      } else if (field.startsWith('DESCRIPTION')) {
        event.description = value.replaceAll('\\n', '\n').replaceAll('\\,', ',');
      } else if (field.startsWith('LOCATION')) {
        event.location = value;
      } else if (field.startsWith('DTSTART')) {
        event.startDate = _parseIcsDate(value);
      } else if (field.startsWith('DTEND')) {
        event.endDate = _parseIcsDate(value);
      }
    } catch (e) {
      debugPrint('Error parsing field $field: $e');
    }
  }

  DateTime _parseIcsDate(String dateStr) {
    try {
      // Remove any timezone info for simplicity
      dateStr = dateStr.split(';').last.split(':').last;
      
      // Handle YYYYMMDD format
      if (dateStr.length == 8) {
        return DateTime.parse(
          '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}'
        );
      }
      
      // Handle YYYYMMDDTHHMMSS format
      if (dateStr.length >= 15 && dateStr.contains('T')) {
        final parts = dateStr.split('T');
        final datePart = parts[0];
        final timePart = parts[1].substring(0, 6);
        
        return DateTime.parse(
          '${datePart.substring(0, 4)}-${datePart.substring(4, 6)}-${datePart.substring(6, 8)} '
          '${timePart.substring(0, 2)}:${timePart.substring(2, 4)}:${timePart.substring(4, 6)}'
        );
      }
      
      return DateTime.now();
    } catch (e) {
      debugPrint('Error parsing date: $dateStr - $e');
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ICS Calendar Sync'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter ICS Calendar Link:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'https://example.com/calendar.ics',
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addEventsToCalendar,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.calendar_today),
              label: Text(_isLoading ? 'Processing...' : 'Add to Calendar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            if (_statusMessage.isNotEmpty)
              Card(
                color: _statusMessage.contains('Error') || _statusMessage.contains('Failed')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusMessage.contains('Error') || _statusMessage.contains('Failed')
                          ? Colors.red.shade900
                          : Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'How to use:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Enter or paste your ICS calendar subscription link\n'
              '2. Tap "Add to Calendar" button\n'
              '3. Select your preferred calendar app\n'
              '4. Events will be added to your device calendar',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
