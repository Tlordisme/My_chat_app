abstract class MessageEvent {}

class LoadMessageEvent extends MessageEvent {
  final String conversationId;
  LoadMessageEvent(this.conversationId);
}

class SendMessageEvent extends MessageEvent {
  final String conversationId;
  final String content;
  SendMessageEvent( this.conversationId, this.content);

}


class ReceiveMessageEvent extends MessageEvent {
  final Map<String,dynamic> message;
  ReceiveMessageEvent(this.message);
}