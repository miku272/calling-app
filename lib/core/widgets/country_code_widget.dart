import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CountryCodeWidget extends StatefulWidget {
  final ValueChanged<CountryCode>? onChanged;
  final String? initialSelection;
  final bool isEnabled;

  const CountryCodeWidget({
    super.key,
    required this.onChanged,
    this.initialSelection,
    this.isEnabled = true,
  });

  @override
  State<CountryCodeWidget> createState() => _CountryCodeWidgetState();
}

class _CountryCodeWidgetState extends State<CountryCodeWidget> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return CountryCodePicker(
      onChanged: widget.onChanged,
      enabled: widget.isEnabled,
      initialSelection: widget.initialSelection ?? 'IN',
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      padding: EdgeInsets.zero,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      dialogTextStyle: Theme.of(context).textTheme.bodyMedium,
      searchStyle: Theme.of(context).textTheme.bodyMedium,
      searchDecoration: const InputDecoration(
        hintText: 'Search country',
        prefixIcon: Icon(Icons.search),
      ),
      topBarPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      dialogItemPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      dialogSize: Size(screenSize.width * 0.9, screenSize.height * 0.85),
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
