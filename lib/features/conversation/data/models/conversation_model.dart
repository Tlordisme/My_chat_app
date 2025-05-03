import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';


class ConversationModel extends ConversationEntity {
  ConversationModel({
    required String id,
    required bool isGroup,
    String? groupName,
    required List<String> participants,
    required String lastMessage,
    required DateTime? lastMessageTime,
  }) : super(
         id: id,
         isGroup: isGroup,
         groupName: groupName,
         participants: participants,
         lastMessage: lastMessage,
         lastMessageTime: lastMessageTime,
       );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    print("Received JSON: $json");
    return ConversationModel(
      id: json['conversation_id'],
      isGroup: json['is_group'] ?? false,
      groupName: json['group_name'],
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] != null
        ? DateTime.parse(json['last_message_time']).toLocal()
        : null,
    );
  }
}
