import 'dart:async';
import 'package:chat_app/core/socket_service.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:chat_app/features/message/domain/usecases/fetch_message_usecase.dart';
import 'package:chat_app/features/message/presentation/bloc/message_event.dart';
import 'package:chat_app/features/message/presentation/bloc/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FetchMessageUsecase fetchMessageUsecase;
  final _storage = FlutterSecureStorage();
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];

  MessageBloc({required this.fetchMessageUsecase})
    : super(MessageLoadingState()) {
    on<LoadMessageEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessages);
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
      createdAt: event.message['created_at'],
    );
    _messages.add(message);
    emit(MessageLoadedState(List.from(_messages)));
  }
}
