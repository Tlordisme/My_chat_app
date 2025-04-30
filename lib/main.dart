import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_source.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repo_implementation.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app/features/conversation/data/datasource/conversation_remote_source.dart';
import 'package:chat_app/features/conversation/data/repositories/conversation_repo_implementation.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_conversations_usecase.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/pages/conversation_page.dart';
import 'package:chat_app/features/message/data/datasource/message_remote_source.dart';
import 'package:chat_app/features/message/data/repositories/message_repo_implementation.dart';
import 'package:chat_app/features/message/domain/repositories/message_repository.dart';
import 'package:chat_app/features/message/domain/usecases/fetch_message_usecase.dart';
import 'package:chat_app/features/message/presentation/bloc/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepoImplementation(
    authRemoteSource: AuthRemoteSource(),
  );
  final conversationRepository = ConversationRepoImplementation(
    conversationRemoteSource: ConversationRemoteSource(),
  );
  final messageRepository = MessageRepoImplementation(
    messageRemoteSource: MessageRemoteSource(),
  );
  runApp(
    MyApp(
      authRepository: authRepository,
      conversationRepository: conversationRepository,
      messageRepository: messageRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ConversationRepository conversationRepository;
  final MessageRepository messageRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationRepository,
    required this.messageRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                registerUsecase: RegisterUsecase(repository: authRepository),
                loginUsecase: LoginUsecase(repository: authRepository),
                verifyOtpUsecase: VerifyOtpUsecase(repository: authRepository),
              ),
        ),
        BlocProvider(
          create:
              (_) => ConversationBloc(
                fetchConversationsUsecase: FetchConversationsUsecase(
                  conversationRepository
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => MessageBloc(
                fetchMessageUsecase: FetchMessageUsecase(
                  messageRepository : messageRepository
                ),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/conversationPage': (_) => ConversationPage(),
        },
      ),
    );
  }
}
