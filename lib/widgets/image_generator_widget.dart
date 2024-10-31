import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

import '../service/image_generator_service.dart';

class ImageGeneratorWidget extends StatefulWidget {
  final Function(Uint8List) onImageGenerated;

  const ImageGeneratorWidget({
    Key? key,
    required this.onImageGenerated,
  }) : super(key: key);

  @override
  State<ImageGeneratorWidget> createState() => _ImageGeneratorWidgetState();
}

class _ImageGeneratorWidgetState extends State<ImageGeneratorWidget> {
  final TextEditingController _promptController = TextEditingController();
  ImageAIStyle selectedStyle = ImageAIStyle.noStyle;
  bool isGenerating = false;

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt')),
      );
      return;
    }

    setState(() => isGenerating = true);

    try {
      final image = await ImageGeneratorService.generateImage(
        prompt: _promptController.text,
        style: selectedStyle,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );

      widget.onImageGenerated(image);
    } finally {
      setState(() => isGenerating = false);
    }
  }

  String _getStyleDisplayName(ImageAIStyle style) {
    return ImageGeneratorService.imageStyles[style] ?? 'Unknown Style';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Generate Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt',
                border: OutlineInputBorder(),
                helperText: 'Be descriptive for better results',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ImageAIStyle>(
              value: selectedStyle,
              decoration: const InputDecoration(
                labelText: 'Select Style',
                border: OutlineInputBorder(),
              ),
              items: ImageGeneratorService.imageStyles.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedStyle = value);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isGenerating ? null : _generateImage,
              icon: isGenerating
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.image),
              label: Text(isGenerating ? 'Generating...' : 'Generate Image'),
            ),
          ],
        ),
      ),
    );
  }
}