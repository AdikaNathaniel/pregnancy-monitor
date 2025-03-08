import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewAppointmentsPage extends StatefulWidget {
  @override
  _ViewAppointmentsPageState createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  List<dynamic> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final response = await http.get(Uri.parse('http://localhost:3100/api/v1/appointments'));
    if (response.statusCode == 200) {
      setState(() {
        appointments = json.decode(response.body);
      });
    }
  }

  Future<void> deleteAppointment(String patientName) async {
    await http.delete(Uri.parse('http://localhost:3100/api/v1/appointments/$patientName'));
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Appointments')),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          var appointment = appointments[index];
          return ListTile(
            title: Text(appointment['details']['patient_name']),
            subtitle: Text("${appointment['day']} at ${appointment['time']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteAppointment(appointment['details']['patient_name']),
            ),
          );
        },
      ),
    );
  }
}
