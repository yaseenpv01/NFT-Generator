import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nft_generator/screens/home_screen.dart';
import 'package:nft_generator/screens/nft_generator_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const NFTGeneratorApp());
}

class NFTCategory {
  final String name;
  final double basePrice;
  final List<String> keywords;
  final String imagePrefix;

  const NFTCategory({
    required this.name,
    required this.basePrice,
    required this.keywords,
    required this.imagePrefix,
  });
}

class NFTGeneratorApp extends StatelessWidget {
  const NFTGeneratorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFT Generator Pro',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.purple,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}


