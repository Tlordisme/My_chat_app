import 'dart:io';

import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:chat_app/features/message/presentation/bloc/message_bloc.dart';
import 'package:chat_app/features/message/presentation/bloc/message_event.dart';
import 'package:chat_app/features/message/presentation/bloc/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class MessagePage extends StatefulWidget {
  final String conversationId;
  final String mate;
  const MessagePage({
    super.key,
    required this.conversationId,
    required this.mate,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _storage = FlutterSecureStorage();
  String userId = '';

  //
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessageBloc>(
      context,
    ).add(LoadMessageEvent(widget.conversationId));
    fetchUserId();
  }

  void fetchUserId() async {
    String storedUserId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = storedUserId;
    });
    BlocProvider.of<MessageBloc>(
      context,
    ).add(LoadMessageEvent(widget.conversationId));

    print('+++++++++++++++++++=USER: $userId+++++++++++++++++++++++++++++=');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    print("Sending message: $content");
    if (content.isNotEmpty) {
      BlocProvider.of<MessageBloc>(
        context,
      ).add(SendMessageEvent(widget.conversationId, content));
      _messageController.clear();
    }
  }

  //PickMedia

  void _sendMediaMessage() async {
    List<File> mediaMessage = [];
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null ) {
      
      for (var file in result.files) {
        print("Đang gửi file: ${file.name}");

        BlocProvider.of<MessageBloc>(context).add(
          SendMediaMessageEvent(
            conversationId: widget.conversationId,
            senderId: userId,
            content: '',
            file: File(file.path!),
          ),
        );
      }
    } else {
      print("No file selected.");
    }
  }



  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      // hoặc return CircularProgressIndicator();
      return Scaffold(
        appBar: AppBar(
          title: Text("Đang tải..."),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              // backgroundImage: NetworkImage(
              //   'https://wallpapercave.com/wp/wp3262663.jpg',
              // ),
            ),
            SizedBox(width: 10),
            Text(
              '${widget.mate}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoadingState) {
                  // return Center(child: Text("Ảo thật đấy"));
                  return Center(child: CircularProgressIndicator());
                } else if (state is MessageLoadedState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(20),
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      final message = state.message[index];
                      print(message);
                      final previousMessage =
                          index > 0 ? state.message[index - 1] : null;
                      // final showAvatar = previousMessage?.senderId == userId;
                      final bool showAvatar =
                          previousMessage?.senderId != message.senderId;
                      final isSentMessage = message.senderId == userId;
                      print("senderId: ${message.senderId}, userId: $userId");

                      if (isSentMessage) {
                        print("senderId: ${message.senderId}, userId: $userId");
                        return _buildSendMessage(
                          context,
                          message.content,
                          message.mediaUrl ?? '',
                          showAvatar,
                        );
                      } else {
                        print(
                          "_____________________________-mediaUrl: ${message.mediaUrl}",
                        );
                        return _buildReceivedMessage(
                          context,
                          message.content,
                          message.mediaUrl ?? '',
                          showAvatar,
                        );
                      }
                    },
                  );
                } else if (state is MessageErrorState) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text("No message"));
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(
    BuildContext context,
    String message,
    String mediaUrl,
    bool showAvatar,
  ) {
    print("+++++++++++++++++++++++++++++++-mediaUrl: $mediaUrl");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showAvatar
            ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),
            )
            : SizedBox(width: 32), // giữ khoảng trống để canh lề đúng
        SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                (mediaUrl.isNotEmpty)
                    ? Image.network(mediaUrl, width: 200, height: 200)
                    : Text(message),
          ),
        ),
      ],
    );
  }

  Widget _buildSendMessage(
    BuildContext context,
    String message,
    String mediaUrl,
    bool showAvatar,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 30, top: 5, bottom: 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                (mediaUrl.isNotEmpty)
                    ? Image.network(mediaUrl, width: 200, height: 200)
                    : Text(message),
          ),
        ),
        SizedBox(width: 8),
        showAvatar
            ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
              ),
            )
            : SizedBox(width: 32),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.camera_alt, color: Colors.grey),
            onTap: _sendMediaMessage,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            child: Icon(Icons.send, color: Colors.grey),
            onTap: _sendMessage,
          ),
        ],
      ),
    );
  }
}
