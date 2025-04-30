import 'package:chat_app/features/conversation/data/datasource/conversation_remote_source.dart';
import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationRepoImplementation extends ConversationRepository {
  final ConversationRemoteSource conversationRemoteSource;

  ConversationRepoImplementation({required this.conversationRemoteSource});

  @override
  Future<List<ConversationEntity>> fetchConversations() async {
    // TODO: implement fetchConversations
    return await conversationRemoteSource.fetchConversations();
  }
}
