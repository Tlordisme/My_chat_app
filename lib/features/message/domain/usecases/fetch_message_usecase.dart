import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:chat_app/features/message/domain/repositories/message_repository.dart';

class FetchMessageUsecase {
  final MessageRepository messageRepository;
  FetchMessageUsecase({required this.messageRepository});

  Future<List<MessageEntity>> call(String conversationId) async {
    return await messageRepository.fetchMessages(conversationId);
  }
}