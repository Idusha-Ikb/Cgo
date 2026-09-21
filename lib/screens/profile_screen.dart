import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  String name = 'Kasun Perera';
  String phone = '+94 77 430 5801';
  String email = 'kasunperera@gmail.com';
  String vehicle = 'CONT-001';
  String company = 'CK Logistics';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

 
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? name;
      phone = prefs.getString('phone') ?? phone;
      email = prefs.getString('email') ?? email;
      vehicle = prefs.getString('vehicle') ?? vehicle;
      company = prefs.getString('company') ?? company;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Driver', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(height: 20),
          _buildInfoTile(Icons.badge_outlined, 'Driver ID', 'DR-0461'),
          _buildInfoTile(Icons.phone_outlined, 'Phone', phone),
          _buildInfoTile(Icons.email_outlined, 'E-mail', email),
          _buildInfoTile(Icons.directions_car_outlined, 'Vehicle Details', vehicle),
          _buildInfoTile(Icons.business_outlined, 'Company Details', company),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: name,
                      phone: phone,
                      email: email,
                      vehicle: vehicle,
                      company: company,
                    ),
                  ),
                );

                
                if (result != null && result is Map<String, String>) {
                  setState(() {
                    name = result['name'] ?? name;
                    phone = result['phone'] ?? phone;
                    email = result['email'] ?? email;
                    vehicle = result['vehicle'] ?? vehicle;
                    company = result['company'] ?? company;
                  });
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade800),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: value.isNotEmpty
            ? Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
            : null,
        trailing: value.isEmpty ? const Icon(Icons.chevron_right) : null,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}