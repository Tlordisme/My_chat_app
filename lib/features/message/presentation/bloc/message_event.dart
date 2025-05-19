import 'dart:io';


abstract class MessageEvent {}

class LoadMessageEvent extends MessageEvent {
  final String conversationId;
  LoadMessageEvent(this.conversationId);
}

class SendMessageEvent extends MessageEvent {
  final String conversationId;
  final String content;
  SendMessageEvent(this.conversationId, this.content);
}

class ReceiveMessageEvent extends MessageEvent {
  final Map<String, dynamic> message;
  ReceiveMessageEvent(this.message);
}

class SendMediaMessageEvent extends MessageEvent {
  final String conversationId;
  final String senderId;
  final String content;
  final File file;
  SendMediaMessageEvent({
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.file,
  });
}
