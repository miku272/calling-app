import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

/// A reusable phone input field widget that combines a country code picker
/// with a text field for phone number input.
///
/// This widget provides an international phone number input solution with:
/// - Country code selection with flags
/// - Searchable country list
/// - Favorite countries support
/// - Form validation
/// - Theme integration
class PhoneInputField extends StatefulWidget {
  /// Controller for the phone number text field
  final TextEditingController controller;

  /// Validator function for the phone number
  final String? Function(String?)? validator;

  /// Label text for the input field
  final String? labelText;

  /// Hint text for the input field
  final String? hintText;

  /// Initial country selection (country code like 'US', 'IN', 'GB', etc.)
  final String initialCountryCode;

  /// List of favorite country dial codes (e.g., ['+1', '+91', '+44'])
  final List<String> favoriteCountries;

  /// Callback when country code changes
  final ValueChanged<String>? onCountryChanged;

  /// Enable or disable the input field
  final bool enabled;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Phone Number',
    this.hintText = 'Enter your phone number',
    this.initialCountryCode = 'US',
    this.favoriteCountries = const ['+1', '+91', '+44', '+61'],
    this.onCountryChanged,
    this.enabled = true,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String _countryDialCode;

  @override
  void initState() {
    super.initState();
    // Initialize with default country code
    _countryDialCode = '+1';
  }

  /// Get the complete phone number with country code
  String get fullPhoneNumber => '$_countryDialCode${widget.controller.text}';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country code picker
        Container(
          height: 58,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(16),
          ),
          child: CountryCodePicker(
            onChanged: (countryCode) {
              setState(() {
                _countryDialCode = countryCode.dialCode ?? '+1';
              });
              if (widget.onCountryChanged != null) {
                widget.onCountryChanged!(_countryDialCode);
              }
            },
            initialSelection: widget.initialCountryCode,
            favorite: widget.favoriteCountries,
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            showFlag: true,
            showFlagMain: true,
            showDropDownButton: true,
            padding: EdgeInsets.zero,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            flagWidth: 24,
            enabled: widget.enabled,
          ),
        ),
        const SizedBox(width: 12),

        // Phone number input
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            validator: widget.validator,
            enabled: widget.enabled,
          ),
        ),
      ],
    );
  }
}
