import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

class SmsService {
  // Method to send SMS using flutter_sms package
  static Future<void> sendSMS({
    required String phoneNumber,
    required String message,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      String result = await sendSMS(
        message: message,
        recipients: [phoneNumber],
        sendDirect: true,
      );

      if (result == 'SMS Sent!') {
        onSuccess('SMS sent successfully');
      } else {
        onError('Failed to send SMS: $result');
      }
    } catch (e) {
      // If direct SMS fails, try launching the default SMS app
      await _launchSmsApp(phoneNumber, message, onError);
    }
  }

  // Fallback method to launch default SMS app
  static Future<void> _launchSmsApp(
    String phoneNumber,
    String message,
    Function(String) onError,
  ) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        onError('Could not launch SMS app');
      }
    } catch (e) {
      onError('Error launching SMS app: $e');
    }
  }

  // Method to simulate receiving SMS (for demo purposes)
  static void simulateSMSReceival({
    required String message,
    required Function(String) onMessageReceived,
  }) {
    // In a real app, you would use a package like flutter_sms_receiver
    // or implement SMS reading functionality
    // This is a simulation for demo purposes
    Future.delayed(const Duration(seconds: 3), () {
      onMessageReceived(message);
    });
  }

  // Method to check if SMS can be sent
  static Future<bool> canSendSMS() async {
    try {
      // Try to check if SMS capability is available
      return true; // Assume true for most devices
    } catch (e) {
      return false;
    }
  }

  // Method to format confirmation message
  static String formatConfirmationMessage(int spotId) {
    return "MetroPark: Confirm parking spot $spotId. Reply YES to confirm or NO to cancel.";
  }

  // Method to parse SMS response
  static bool parseSMSResponse(String message) {
    String cleanedMessage = message.trim().toUpperCase();
    
    if (cleanedMessage.contains('YES')) {
      return true;
    } else if (cleanedMessage.contains('NO')) {
      return false;
    }
    
    // Default to false if response is unclear
    return false;
  }
}