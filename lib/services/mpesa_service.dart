class MpesaService {
  static const String baseUrl = 'https://sandbox.safaricom.co.ke/';

  Future<void> initiateSTKPush({
    required String phoneNumber,
    required int amount,
    required String description,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    // Simulate M-Pesa API call
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo purposes, we'll simulate a successful payment
    onSuccess('SIM${DateTime.now().millisecondsSinceEpoch}');
    
    // In a real implementation, you would:
    // 1. Format phone number
    // 2. Generate password and timestamp
    // 3. Make HTTP request to M-Pesa API
    // 4. Handle response
  }

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      return '254${cleaned.substring(1)}';
    } else if (cleaned.startsWith('254')) {
      return cleaned;
    } else {
      return '254$cleaned';
    }
  }
}