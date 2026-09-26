import 'package:flutter/material.dart';

enum PriorityLevel {
  normal,
  important,
  high,
  critical,
}

extension PriorityExtension on PriorityLevel {
  String get label {
    switch (this) {
      case PriorityLevel.normal:
        return 'Normal';
      case PriorityLevel.important:
        return 'Important';
      case PriorityLevel.high:
        return 'High';
      case PriorityLevel.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case PriorityLevel.normal:
        return Colors.green;
      case PriorityLevel.important:
        return Colors.orange;
      case PriorityLevel.high:
        return Colors.red;
      case PriorityLevel.critical:
        return Colors.purple.shade800;
    }
  }
}

class AlertItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final PriorityLevel priority;

  const AlertItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.priority,
  });
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static final List<AlertItem> alerts = [
    const AlertItem(
      title: 'New Trip Assigned',
      description: 'New shipment assigned to you.',
      time: 'Just now',
      icon: Icons.local_shipping_rounded,
      priority: PriorityLevel.normal,
    ),
    const AlertItem(
      title: 'Route Assigned/Updated',
      description: 'Your route has been updated.',
      time: '10 mins ago',
      icon: Icons.map_rounded,
      priority: PriorityLevel.important,
    ),
    const AlertItem(
      title: 'Route Deviation',
      description: 'You have moved outside the assigned route.',
      time: '15 mins ago',
      icon: Icons.alt_route_rounded,
      priority: PriorityLevel.high,
    ),
    const AlertItem(
      title: 'Geofence Alert',
      description: 'You are approaching a restricted area.',
      time: '25 mins ago',
      icon: Icons.wrong_location_rounded,
      priority: PriorityLevel.important,
    ),
    const AlertItem(
      title: 'Shipment Update',
      description: 'Shipment status has been updated.',
      time: '1 hr ago',
      icon: Icons.inventory_2_rounded,
      priority: PriorityLevel.normal,
    ),
    const AlertItem(
      title: 'Customs Message',
      description: 'Customs Officer sent you a message.',
      time: '1 hr ago',
      icon: Icons.mark_chat_unread_rounded,
      priority: PriorityLevel.important,
    ),
    const AlertItem(
      title: 'Customs Instruction',
      description: 'Please stop at the designated checkpoint.',
      time: '2 hrs ago',
      icon: Icons.campaign_rounded,
      priority: PriorityLevel.high,
    ),
    const AlertItem(
      title: 'Issue Response',
      description: 'Your reported vehicle issue has been received.',
      time: '3 hrs ago',
      icon: Icons.build_circle_rounded,
      priority: PriorityLevel.normal,
    ),
    const AlertItem(
      title: 'Issue Resolved',
      description: 'Your reported issue has been resolved.',
      time: '4 hrs ago',
      icon: Icons.check_circle_rounded,
      priority: PriorityLevel.normal,
    ),
    const AlertItem(
      title: 'Security Alert',
      description: 'Security issue detected for your shipment.',
      time: '5 hrs ago',
      icon: Icons.gpp_maybe_rounded,
      priority: PriorityLevel.critical,
    ),
    const AlertItem(
      title: 'Emergency Response',
      description: 'Customs has received your emergency alert.',
      time: 'Yesterday',
      icon: Icons.notification_important_rounded,
      priority: PriorityLevel.critical,
    ),
    const AlertItem(
      title: 'Schedule Update',
      description: 'Expected arrival time has been updated.',
      time: 'Yesterday',
      icon: Icons.update_rounded,
      priority: PriorityLevel.normal,
    ),
    const AlertItem(
      title: 'Trip Completed',
      description: 'Shipment delivery completed successfully.',
      time: '2 days ago',
      icon: Icons.task_alt_rounded,
      priority: PriorityLevel.normal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return _buildAlertCard(alert);
        },
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    final priorityColor = alert.priority.color;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: priorityColor.withOpacity(0.12),
            radius: 24,
            child: Icon(alert.icon, color: priorityColor, size: 24),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    alert.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  alert.time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.description,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: priorityColor.withOpacity(0.5), width: 0.8),
                ),
                child: Text(
                  alert.priority.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          onTap: () {},
        ),
      ),
    );
  }
}