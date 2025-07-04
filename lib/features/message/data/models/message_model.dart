import 'package:chat_app/features/message/domain/entities/message_entity.dart';

// class MessageModel extends MessageEntity {
//   MessageModel({
//     required String id,
//     required String conversationId,
//     required String senderId,
//     required String content,
//     required String createdAt,
//   }) : super(
//          id: id,
//          conversationId: conversationId,
//          senderId: senderId,
//          content: content,
//          createdAt: createdAt,
//        );

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       id: json['id'], 
//       content: json['content'],
//       senderId: json['sender_id'],
//       conversationId: json['conversation_id'] ?? "",
//       createdAt: json['created_at']
//     );
//   }
// }
class MessageModel extends MessageEntity {
  MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    String? mediaUrl,
    String? mediaType,
    required String createdAt,
  }) : super(
          id: id,
          conversationId: conversationId,
          senderId: senderId,
          content: content,
          mediaUrl: mediaUrl,
          mediaType: mediaType,
          createdAt: createdAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      createdAt: json['created_at'],
    );
  }
}