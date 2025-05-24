import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:offgrid_nation_app/core/utils/form_validation/signup_form_validation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCase0 extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final String countryCode;

  const SignupCase0({
    super.key,
    required this.usernameController,
    required this.phoneController,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: usernameController,
          placeholder: 'Username',
          keyboardType: TextInputType.text,
          validator: (value) {
            final validation = SignupFormValidation.validateUsername(value);
            if (validation != null) return validation;

            final availability =
                context.read<SignupBloc>().state.usernameAvailability;
            if (availability == UsernameAvailabilityStatus.unavailable) {
              return 'Username not available';
            }

            return null;
          },
        ).animate().fadeIn(duration: 800.ms),

        const SizedBox(height: 16),
        Row(
          children: [
            CountryCodePicker(
              onChanged: (country) {
                // Update country code if required via a callback or state management.
              },
              initialSelection: 'IN',
              favorite: const ['+91', 'IN'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputField(
                controller: phoneController,
                placeholder: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: SignupFormValidation.validatePhone,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
      ],
    );
  }
}
