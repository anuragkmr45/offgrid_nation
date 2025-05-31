import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/media_picker_component.dart';

class CreateListingBody extends StatefulWidget {
  final List<File> selectedImages;
  final ValueChanged<List<File>> onMediaChanged;

  const CreateListingBody({
    super.key,
    required this.selectedImages,
    required this.onMediaChanged,
  });

  @override
  State<CreateListingBody> createState() => _CreateListingBodyState();
}

class _CreateListingBodyState extends State<CreateListingBody> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  double? _latitude;
  double? _longitude;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  final List<String> _conditions = [
    'New',
    'Used - Like New',
    'Used - Good',
    'Others',
  ];
  String? _selectedCondition;

  // ✅ New: Category state
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  List<CategoryEntity> _categories = [];

  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(const FetchCategoriesRequested());
  }

  void _showError(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // ✅ New: Searchable modal bottom sheet for categories
  void _openCategoryPicker(List<CategoryEntity> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (_, controller) {
            TextEditingController searchController = TextEditingController();
            List<CategoryEntity> filtered = [...categories];

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CupertinoSearchTextField(
                        controller: searchController,
                        onChanged: (val) {
                          setModalState(() {
                            filtered =
                                categories
                                    .where(
                                      (cat) => cat.title.toLowerCase().contains(
                                        val.toLowerCase(),
                                      ),
                                    )
                                    .toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final category = filtered[index];
                          return ListTile(
                            title: Text(category.title),
                            onTap: () {
                              setState(() {
                                _selectedCategoryId = category.id;
                                _selectedCategoryName = category.title;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _handlePublish() {
    // Validate form fields
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      _showError('Please fill in all required fields.');
      return;
    }

    // Image validation
    if (widget.selectedImages.isEmpty) {
      _showError('Please select at least 1 image.');
      return;
    }

    // Condition validation
    if (_selectedCondition == null) {
      _showError('Please select a product condition.');
      return;
    }

    // Category validation
    if (_selectedCategoryId == null) {
      _showError('Please select a product category.');
      return;
    }

    // Location validation
    if (_latitude == null || _longitude == null) {
      _showError('Please select a valid location.');
      return;
    }

    // Start submitting and disable button
    setState(() => _isSubmitting = true);

    // Dispatch Bloc event with correct lat/lng
    context.read<MarketplaceBloc>().add(
      AddProductRequested(
        pictures: widget.selectedImages,
        title: titleController.text.trim(),
        price: priceController.text.trim(),
        condition: _selectedCondition!,
        description: descController.text.trim(),
        category: _selectedCategoryId!,
        lat: _latitude!.toString(),
        lng: _longitude!.toString(),
      ),
    );
  }

  Future<void> _handleLocationInput() async {
    final hasPermission = await LocationUtils.requestLocationPermission();
    if (!hasPermission) {
      await LocationUtils.showLocationDeniedDialog(context);
      return;
    }

    await CustomModal.show(
      context: context,
      title: 'Location',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Use current location'),
            onTap: () async {
              Navigator.pop(context);
              setState(() {
                locationController.text = 'Loading...';
              });

              final loc = await LocationUtils.getFormattedLocation();
              if (loc != null) {
                final parts = loc.split(',');
                if (parts.length == 2) {
                  final lat = double.tryParse(parts[0].trim());
                  final lng = double.tryParse(parts[1].trim());

                  if (lat != null && lng != null) {
                    final placeName = await LocationUtils.getReadableLocation(
                      lat,
                      lng,
                    );
                    setState(() {
                      _latitude = lat;
                      _longitude = lng;
                      locationController.text =
                          (placeName != null && placeName.isNotEmpty)
                              ? placeName
                              : 'Unknown location';
                    });
                    return;
                  }
                }
              }

              setState(() {
                _latitude = null;
                _longitude = null;
                locationController.text = 'Unknown location';
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_location_alt),
            title: const Text(
              'Type manually (lat,lng)',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () async {
              Navigator.pop(context);

              final controller = TextEditingController();
              final entered = await showDialog<String>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Enter Coordinates'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter latitude,longitude',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(context).pop(controller.text),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );

              if (entered != null && entered.contains(',')) {
                final parts = entered.split(',');
                final lat = double.tryParse(parts[0].trim());
                final lng = double.tryParse(parts[1].trim());

                if (lat != null && lng != null) {
                  final place = await LocationUtils.getReadableLocation(
                    lat,
                    lng,
                  );
                  setState(() {
                    _latitude = lat;
                    _longitude = lng;
                    locationController.text =
                        (place != null && place.isNotEmpty)
                            ? place
                            : 'Lat: $lat, Lng: $lng';
                  });
                } else {
                  _showError('Invalid coordinates entered.');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketplaceBloc, MarketplaceState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          setState(() => _isSubmitting = false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/marketplace',
            (route) => route.isFirst,
          );
        } else if (state is MarketplaceFailure) {
          setState(() => _isSubmitting = false);
          _showError(state.error);
        } else if (state is CategoriesLoaded) {
          setState(() => _categories = state.categories);
        }
      },

      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            children: [
              MediaPickerComponent(onMediaChanged: widget.onMediaChanged),
              const SizedBox(height: 20),

              CustomInputField(
                controller: titleController,
                placeholder: 'Enter Title',
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Title is required'
                            : null,
              ),
              const SizedBox(height: 12),

              CustomInputField(
                controller: priceController,
                placeholder: 'Price',
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Price is required'
                            : null,
              ),
              const SizedBox(height: 20),

              const Text(
                'Condition',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _conditions.map((label) {
                      final isSelected = label == _selectedCondition;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCondition = label),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 20),

              // ✅ Category Dropdown
              const Text(
                'Category',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openCategoryPicker(_categories),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _selectedCategoryName ?? 'Select Category',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CustomInputField(
                controller: descController,
                placeholder: 'Description.....',
                keyboardType: TextInputType.multiline,
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Description is required'
                            : null,
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _handleLocationInput,
                child: AbsorbPointer(
                  child: CustomInputField(
                    controller: locationController,
                    placeholder: 'Location',
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'Location is required'
                                : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isSubmitting ? () {} : _handlePublish,
                text: _isSubmitting ? 'Publishing...' : 'Publish',
                loading: _isSubmitting,
              ),
            ],
          ),
        );
      },
    );
  }
}
