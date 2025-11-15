import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController? phoneNumberController;
  final bool isEnabled;

  const PhoneNumberField({
    super.key,
    this.phoneNumberController,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: phoneNumberController,
      enabled: isEnabled,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      maxLines: 1,
      decoration: const InputDecoration(
        label: Text('Phone Number'),
        hintText: 'Enter your phone number',
        counterText: '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number cannot be empty';
        }

        if (value.length < 10 || value.length > 10) {
          return 'Phone number must be 10 digits long';
        }

        return null;
      },
    );
  }
}
