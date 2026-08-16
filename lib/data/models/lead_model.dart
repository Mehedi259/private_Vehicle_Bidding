import 'package:flutter/material.dart';
import 'activity_model.dart';
import 'message_model.dart';

class LeadModel {
  final String id;
  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final String status; // 'hot', 'warm', 'cold'
  final double score; // 0.0 to 1.0
  final Color avatarColor;
  final String email;
  final String phone;
  final String source;
  final String owner;
  final String createdDate;
  final List<ActivityModel> activities;
  final List<MessageModel> messages;
  final List<String> aiSuggestions;
  final List<String> suggestionTags;
  // Stat card fields
  final int messageCount;
  final double responseRate; // 0.0 to 1.0
  final int daysActive;
  // Detail fields
  final String aiInsight;
  final int daysInPipeline;
  final String bestFollowUpTime;

  const LeadModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.score,
    required this.avatarColor,
    required this.email,
    required this.phone,
    required this.source,
    required this.owner,
    required this.createdDate,
    required this.activities,
    required this.messages,
    required this.aiSuggestions,
    this.suggestionTags = const [],
    this.messageCount = 0,
    this.responseRate = 0.0,
    this.daysActive = 0,
    this.aiInsight = '',
    this.daysInPipeline = 0,
    this.bestFollowUpTime = '',
  });

  LeadModel copyWith({
    String? id,
    String? name,
    String? initials,
    String? lastMessage,
    String? time,
    String? status,
    double? score,
    Color? avatarColor,
    String? email,
    String? phone,
    String? source,
    String? owner,
    String? createdDate,
    List<ActivityModel>? activities,
    List<MessageModel>? messages,
    List<String>? aiSuggestions,
    List<String>? suggestionTags,
    int? messageCount,
    double? responseRate,
    int? daysActive,
    String? aiInsight,
    int? daysInPipeline,
    String? bestFollowUpTime,
  }) {
    return LeadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      status: status ?? this.status,
      score: score ?? this.score,
      avatarColor: avatarColor ?? this.avatarColor,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      source: source ?? this.source,
      owner: owner ?? this.owner,
      createdDate: createdDate ?? this.createdDate,
      activities: activities ?? this.activities,
      messages: messages ?? this.messages,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      suggestionTags: suggestionTags ?? this.suggestionTags,
      messageCount: messageCount ?? this.messageCount,
      responseRate: responseRate ?? this.responseRate,
      daysActive: daysActive ?? this.daysActive,
      aiInsight: aiInsight ?? this.aiInsight,
      daysInPipeline: daysInPipeline ?? this.daysInPipeline,
      bestFollowUpTime: bestFollowUpTime ?? this.bestFollowUpTime,
    );
  }

  Color get borderColor {
    switch (status.toLowerCase()) {
      case 'hot':
        return const Color(0xFF26B14E);
      case 'warm':
        return const Color(0xFF3B82F6);
      case 'cold':
      default:
        return const Color(0xFFEF5744);
    }
  }

  List<Color> get avatarGradient {
    switch (status.toLowerCase()) {
      case 'hot':
        return [const Color(0xFF26B14E), const Color(0xFFDEF916)];
      case 'warm':
        return [const Color(0xFF3B82F6), const Color(0xFF60A5FA)];
      case 'cold':
      default:
        return [const Color(0xFFEF5744), const Color(0xFFFF8A80)];
    }
  }
}
