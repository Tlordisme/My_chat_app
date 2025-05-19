import 'dart:io';

import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class UploadMediaUsecase {
  final MessageRepository messageRepository;

  UploadMediaUsecase({required this.messageRepository});

  Future<MessageEntity> call({
    required String conversationId,
    required String senderId,
    required String content,
    required File file,
  }) async {
    return await messageRepository.uploadMediaMessage(
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      file: file,
    );
  }
}
