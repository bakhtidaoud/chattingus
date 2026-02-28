import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/premium_button.dart';
import '../providers/marketplace_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ListingCreatorScreen extends StatefulWidget {
  const ListingCreatorScreen({super.key});

  @override
  State<ListingCreatorScreen> createState() => _ListingCreatorScreenState();
}

class _ListingCreatorScreenState extends State<ListingCreatorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form State
  String? _selectedCategoryId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _shippingAvailable = false;
  bool _localPickup = true;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppTheme.primaryIndigo
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentStep = page),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryStep(),
                _buildDetailsStep(),
                _buildShippingStep(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pageController.previousPage(
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.white10),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: PremiumButton(
                    text: _currentStep == 2 ? 'Post Listing' : 'Continue',
                    onPressed: () {
                      if (_currentStep < 2) {
                        _pageController.nextPage(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStep() {
    return Consumer(
      builder: (context, ref, child) {
        final categoriesAsync = ref.watch(categoriesProvider);
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What are you selling?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the category that fits your item best.',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: categoriesAsync.when(
                  data: (categories) => ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = _selectedCategoryId == cat.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () =>
                              setState(() => _selectedCategoryId = cat.id),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryIndigo.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryIndigo
                                    : Colors.white10,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.primaryIndigo,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          const Text(
            'Photo Gallery',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPhotoPicker(),
          const SizedBox(height: 32),
          GlassTextField(
            controller: _titleController,
            hintText: 'Listing Title',
            prefixIcon: Icons.title,
          ),
          const SizedBox(height: 16),
          GlassTextField(
            controller: _priceController,
            hintText: 'Price',
            prefixIcon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          GlassTextField(
            controller: _descriptionController,
            hintText: 'Description',
            prefixIcon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.add_a_photo_outlined, color: Colors.white24),
        ),
      ],
    );
  }

  Widget _buildShippingStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Options',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildDeliveryTile(
            'Local Pickup',
            'Meet in person for the exchange.',
            Icons.location_on_outlined,
            _localPickup,
            (v) => setState(() => _localPickup = v!),
          ),
          const SizedBox(height: 16),
          _buildDeliveryTile(
            'Shipping Available',
            'You will ship the item to the buyer.',
            Icons.local_shipping_outlined,
            _shippingAvailable,
            (v) => setState(() => _shippingAvailable = v!),
          ),
          const SizedBox(height: 32),
          const Text(
            'Promote Listing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Feature this listing for 7 days',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (v) {},
                  activeColor: Colors.amber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTile(
    String title,
    String sub,
    IconData icon,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          sub,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
        secondary: Icon(icon, color: AppTheme.primaryIndigo),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryIndigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
