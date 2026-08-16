import 'package:flutter/material.dart';

class ConversationModel {
  final String id;
  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isAiActive;
  final String leadStatus; // 'hot', 'warm', 'cold'
  final double score; // 0.0 to 1.0
  final Color avatarColor;

  const ConversationModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isAiActive = false,
    this.leadStatus = 'cold',
    this.score = 0.0,
    required this.avatarColor,
  });

  Color get borderColor {
    switch (leadStatus) {
      case 'hot':
        return const Color(0xFFEF4444);
      case 'warm':
        return const Color(0xFFF59E0B);
      case 'cold':
      default:
        return const Color(0xFF2563EB);
    }
  }
}
