import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';

abstract class IMessagesRepository {
  Future<List<ConversationModel>> getConversations();
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<void> sendMessage(String conversationId, String text);
  Future<void> toggleAiAutoReply(String conversationId, bool enabled);
}
