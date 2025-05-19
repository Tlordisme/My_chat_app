import 'dart:io';

import 'package:chat_app/features/message/domain/entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchMessages(String conversationId);
  Future<void> sendMessage(MessageEntity message);
  Future<MessageEntity> uploadMediaMessage({
    required conversationId,
    required String senderId,
    required String content,
    required File file,
  });
}
