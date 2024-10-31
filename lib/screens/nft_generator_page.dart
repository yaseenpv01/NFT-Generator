import 'dart:math';

import 'package:flutter/material.dart';

import '../main.dart';

class NFTGeneratorPage extends StatefulWidget {
  const NFTGeneratorPage({Key? key}) : super(key: key);

  @override
  _NFTGeneratorPageState createState() => _NFTGeneratorPageState();
}

class _NFTGeneratorPageState extends State<NFTGeneratorPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isGenerating = false;
  String? _generatedImageUrl;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentPrice = 0.05;
  String _selectedCategory = 'Art';
  String _selectedRarity = 'Common';

  // NFT Categories with base prices and relevant keywords
  final Map<String, NFTCategory> _categories = {
    'Art': NFTCategory(
      name: 'Art',
      basePrice: 0.05,
      keywords: ['painting', 'abstract', 'canvas', 'artistic'],
      imagePrefix: 'art',
    ),
    'Gaming': NFTCategory(
      name: 'Gaming',
      basePrice: 0.08,
      keywords: ['game', 'pixel', 'character', 'console'],
      imagePrefix: 'game',
    ),
    'Music': NFTCategory(
      name: 'Music',
      basePrice: 0.07,
      keywords: ['music', 'audio', 'sound', 'rhythm'],
      imagePrefix: 'music',
    ),
    'Sports': NFTCategory(
      name: 'Sports',
      basePrice: 0.06,
      keywords: ['sports', 'athlete', 'game', 'competition'],
      imagePrefix: 'sports',
    ),
    'Collectibles': NFTCategory(
      name: 'Collectibles',
      basePrice: 0.1,
      keywords: ['rare', 'unique', 'collection', 'vintage'],
      imagePrefix: 'collectible',
    ),
  };

  final Map<String, double> _rarityMultipliers = {
    'Common': 1.0,
    'Uncommon': 1.5,
    'Rare': 2.0,
    'Epic': 3.0,
    'Legendary': 5.0,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _nameController.addListener(_updatePrice);
  }

  void _updatePrice() {
    final basePrice = _categories[_selectedCategory]!.basePrice;
    final rarityMultiplier = _rarityMultipliers[_selectedRarity]!;
    final complexityMultiplier = 1.0 + (_nameController.text.length / 20); // Longer names = higher price

    setState(() {
      _currentPrice = (basePrice * rarityMultiplier * complexityMultiplier).clamp(0.05, 10.0);
    });
  }

  Future<String> _getImageUrl() async {
    final category = _categories[_selectedCategory]!;
    final keywords = category.keywords;
    final seed = (_nameController.text + _selectedRarity).hashCode.abs();

    // In a real app, you would use an AI API here. For demo, using themed placeholder images
    return 'https://picsum.photos/seed/$seed/400';
  }

  Future<void> _generateNFT() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
      _generatedImageUrl = null;
    });

    try {
      final imageUrl = await _getImageUrl();

      // Simulate processing time
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _generatedImageUrl = imageUrl;
        _isGenerating = false;
      });
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Generator Pro'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'NFT Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.create),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.category),
                        ),
                        items: _categories.keys.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                              _updatePrice();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRarity,
                        decoration: InputDecoration(
                          labelText: 'Rarity',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.stars),
                        ),
                        items: _rarityMultipliers.keys.map((String rarity) {
                          return DropdownMenuItem(
                            value: rarity,
                            child: Text(rarity),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedRarity = newValue;
                              _updatePrice();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Estimated Price:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${_currentPrice.toStringAsFixed(3)} ETH',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isGenerating ? null : _generateNFT,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isGenerating
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : Text('Generate NFT (${_currentPrice.toStringAsFixed(3)} ETH)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_generatedImageUrl != null) ...[
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _animation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _generatedImageUrl!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _nameController.text,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _descriptionController.text,
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoCard('Category', _selectedCategory),
                            _buildInfoCard('Rarity', _selectedRarity),
                            _buildInfoCard('Price', '${_currentPrice.toStringAsFixed(3)} ETH'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      color: Colors.purple.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}