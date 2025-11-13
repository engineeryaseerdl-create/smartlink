import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _bvnController = TextEditingController();
  final _ninController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  File? _idCardFront;
  File? _idCardBack;
  File? _selfieImage;
  String _selectedIdType = 'National ID';
  bool _isLoading = false;

  final List<String> _idTypes = [
    'National ID',
    'Driver\'s License',
    'International Passport',
    'Voter\'s Card'
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _bvnController.dispose();
    _ninController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String imageType) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $imageType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _pickImageFromSource(ImageSource.camera, imageType),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImageFromSource(ImageSource.gallery, imageType),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source, String imageType) async {
    Navigator.pop(context);
    
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          switch (imageType) {
            case 'ID Card Front':
              _idCardFront = File(image.path);
              break;
            case 'ID Card Back':
              _idCardBack = File(image.path);
              break;
            case 'Selfie':
              _selfieImage = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  Widget _buildImageUploadCard(String title, String description, File? image, String imageType) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkCard 
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: image != null 
              ? AppColors.successGreen.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                image != null ? Icons.check_circle : Icons.upload_file,
                color: image != null ? AppColors.successGreen : Colors.grey,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (image != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              child: Image.file(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _pickImage(imageType),
              style: ElevatedButton.styleFrom(
                backgroundColor: image != null ? AppColors.successGreen : AppColors.primaryGreen,
                foregroundColor: AppColors.white,
              ),
              child: Text(image != null ? 'Change Image' : 'Upload Image'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitKYC() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_idCardFront == null || _idCardBack == null || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would upload documents to server and submit for verification
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('KYC documents submitted successfully! Verification may take 24-48 hours.'),
            backgroundColor: AppColors.successGreen,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting KYC: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: AppColors.infoBlue),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Identity Verification',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.infoBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'To ensure the security of all users, we require identity verification for all accounts. This process helps us build trust in our community.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Personal Information
              const Text('Personal Information', style: AppTextStyles.heading3),
              const SizedBox(height: AppSpacing.md),
              
              CustomTextField(
                label: 'Full Name (as on ID)',
                hint: 'Enter your full legal name',
                controller: _fullNameController,
                validator: (value) => value?.isEmpty == true ? 'Full name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _bvnController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'BVN (Optional)',
                  hintText: 'Enter your Bank Verification Number',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkCard 
                      : AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _ninController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'NIN (Optional)',
                  hintText: 'Enter your National Identification Number',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkCard 
                      : AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              CustomTextField(
                label: 'Residential Address',
                hint: 'Enter your full address',
                controller: _addressController,
                maxLines: 2,
                validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // ID Type Selection
              Text('ID Document Type', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _selectedIdType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkCard 
                      : AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _idTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedIdType = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Document Upload
              const Text('Document Upload', style: AppTextStyles.heading3),
              const SizedBox(height: AppSpacing.md),
              
              _buildImageUploadCard(
                'ID Document (Front)',
                'Upload clear photo of the front of your $_selectedIdType',
                _idCardFront,
                'ID Card Front',
              ),
              const SizedBox(height: AppSpacing.md),
              
              _buildImageUploadCard(
                'ID Document (Back)',
                'Upload clear photo of the back of your $_selectedIdType',
                _idCardBack,
                'ID Card Back',
              ),
              const SizedBox(height: AppSpacing.md),
              
              _buildImageUploadCard(
                'Selfie Verification',
                'Take a clear selfie holding your ID document',
                _selfieImage,
                'Selfie',
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              CustomButton(
                text: _isLoading ? 'Submitting...' : 'Submit for Verification',
                onPressed: _isLoading ? null : () => _submitKYC(),
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.md),
              
              const Text(
                'By submitting these documents, you agree to our verification process. Your documents will be securely stored and used only for identity verification purposes.',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}