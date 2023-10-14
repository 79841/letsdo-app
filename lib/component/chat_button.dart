import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';
import '../config/style.dart';
import '../provider/auth.dart';
import '../provider/chatroom.dart';
import '../utils/navigator.dart';

class ChatButton extends StatefulWidget {
  final double iconSize;
  const ChatButton({required this.iconSize, super.key});

  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  int? chatroomId;
  late WebSocketChannel _channel;

  @override
  void dispose() {
    try {
      _channel.sink.close();
    } catch (e) {
      print("channel has not bee initialized");
    }

    super.dispose();
  }

  Widget chatIcon(int chatroomId, double size, bool unreadMessageExist) {
    return IconButton(
      onPressed: () => goToChat(
        context,
        chatroomId,
        (value) {
          if (mounted) {
            setState(() {});
          }
        },
      ),
      icon: Icon(
        unreadMessageExist
            ? Icons.mark_chat_unread_outlined
            : Icons.chat_bubble_outline,
        size: size,
        color: mainBlack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int chatroomId = Provider.of<Chatroom>(context, listen: false).chatroomId!;

    return Consumer<Auth>(
      builder: (context, auth, child) {
        _channel = IOWebSocketChannel.connect(
          Uri.parse(
              "$WEBSOCKET_SERVER_URL/message/unread/count/ws/$chatroomId?token=${auth.token}"),
        );

        return StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            bool unreadMessageExist = false;

            int unreadMessageCount = 0;
            if (snapshot.hasData) {
              unreadMessageCount = json.decode(snapshot.data);
            }
            if (unreadMessageCount > 0) {
              unreadMessageExist = true;
            }
            return chatIcon(
              chatroomId,
              widget.iconSize,
              unreadMessageExist,
            );
          },
        );
      },
    );
  }
}
