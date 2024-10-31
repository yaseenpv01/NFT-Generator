import 'dart:typed_data';

import 'package:stability_image_generation/stability_image_generation.dart';

import '../config/api_config.dart';

// lib/services/image_generator_service.dart
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'dart:typed_data';
import '../config/api_config.dart';

class ImageGeneratorService {
  static final StabilityAI _ai = StabilityAI();

  static const Map<ImageAIStyle, String> imageStyles = {
    ImageAIStyle.noStyle: 'Default Style',
    ImageAIStyle.anime: 'Anime',
    ImageAIStyle.digitalPainting: 'Digital Painting',
    ImageAIStyle.render3D: '3D Render',
    ImageAIStyle.cartoon: 'Cartoon',
    ImageAIStyle.oilPainting: 'Oil Painting',
    ImageAIStyle.pencilDrawing: 'Pencil Drawing',
    ImageAIStyle.portraitPhoto: 'Portrait Photo',
    ImageAIStyle.studioPhoto: 'Studio Photo',
  };

  static Future<Uint8List> generateImage({
    required String prompt,
    required ImageAIStyle style,
    required Function(String) onError,
  }) async {
    try {
      /*if (!ApiConfig.hasValidApiKey) {
        throw Exception('API key not configured');
      }*/

      final image = await _ai.generateImage(
        apiKey: ApiConfig.stabilityApiKey,
        imageAIStyle: style,
        prompt: prompt,
        // Optional parameters with correct types
        cfgScale: '7.0',    // String type as per API
        samples: '1',       // String type as per API
        steps: '30',        // String type as per API
      );

      return image;
    } catch (e) {
      onError(e.toString());
      rethrow;
    }
  }
}