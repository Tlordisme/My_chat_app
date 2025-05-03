class ConversationEntity {
  final String id;
  final bool isGroup;
  final String? groupName; 
  final List<String> participants; 
  final String lastMessage;
  final DateTime? lastMessageTime;

  ConversationEntity({
    required this.id,
    required this.isGroup,
    this.groupName,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
  });


  String get displayName {
    if (isGroup) return groupName ?? 'Nhóm không tên';
    return participants.first; 
  }
}
