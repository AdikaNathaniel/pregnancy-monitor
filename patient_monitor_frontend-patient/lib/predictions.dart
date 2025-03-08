import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PregnancyComplicationsPage(),
    );
  }
}

class PregnancyComplicationsPage extends StatefulWidget {
  @override
  _PregnancyComplicationsPageState createState() =>
      _PregnancyComplicationsPageState();
}

class _PregnancyComplicationsPageState
    extends State<PregnancyComplicationsPage> {
  List<Map<String, String>> complications = [
    {'name': 'Preeclampsia', 'severity': 'Mild'},
    {'name': 'Anemia', 'severity': 'High'},
    {'name': 'Gestational Diabetes', 'severity': 'Low'}
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Update the displayed complication every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % complications.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Pregnancy Complication Prediction',
            style: TextStyle(
              color: Colors.white, // Set the text color to white
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade100, Colors.pink.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        complications[currentIndex]['name']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Removed the severity text here
                      SizedBox(height: 20),
                      severityIndicator(complications[currentIndex]['severity']!)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget severityIndicator(String severity) {
    Color color;
    String message;

    switch (severity) {
      case 'Low':
        color = Colors.green;
        message = 'Monitor your health, stay active and hydrated!';
        break;
      case 'Mild':
        color = Colors.orange;
        message = 'Watch for symptoms and consult your doctor regularly.';
        break;
      case 'High':
        color = Colors.red;
        message = 'Immediate attention is needed. Contact your healthcare provider.';
        break;
      default:
        color = Colors.grey;
        message = 'Consult your doctor for further guidance.';
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            severity, // Severity now only shows in this button
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}