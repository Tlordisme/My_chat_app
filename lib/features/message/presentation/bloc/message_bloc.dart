import 'dart:async';
import 'package:chat_app/core/socket_service.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:chat_app/features/message/domain/usecases/fetch_message_usecase.dart';
import 'package:chat_app/features/message/domain/usecases/upload_media_usecase.dart';
//  import 'package:chat_app/features/message/domain/usecases/upload_media_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FetchMessageUsecase fetchMessageUsecase;
  final UploadMediaUsecase uploadMediaUsecase;
  final _storage = FlutterSecureStorage();
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];

  MessageBloc({
    required this.fetchMessageUsecase,
    required this.uploadMediaUsecase,
  }) : super(MessageLoadingState()) {
    on<LoadMessageEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessages);
    on<SendMediaMessageEvent>(_onSendMediaMessage);
  }

  FutureOr<void> _onLoadMessages(
    LoadMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoadingState());
    try {
      final messages = await fetchMessageUsecase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);

      emit(MessageLoadedState(List.from(_messages)));

      _socketService.socket.emit('joinConversation', event.conversationId);

      _socketService.socket.off('newMessage');

      _socketService.socket.on('newMessage', (data) {
        print("Received new message: $data");
        add(ReceiveMessageEvent(data));
      });
    } catch (err) {
      emit(MessageErrorState('Failed load message'));
    }
  }

  FutureOr<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    String userId = await _storage.read(key: 'userId') ?? '';
    print('userId: $userId');
    final newMessage = {
      'conversationId': event.conversationId,
      'senderId': userId,
      'content': event.content,
    };
    if (_socketService.socket.connected) {
      print('Emitting message: $newMessage');
      _socketService.socket.emit('sendMessage', newMessage);
    } else {
      print('Socket not connected!');
    }
  }

  FutureOr<void> _onReceiveMessages(
    ReceiveMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    print('Receive message: ');
    print(event.message);
    final message = MessageEntity(
      id: event.message['id'],
      conversationId: event.message['conversation_id'],
      senderId: event.message['sender_id'],
      content: event.message['content'],
      mediaUrl: event.message['media_url'],
      createdAt: event.message['created_at'],
    );
    _messages.add(message);
    emit(MessageLoadedState(List.from(_messages)));
  }

  Future<void> _onSendMediaMessage(
    SendMediaMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoadingState());
    print("Uploading Media Message");
    try {
      final uploadedMessage = await uploadMediaUsecase(
        conversationId: event.conversationId,
        senderId: event.senderId,
        content: event.content,
        file: event.file,
      );
      //  const { conversationId, senderId, content , mediaUrl, mediaType} = message;
      final mediaMessage = {
        'conversationId': uploadedMessage.conversationId,
        'senderId': uploadedMessage.senderId,
        'content': uploadedMessage.content,
        'mediaUrl': uploadedMessage.mediaUrl,
        'mediaType': uploadedMessage.mediaType
      };
      if (_socketService.socket.connected) {
        print('Emitting message: $mediaMessage');
        _socketService.socket.emit('sendMessage', mediaMessage);
      } else {
        print('Socket not connected!');
      }

      emit(MessageUploaded(uploadedMessage));
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }
}
