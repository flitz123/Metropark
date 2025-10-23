import 'package:flutter/material.dart';
import '../models/parking_spot.dart';
import '../models/shared_prefs.dart';
import '../widgets/parking_spot_widget.dart';
import '../widgets/phone_input_dialog.dart';
import '../services/sms_service.dart';
import 'confirmation_screen.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<ParkingSpot> parkingSpots = [];
  final SharedPrefs sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    loadParkingData();
  }

  Future<void> loadParkingData() async {
    String parkingDataJson = await sharedPrefs.getParkingData();
    
    if (parkingDataJson.isEmpty) {
      // Initialize default data
      parkingSpots = List.generate(20, (index) => ParkingSpot(
        id: index + 1,
        occupied: false,
        carReg: '',
        phone: '',
        startTime: 0,
      ));
    } else {
      // Parse JSON data (you'll need to implement JSON parsing)
      // For now, using default data
      parkingSpots = List.generate(20, (index) => ParkingSpot(
        id: index + 1,
        occupied: index % 3 == 0, // Some spots occupied for demo
        carReg: '',
        phone: '',
        startTime: 0,
      ));
    }
    
    setState(() {});
  }

  void onSpotTap(ParkingSpot spot) async {
    if (spot.occupied) return;

    String userPhone = await sharedPrefs.getUserPhone();
    
    if (userPhone.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => PhoneInputDialog(
          onPhoneEntered: (phone) async {
            await sharedPrefs.saveUserPhone(phone);
            proceedToConfirmation(spot);
          },
        ),
      );
    } else {
      proceedToConfirmation(spot);
    }
  }

  void proceedToConfirmation(ParkingSpot spot) async {
    String userPhone = await sharedPrefs.getUserPhone();
    
    // Send SMS confirmation
    await _sendSMSConfirmation(spot, userPhone);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(spotId: spot.id, userPhone: userPhone),
      ),
    );
  }

  Future<void> _sendSMSConfirmation(ParkingSpot spot, String userPhone) async {
    String message = SmsService.formatConfirmationMessage(spot.id);
    
    await SmsService.sendSMS(
      phoneNumber: userPhone,
      message: message,
      onSuccess: (successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      onError: (errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
    
    await sharedPrefs.savePendingConfirmation(spot.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Spots'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: parkingSpots.length,
        itemBuilder: (context, index) {
          return ParkingSpotWidget(
            spot: parkingSpots[index],
            onTap: () => onSpotTap(parkingSpots[index]),
          );
        },
      ),
    );
  }
}