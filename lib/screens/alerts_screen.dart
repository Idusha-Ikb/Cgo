import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildAlertItem(
          Icons.warning_amber_rounded,
          const Color.fromARGB(255, 224, 201, 165),
          'Route Deviation Warning',
          'You have deviated from the assigned route. Please return to the travel corridor.',
          '10:24 AM',
        ),
        _buildAlertItem(
          Icons.lock_clock,
          Colors.red,
          'Tamper Alert',
          'Unauthorized container door / seal opening attempt detected!',
          '09:15 AM',
        ),
        _buildAlertItem(
          Icons.speed,
          Colors.amber.shade700,
          'Speed & Delay Warning',
          'Abnormal transit delay detected along your route.',
          '08:12 AM',
        ),
      ],
    );
  }

  Widget _buildAlertItem(
      IconData icon, Color color, String title, String desc, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, color: color),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(desc, style: const TextStyle(fontSize: 12)),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}