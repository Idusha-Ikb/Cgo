import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Driver Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Expanded(
  child: Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Stack(
      children: [
        
        Positioned.fill(
          child: Image.asset(
            'assets/images/map.png',
            fit: BoxFit.cover,
          ),
        ),

        
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white.withOpacity(0.85),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: const Text(
              'Colombo Port -> Orugodawatte Depot',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('12km', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Estimated 1h 15m', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981),),
                    onPressed: () {},
                    icon: const Icon(Icons.navigation, color: Colors.white),
                    label: const Text('Start Navigation', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}