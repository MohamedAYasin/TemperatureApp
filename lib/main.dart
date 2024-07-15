import 'package:flutter/material.dart';
import 'package:temperature_conversion_app/image.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

/// The main application widget.
class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter Application',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const TemperatureConverterPage(),
    );
  }
}

/// A stateful widget that represents the temperature conversion page.
class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  _TemperatureConverterPageState createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'F to C';
  String _convertedValue = '';
  List<String> _history = [];

  /// Converts the input temperature based on the selected conversion type
  /// and updates the conversion history.
  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    double result;
    String historyEntry;

    if (_selectedConversion == 'F to C') {
      result = (input - 32) * 5 / 9;
      historyEntry =
          'F to C: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(1)}';
    } else {
      result = (input * 9 / 5) + 32;
      historyEntry =
          'C to F: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(1)}';
    }

    setState(() {
      _convertedValue = result.toStringAsFixed(1);
      _history.insert(0, historyEntry);
    });
  }

  /// Clears the conversion history.
  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  /// Navigates to the history page to display the full conversion history.
  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage(history: _history)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.green,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      TempImages.tempImage1,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Failed to load GIF');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedConversion,
                    decoration: InputDecoration(
                      labelText: 'Conversion Type',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.green),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'F to C',
                        child: Text('Fahrenheit to Celsius'),
                      ),
                      DropdownMenuItem(
                        value: 'C to F',
                        child: Text('Celsius to Fahrenheit'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedConversion = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter Temperature',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.green),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: Icon(Icons.thermostat, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _convertTemperature,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'CONVERT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Converted Value: $_convertedValue',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showHistory(context),
                        child: const Text(
                          'History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.green),
                        onPressed: _clearHistory,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 300 : 150,
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(_history[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A stateless widget that displays the full conversion history.
class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({required this.history, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion History'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(history[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}