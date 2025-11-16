import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

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
    final appLocalizations = AppLocalizations.of(context)!;

    return TextFormField(
      controller: phoneNumberController,
      enabled: isEnabled,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(appLocalizations.phoneNumber),
        hintText:
            '${appLocalizations.enterYour} ${appLocalizations.phoneNumber}',
        counterText: '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return appLocalizations.phoneNumberCannotBeEmpty;
        }

        if (value.length < 10 || value.length > 10) {
          return appLocalizations.phoneNumberMustBe10Digits;
        }

        return null;
      },
    );
  }
}
