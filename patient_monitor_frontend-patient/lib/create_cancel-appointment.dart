import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'view-appointment.dart';

class CreateCancelAppointmentPage extends StatefulWidget {
  @override
  _CreateCancelAppointmentPageState createState() => _CreateCancelAppointmentPageState();
}

class _CreateCancelAppointmentPageState extends State<CreateCancelAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Automatically set the current day and time
  String _currentDay = '';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    // Set the current day and time
    DateTime now = DateTime.now();
    _currentDay = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _currentTime = '${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  Future<void> createAppointment() async {
    final appointment = {
      "email": "patient@example.com",
      "day": _currentDay,
      "time": _currentTime,
      "details": {
        "patient_name": _nameController.text,
        "condition": _conditionController.text.isNotEmpty ? _conditionController.text : "Routine check-up",
        "notes": _notesController.text.isNotEmpty ? _notesController.text : "No specific notes"
      }
    };

    final response = await http.post(
      Uri.parse('http://localhost:3100/api/v1/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(appointment),
    );

    if (response.statusCode == 201) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment created successfully!')));
      _nameController.clear();
      _conditionController.clear();
      _notesController.clear(); // Clear input fields after submission
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create appointment.')));
    }
  }

  Future<void> deleteAppointment() async {
    final response = await http.delete(Uri.parse('http://localhost:3100/api/v1/appointments/last'));

    if (response.statusCode == 200) {
      // Handle successful deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment deleted successfully!')));
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete appointment.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Management',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _inputField("Patient Name", _nameController, icon: Icons.person_outline),
                const SizedBox(height: 20),
                _inputField("Condition", _conditionController, icon: Icons.medical_services),
                const SizedBox(height: 20),
                _inputField("Notes", _notesController, icon: Icons.notes),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Date",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  initialValue: _currentDay,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Time",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  initialValue: _currentTime,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _commonButton("Create Appointment", Colors.green, createAppointment),
                    const SizedBox(width: 20),
                    _commonButton("Cancel Appointment", Colors.red, deleteAppointment),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _commonButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _inputField(String labelText, TextEditingController controller, {IconData? icon}) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null 
            ? Icon(icon, color: Colors.white70) 
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}