import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cluster_provider.dart';
import '../../utils/constants.dart';

class CreateClusterScreen extends StatefulWidget {
  const CreateClusterScreen({super.key});

  @override
  State<CreateClusterScreen> createState() => _CreateClusterScreenState();
}

class _CreateClusterScreenState extends State<CreateClusterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _operatingHoursController = TextEditingController(text: '6AM - 10PM');
  
  final List<String> _serviceAreas = [];
  final _serviceAreaController = TextEditingController();
  
  final List<String> _selectedVehicleTypes = ['motorcycle'];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Rider Cluster'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Rider Cluster',
                    style: AppTextStyles.heading3,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Form a group with other riders to get more orders and share resources.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Cluster Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Cluster Name',
                hintText: 'e.g., Kano Central Riders',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter cluster name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Location
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Sabon Gari, Kano',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Operating Hours
            TextFormField(
              controller: _operatingHoursController,
              decoration: const InputDecoration(
                labelText: 'Operating Hours',
                hintText: 'e.g., 6AM - 10PM',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Service Areas
            const Text('Service Areas', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: _serviceAreas.map((area) {
                return Chip(
                  label: Text(area),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _serviceAreas.remove(area);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _serviceAreaController,
                    decoration: const InputDecoration(
                      hintText: 'Add service area',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () {
                    if (_serviceAreaController.text.trim().isNotEmpty) {
                      setState(() {
                        _serviceAreas.add(_serviceAreaController.text.trim());
                        _serviceAreaController.clear();
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Vehicle Types
            const Text('Vehicle Types', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              title: const Text('Motorcycle (Okada)'),
              value: _selectedVehicleTypes.contains('motorcycle'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVehicleTypes.add('motorcycle');
                  } else {
                    _selectedVehicleTypes.remove('motorcycle');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Bicycle'),
              value: _selectedVehicleTypes.contains('bicycle'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVehicleTypes.add('bicycle');
                  } else {
                    _selectedVehicleTypes.remove('bicycle');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Car'),
              value: _selectedVehicleTypes.contains('car'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVehicleTypes.add('car');
                  } else {
                    _selectedVehicleTypes.remove('car');
                  }
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _createCluster,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Create Cluster'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCluster() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_serviceAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one service area'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final cluster = await context.read<ClusterProvider>().createCluster(
        name: _nameController.text.trim(),
        location: {
          'address': _addressController.text.trim(),
        },
        serviceAreas: _serviceAreas,
        vehicleTypes: _selectedVehicleTypes,
        operatingHours: _operatingHoursController.text.trim(),
      );

      if (cluster != null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cluster "${cluster.name}" created successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create cluster. Please try again.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _operatingHoursController.dispose();
    _serviceAreaController.dispose();
    super.dispose();
  }
}
