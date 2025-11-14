import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils/constants.dart';

/// Voice input widget for search and messages
class VoiceInputWidget extends StatefulWidget {
  final Function(String) onTextReceived;
  final String? hint;
  final Color? primaryColor;
  final bool showWaveform;

  const VoiceInputWidget({
    super.key,
    required this.onTextReceived,
    this.hint,
    this.primaryColor,
    this.showWaveform = true,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isListening = false;
  bool _isAvailable = false;
  String _text = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeSpeech() async {
    _isAvailable = await _speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_isAvailable) return;

    setState(() {
      _isListening = true;
      _text = '';
    });

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
          _confidence = result.confidence;
        });
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      cancelOnError: true,
      onSoundLevelChange: (level) {
        // Can be used for visual feedback
      },
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });

    _animationController.reverse();
    _pulseController.stop();
    _pulseController.reset();

    if (_text.isNotEmpty && _confidence > 0.5) {
      widget.onTextReceived(_text);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening && widget.showWaveform) ...[
          const VoiceWaveformWidget(),
          const SizedBox(height: AppSpacing.md),
        ],

        // Voice input button
        GestureDetector(
          onTapDown: (_) => _startListening(),
          onTapUp: (_) => _stopListening(),
          onTapCancel: () => _stopListening(),
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening 
                    ? _scaleAnimation.value * _pulseAnimation.value
                    : _scaleAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isListening 
                        ? (widget.primaryColor ?? AppColors.primaryGreen)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: _isListening ? [
                      BoxShadow(
                        color: (widget.primaryColor ?? AppColors.primaryGreen)
                            .withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 40,
                    color: _isListening ? Colors.white : Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Status text
        Text(
          _isListening 
              ? 'Listening...'
              : widget.hint ?? 'Hold to speak',
          style: AppTextStyles.bodyMedium.copyWith(
            color: _isListening 
                ? (widget.primaryColor ?? AppColors.primaryGreen)
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        if (_text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Column(
              children: [
                Text(
                  _text,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (_confidence > 0)
                  Text(
                    'Confidence: ${(_confidence * 100).toInt()}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],

        if (!_isAvailable) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Speech recognition not available',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.errorRed,
            ),
          ),
        ],
      ],
    );
  }
}

/// Waveform visualization during voice input
class VoiceWaveformWidget extends StatefulWidget {
  const VoiceWaveformWidget({super.key});

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) => 
        AnimationController(
          duration: Duration(milliseconds: 300 + (index * 100)),
          vsync: this,
        )
    );

    _animations = _controllers.map((controller) => 
        Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        )
    ).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 30 * _animations[index].value,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Voice search field with voice input button
class VoiceSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSearch;
  final Function(String)? onVoiceResult;

  const VoiceSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onVoiceResult,
  });

  @override
  State<VoiceSearchField> createState() => _VoiceSearchFieldState();
}

class _VoiceSearchFieldState extends State<VoiceSearchField> {
  bool _showVoiceInput = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {});
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      _showVoiceInput ? Icons.keyboard : Icons.mic,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _showVoiceInput = !_showVoiceInput;
                      });
                    },
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            onSubmitted: widget.onSearch,
            onChanged: (_) => setState(() {}),
          ),
        ),
        
        if (_showVoiceInput) ...[
          const SizedBox(height: AppSpacing.md),
          VoiceInputWidget(
            onTextReceived: (text) {
              widget.controller.text = text;
              setState(() {
                _showVoiceInput = false;
              });
              widget.onVoiceResult?.call(text);
              widget.onSearch?.call(text);
            },
            hint: 'Speak your search query',
            showWaveform: true,
          ),
        ],
      ],
    );
  }
}