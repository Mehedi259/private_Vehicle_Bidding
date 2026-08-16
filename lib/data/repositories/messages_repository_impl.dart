import 'package:flutter/material.dart';
import '../../core/interfaces/i_messages_repository.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class MessagesRepositoryImpl implements IMessagesRepository {
  final List<ConversationModel> _conversations = [
    const ConversationModel(
      id: '1',
      name: 'John Doe',
      initials: 'JD',
      lastMessage: '"2pm works great! Looking forward to it."',
      time: '2m',
      unreadCount: 2,
      isAiActive: false,
      leadStatus: 'hot',
      score: 0.87,
      avatarColor: Color(0xFFEF4444),
    ),
    const ConversationModel(
      id: '2',
      name: 'Amy Lin',
      initials: 'AL',
      lastMessage: '"Can you send me more information about pricing?"',
      time: '20m',
      unreadCount: 1,
      isAiActive: true,
      leadStatus: 'hot',
      score: 0.72,
      avatarColor: Color(0xFFF97316),
    ),
    const ConversationModel(
      id: '3',
      name: 'Sarah Mitchell',
      initials: 'SM',
      lastMessage: '"What packages do you have available?"',
      time: '2h',
      unreadCount: 0,
      isAiActive: true,
      leadStatus: 'warm',
      score: 0.55,
      avatarColor: Color(0xFFF59E0B),
    ),
    const ConversationModel(
      id: '4',
      name: 'Tom Kim',
      initials: 'TK',
      lastMessage: '"Sounds good, let\'s chat next week"',
      time: '3h',
      unreadCount: 0,
      isAiActive: false,
      leadStatus: 'warm',
      score: 0.48,
      avatarColor: Color(0xFFD97706),
    ),
    const ConversationModel(
      id: '5',
      name: 'Robert Park',
      initials: 'RP',
      lastMessage: '"Not sure yet, I\'ll think about it"',
      time: '1d',
      unreadCount: 0,
      isAiActive: false,
      leadStatus: 'cold',
      score: 0.30,
      avatarColor: Color(0xFFF97316),
    ),
    const ConversationModel(
      id: '6',
      name: 'Maria Brown',
      initials: 'MB',
      lastMessage: '"Just browsing, thanks"',
      time: '2d',
      unreadCount: 0,
      isAiActive: true,
      leadStatus: 'cold',
      score: 0.20,
      avatarColor: Color(0xFF2563EB),
    ),
  ];

  final Map<String, List<MessageModel>> _messages = {
    '1': [
      const MessageModel(
        id: 'm1',
        text: "Hey, I'm interested in your premium plan. Can we schedule a call?",
        time: '10:23 AM',
        isMe: false,
        senderName: 'John Doe',
      ),
      const MessageModel(
        id: 'm2',
        text: "Hi John! I'd love to chat. I'm available tomorrow at 2pm or 4pm EST. Which works for you?",
        time: '10:24 AM',
        isMe: true,
        isSentByAi: true,
      ),
      const MessageModel(
        id: 'm3',
        text: '2pm works great! Looking forward to it.',
        time: '10:31 AM',
        isMe: false,
        senderName: 'John Doe',
      ),
      const MessageModel(
        id: 'm4',
        text: "Perfect! I'll send you a calendar invite. Can I get your email address?",
        time: '10:32 AM',
        isMe: true,
        isSentByAi: false,
      ),
      const MessageModel(
        id: 'm5',
        text: "Sure! It's john.doe@example.com",
        time: '10:35 AM',
        isMe: false,
        senderName: 'John Doe',
      ),
    ],
  };

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_conversations);
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _messages[conversationId] ?? [];
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final messages = _messages.putIfAbsent(conversationId, () => []);
    messages.add(MessageModel(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      time: _formatCurrentTime(),
      isMe: true,
      isSentByAi: false,
    ));
  }

  @override
  Future<void> toggleAiAutoReply(String conversationId, bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
