import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:local_auth/local_auth.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings States
  bool _tamperAlertSound = true;
  String _selectedSound = 'Loud Siren';
  bool _highAccuracyGPS = true;
  bool _offlineSync = true;
  double _speedLimit = 80;

  // App Lock & Biometrics
  bool _isAppLockEnabled = false;
  String _lockType = 'PIN';
  String _userPin = '1234';
  final LocalAuthentication _auth = LocalAuthentication();

  // Biometric Auth Function
  Future<void> _authenticateBiometrics() async {
    try {
      bool canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canAuthenticate) {
        _showSnackBar('Biometrics not available on this device');
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason:
            'Scan fingerprint to enable App Lock for SecureTrackSL',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );

      if (authenticated) {
        setState(() {
          _lockType = 'Biometric';
          _isAppLockEnabled = true;
        });
        _showSnackBar('Biometric Lock Enabled Successfully!');
      } else {
        setState(() => _isAppLockEnabled = false);
      }
    } catch (e) {
      _showSnackBar('Authentication Error: $e');
      setState(() => _isAppLockEnabled = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSoundPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Tamper Sound'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Loud Siren', 'Beep Alarm', 'Pulse Tone'].map((sound) {
              return RadioListTile<String>(
                title: Text(sound),
                value: sound,
                groupValue: _selectedSound,
                onChanged: (val) {
                  setState(() => _selectedSound = val!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLockTypePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Configure App Lock'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('PIN Code'),
                value: 'PIN',
                groupValue: _lockType,
                onChanged: (val) {
                  Navigator.pop(context);
                  _showSetPinDialog();
                },
              ),
              RadioListTile<String>(
                title: const Text('Fingerprint / Face ID'),
                value: 'Biometric',
                groupValue: _lockType,
                onChanged: (val) {
                  Navigator.pop(context);
                  _authenticateBiometrics();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSetPinDialog() {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set 4-Digit Security PIN'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: const InputDecoration(hintText: 'Enter 4-digit PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (pinController.text.length == 4) {
                  setState(() {
                    _userPin = pinController.text;
                    _lockType = 'PIN';
                    _isAppLockEnabled = true;
                  });
                  Navigator.pop(context);
                  _showSnackBar('PIN Lock Enabled!');
                } else {
                  _showSnackBar('Please enter a valid 4-digit PIN');
                }
              },
              child: const Text('Save PIN'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Display & Language'.tr()),

          // 1. App Theme Switcher
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text('App Theme'.tr()),
            trailing: DropdownButton<ThemeMode>(
              value: themeNotifier.value,
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  setState(() {
                    themeNotifier.value = newMode;
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Default'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Mode'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Mode'),
                ),
              ],
            ),
          ),

          // 2. Language Switcher (English, Sinhala, Tamil)
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Language'.tr()),
            trailing: DropdownButton<Locale>(
              value: context.locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  context.setLocale(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('si'),
                  child: Text('සිංහල'),
                ),
                DropdownMenuItem(
                  value: Locale('ta'),
                  child: Text('தமிழ்'),
                ),
              ],
            ),
          ),
          const Divider(),

          //SECURITY & TAMPERING 
          _buildSectionHeader('Security & Tampering Alerts'.tr()),
          SwitchListTile(
            title: Text('Tamper Alert Sound'.tr()),
            subtitle: Text('Current Tone: $_selectedSound'),
            value: _tamperAlertSound,
            secondary:
                const Icon(Icons.warning_amber_rounded, color: Colors.red),
            onChanged: (val) => setState(() => _tamperAlertSound = val),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text('Change Alarm Sound'.tr()),
            enabled: _tamperAlertSound,
            onTap: _showSoundPicker,
          ),
          SwitchListTile(
            title: Text('App Lock (PIN / Biometrics)'.tr()),
            subtitle: Text(_isAppLockEnabled
                ? 'Protection Active: $_lockType'
                : 'Disabled'),
            value: _isAppLockEnabled,
            secondary: const Icon(Icons.security),
            onChanged: (val) {
              if (val) {
                _showLockTypePicker();
              } else {
                setState(() => _isAppLockEnabled = false);
              }
            },
          ),
          const Divider(),

          //TRACKING & GPS
          _buildSectionHeader('Tracking & GPS'.tr()),
          SwitchListTile(
            title: Text('High-Accuracy GPS Tracking'.tr()),
            value: _highAccuracyGPS,
            secondary: const Icon(Icons.gps_fixed),
            onChanged: (val) => setState(() => _highAccuracyGPS = val),
          ),
          SwitchListTile(
            title: Text('Auto Offline Sync'.tr()),
            value: _offlineSync,
            secondary: const Icon(Icons.cloud_sync),
            onChanged: (val) => setState(() => _offlineSync = val),
          ),
          const Divider(),

          //SAFETY LIMITS
          _buildSectionHeader('Safety Limits'.tr()),
          ListTile(
            leading: const Icon(Icons.speed),
            title: Text('Speed Alert Threshold'.tr()),
            subtitle: Text('${_speedLimit.round()} km/h'),
          ),
          Slider(
            value: _speedLimit,
            min: 40,
            max: 120,
            divisions: 8,
            label: '${_speedLimit.round()} km/h',
            onChanged: (val) => setState(() => _speedLimit = val),
          ),
          const Divider(),

          //DIAGNOSTICS
          _buildSectionHeader('Diagnostics & Status'.tr()),
          ListTile(
            leading: const Icon(Icons.sensors, color: Colors.blue),
            title: Text('Live Hardware Status'.tr()),
            subtitle: const Text('View GPS & Sensor Diagnostics (Real-time)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiagnosticsStatusPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// Hardware Diagnostics Sub-page
class DiagnosticsStatusPage extends StatelessWidget {
  const DiagnosticsStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Sensor Diagnostics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusCard(
              title: 'GPS Module Status',
              status: 'Connected (12 Satellites)',
              isOk: true,
              icon: Icons.gps_fixed,
            ),
            _buildStatusCard(
              title: 'Tampering Sensor',
              status: 'Intact (No Tamper Events)',
              isOk: true,
              icon: Icons.verified_user,
            ),
            _buildStatusCard(
              title: 'Backup Battery',
              status: '94% (Charging)',
              isOk: true,
              icon: Icons.battery_charging_full,
            ),
            _buildStatusCard(
              title: 'Backend API Connection',
              status: 'Online (Last sync: 2s ago)',
              isOk: true,
              icon: Icons.cloud_done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required bool isOk,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: isOk ? Colors.green : Colors.red, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Icon(
          isOk ? Icons.check_circle : Icons.error,
          color: isOk ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}