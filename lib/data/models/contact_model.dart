import 'package:flutter/material.dart';

class ContactModel {
  final String id;
  final String name;
  final String initials;
  final String phone;
  final String email;
  final String status; // 'Active', 'New', 'No Reply'
  final Color avatarColor;
  final Color statusColor;
  final String? imagePath;

  const ContactModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.phone,
    required this.email,
    required this.status,
    required this.avatarColor,
    required this.statusColor,
    this.imagePath,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? initials,
    String? phone,
    String? email,
    String? status,
    Color? avatarColor,
    Color? statusColor,
    String? imagePath,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      avatarColor: avatarColor ?? this.avatarColor,
      statusColor: statusColor ?? this.statusColor,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
