import 'dart:typed_data';

class NFTItem {
  final String title;
  final double price;
  final Uint8List image;
  final DateTime dateCreated;

  NFTItem({
    required this.title,
    required this.price,
    required this.image,
    required this.dateCreated,
  });
}