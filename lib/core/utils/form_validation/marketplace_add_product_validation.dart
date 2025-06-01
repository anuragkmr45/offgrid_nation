class MarketplaceAddProductValidation {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final numeric = value.trim().replaceAll(RegExp(r'[^0-9.]'), '');
    if (numeric.isEmpty || double.tryParse(numeric) == null) {
      return 'Price must be a valid number';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.length > 400) {
      return 'Description cannot exceed 400 characters';
    }
    // final isValid = RegExp(r'^[a-zA-Z0-9 .,!?\n\r\t-]+\$').hasMatch(value);
    // if (!isValid) {
    //   return 'Only alphanumeric and basic punctuation allowed';
    // }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  static bool canSubmit({
    required String title,
    required String price,
    required String description,
    required String location,
    required bool hasImages,
    required bool hasCategory,
    required bool hasCondition,
    required bool hasLatLng,
  }) {
    return validateTitle(title) == null &&
        validatePrice(price) == null &&
        validateDescription(description) == null &&
        validateLocation(location) == null &&
        hasImages &&
        hasCategory &&
        hasCondition &&
        hasLatLng;
  }
}