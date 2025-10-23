import 'package:flutter/material.dart';
import '../services/mpesa_service.dart';
import '../services/sms_service.dart';
import '../models/shared_prefs.dart';

class ConfirmationScreen extends StatefulWidget {
  final int spotId;
  final String userPhone;

  const ConfirmationScreen({
    super.key,
    required this.spotId,
    required this.userPhone,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String status = 'Waiting for SMS confirmation...';
  bool paymentInitiated = false;
  bool confirmed = false;
  final SharedPrefs sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    // Simulate SMS reception
    _simulateSMSReception();
  }

  void _simulateSMSReception() {
    // In a real app, you would listen for actual SMS messages
    // For demo, we simulate receiving a "YES" response after 3 seconds
    SmsService.simulateSMSReceival(
      message: 'YES', // Simulate positive response
      onMessageReceived: (message) {
        if (mounted) {
          setState(() {
            status = 'SMS confirmed! Processing payment...';
            confirmed = SmsService.parseSMSResponse(message);
          });
          
          if (confirmed) {
            initiatePayment();
          } else {
            _handleCancellation();
          }
        }
      },
    );
  }

  void initiatePayment() {
    setState(() {
      paymentInitiated = true;
    });

    MpesaService().initiateSTKPush(
      phoneNumber: widget.userPhone,
      amount: 50,
      description: 'Parking fee for spot ${widget.spotId}',
      onSuccess: (transactionId) {
        if (mounted) {
          setState(() {
            status = 'Payment successful! Spot ${widget.spotId} is reserved. Transaction ID: $transactionId';
          });
          _updateParkingSpotStatus();
        }
      },
      onError: (errorMessage) {
        if (mounted) {
          setState(() {
            status = 'Payment failed: $errorMessage';
          });
        }
      },
    );
  }

  void _handleCancellation() {
    setState(() {
      status = 'Reservation cancelled by user.';
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _updateParkingSpotStatus() {
    // Update parking spot status in shared preferences
    // This would typically involve updating your data model
    sharedPrefs.clearPendingConfirmation();
    
    // In a real app, you would update the actual parking spot data
    print('Spot ${widget.spotId} reserved successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              paymentInitiated ? Icons.check_circle : 
              confirmed ? Icons.thumb_up : Icons.access_time,
              color: paymentInitiated ? Colors.green : 
                    confirmed ? Colors.blue : Colors.orange,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Spot ${widget.spotId}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              status,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (paymentInitiated)
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Return to Home'),
              ),
            if (!confirmed && !paymentInitiated)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        confirmed = true;
                        status = 'SMS confirmed! Processing payment...';
                      });
                      initiatePayment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Simulate YES'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _handleCancellation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Simulate NO'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}