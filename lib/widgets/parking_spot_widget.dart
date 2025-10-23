import 'package:flutter/material.dart';
import '../models/parking_spot.dart';

class ParkingSpotWidget extends StatelessWidget {
  final ParkingSpot spot;
  final VoidCallback onTap;

  const ParkingSpotWidget({
    super.key,
    required this.spot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: spot.occupied ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: spot.occupied ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${spot.id}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              spot.occupied ? 'Occupied' : 'Available',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}