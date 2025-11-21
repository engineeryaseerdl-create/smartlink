import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/constants.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryGreen),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            selectedBorderColor: AppColors.primaryGreen,
            selectedColor: Colors.white,
            fillColor: AppColors.primaryGreen,
            color: AppColors.primaryGreen,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 32),
            isSelected: [
              languageProvider.currentLanguage == 'en',
              languageProvider.currentLanguage == 'ha',
            ],
            onPressed: (index) {
              languageProvider.setLanguage(index == 0 ? 'en' : 'ha');
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('EN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('HA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
