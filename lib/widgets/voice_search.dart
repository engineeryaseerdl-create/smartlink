import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/constants.dart';

class VoiceSearchButton extends StatefulWidget {
  final Function(String) onResult;

  const VoiceSearchButton({super.key, required this.onResult});

  @override
  State<VoiceSearchButton> createState() => _VoiceSearchButtonState();
}

class _VoiceSearchButtonState extends State<VoiceSearchButton>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _animationController.repeat();
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              widget.onResult(result.recognizedWords);
              _stopListening();
            }
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _animationController.stop();
    _speech.stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startListening,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isListening ? AppColors.primaryGreen : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              boxShadow: _isListening ? [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  blurRadius: 10 * _animationController.value,
                  spreadRadius: 2 * _animationController.value,
                ),
              ] : null,
            ),
            child: Icon(
              Icons.mic,
              color: _isListening ? Colors.white : AppColors.textSecondary,
              size: 18,
            ),
          );
        },
      ),
    );
  }
}