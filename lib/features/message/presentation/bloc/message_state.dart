import 'package:chat_app/features/message/domain/entities/message_entity.dart';

abstract class MessageState {}

class MessageLoadedState extends MessageState {
  final List<MessageEntity> message;
  MessageLoadedState(this.message);
}

class MessageLoadingState extends MessageState {}

class MessageErrorState extends MessageState {
  final String message;
  MessageErrorState(this.message);
}
