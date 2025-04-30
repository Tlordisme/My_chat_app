import 'package:chat_app/features/conversation/domain/usecases/fetch_conversations_usecase.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationsUsecase fetchConversationsUsecase;
  ConversationBloc({ required this.fetchConversationsUsecase}) : super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
  }

  Future<void> _onFetchConversations(FetchConversations event, Emitter<ConversationState> emit ) async {
    emit(ConversationLoading());
    try{
      final conversations = await fetchConversationsUsecase();
      emit(ConversationLoaded(conversations));
    } catch(e) {
      emit(ConversationError('Failed to load conversation'));
    }
  } 
  
}