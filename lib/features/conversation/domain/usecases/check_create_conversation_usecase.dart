import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';

class CheckCreateConversationUsecase {
  final ConversationRepository conversationRepository;

  CheckCreateConversationUsecase({required this.conversationRepository});

  Future<String> call({required String contactId}) async {
    return conversationRepository.CheckOrCreateConversation(contactId: contactId);
  }
}