import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final double price;
  final String category;
  final double latitude;
  final double longitude;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl'] ?? 'https://unsplash.com',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? 'General',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 37.7749,
      longitude: (data['longitude'] as num?)?.toDouble() ?? -122.4194,
    );
  }
}
