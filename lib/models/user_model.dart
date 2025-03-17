import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final Timestamp timestamp;

  UserModel({
    this.id,
    required this.email,
    Timestamp? timestamp,
  }) : timestamp = timestamp ?? Timestamp.now();

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'timestamp': timestamp,
    };
  }

  // Create UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
