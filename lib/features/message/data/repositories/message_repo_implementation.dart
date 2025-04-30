import 'package:chat_app/features/message/data/datasource/message_remote_source.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:chat_app/features/message/domain/repositories/message_repository.dart';

class MessageRepoImplementation extends MessageRepository{
  final MessageRemoteSource messageRemoteSource;

  MessageRepoImplementation({required this.messageRemoteSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId)  async {
    // TODO: implement fetchMessages
    return await messageRemoteSource.fetchMessage(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) async {
    throw UnimplementedError();
  }
}