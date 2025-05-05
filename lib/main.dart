import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_source.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repo_implementation.dart';
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app/features/contact/data/datasource/contact_remote_source.dart';
import 'package:chat_app/features/contact/data/repositories/contact_repo_implementation.dart';
import 'package:chat_app/features/contact/domain/usecases/add_contact_usecase.dart';
import 'package:chat_app/features/contact/domain/usecases/fetch_contacts_usecase.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chat_app/features/conversation/data/datasource/conversation_remote_source.dart';
import 'package:chat_app/features/conversation/data/repositories/conversation_repo_implementation.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_conversations_usecase.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/pages/conversation_page.dart';
import 'package:chat_app/features/message/data/datasource/message_remote_source.dart';
import 'package:chat_app/features/message/data/repositories/message_repo_implementation.dart';
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
  final contactRepository = ContactRepoImplementation(
    contactRemoteSource: ContactRemoteSource(),
  );
  runApp(
    MyApp(
      authRepository: authRepository,
      conversationRepository: conversationRepository,
      messageRepository: messageRepository,
      contactRepository: contactRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepoImplementation authRepository;
  final ConversationRepoImplementation conversationRepository;
  final MessageRepoImplementation messageRepository;
  final ContactRepoImplementation contactRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationRepository,
    required this.messageRepository,
    required this.contactRepository,
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
                  conversationRepository,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => MessageBloc(
                fetchMessageUsecase: FetchMessageUsecase(
                  messageRepository: messageRepository,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => ContactBloc(
                fetchContactsUsecase: FetchContactsUsecase(contactRepository: contactRepository), 
                addContactUsecase: AddContactUsecase(contactRepository: contactRepository),
                
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
