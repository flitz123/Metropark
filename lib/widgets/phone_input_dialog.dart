import 'package:flutter/material.dart';

class PhoneInputDialog extends StatefulWidget {
  final Function(String) onPhoneEntered;

  const PhoneInputDialog({super.key, required this.onPhoneEntered});

  @override
  State<PhoneInputDialog> createState() => _PhoneInputDialogState();
}

class _PhoneInputDialogState extends State<PhoneInputDialog> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Phone Number'),
      content: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          hintText: '07XXXXXXXX',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String phone = _phoneController.text.trim();
            if (phone.isNotEmpty) {
              widget.onPhoneEntered(phone);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}