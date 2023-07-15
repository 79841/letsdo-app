import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/query/message.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Layout/sub_layout.dart';
import '../provider/auth.dart';
import '../query/chatroom.dart';

class ChatScreen extends StatefulWidget {
  int? chatroomId;
  ChatScreen({this.chatroomId, super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SubLayout(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return ChatroomCreator(
            auth: auth,
            chatroomId: widget.chatroomId,
          );
        },
      ),
    );
  }
}

class MessageInputBox extends StatelessWidget {
  final WebSocketChannel channel;
  const MessageInputBox({required this.channel, super.key});

  void _sendMessage(channel, message) {
    channel.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 50.0,
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Enter your message',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              size: 25.0,
            ),
            onPressed: () {
              _sendMessage(channel, messageController.text);
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class ChatroomCreator extends StatelessWidget {
  final Auth auth;
  int? chatroomId;
  ChatroomCreator({required this.auth, this.chatroomId, super.key});

  @override
  Widget build(BuildContext context) {
    if (chatroomId == null) {
      return FutureBuilder(
        future: createChatroom(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            chatroomId = snapshot.data?["id"];
            return _ChatContainer(
              auth: auth,
              chatroomId: chatroomId ?? 0,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return _ChatContainer(
        auth: auth,
        chatroomId: chatroomId ?? 0,
      );
    }
  }
}

class _ChatContainer extends StatefulWidget {
  final auth;
  final int chatroomId;
  // WebSocketChannel channel;

  const _ChatContainer({required this.auth, required this.chatroomId});

  @override
  State<_ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<_ChatContainer> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  late WebSocketChannel _channel;

  @override
  void dispose() {
    _channel.sink.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(Map<String, dynamic> message) {
    _messages.add(message);

    Timer(const Duration(milliseconds: 300), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMessages(widget.chatroomId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> messages = snapshot.data?.toList() ?? [];
          _messages.addAll(messages);
        }
        _channel = IOWebSocketChannel.connect(
          Uri.parse(
              'ws://141.164.51.245:8000/message/ws/${widget.chatroomId}?token=${widget.auth.token}'),
        );
        Map<String, dynamic> token = {};
        if (widget.auth.token != null) {
          token = JwtDecoder.decode(widget.auth.token);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> message = json.decode(snapshot.data);
                  _addMessage(message);
                }
                return Expanded(
                  flex: 7,
                  child: _MessageBoxes(
                    scrollController: _scrollController,
                    messages: _messages,
                    userId: token["id"],
                  ),
                );
              },
            ),
            Expanded(
              child: MessageInputBox(channel: _channel),
            ),
          ],
        );
      },
    );
  }
}

class _MessageBoxes extends StatefulWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> messages;
  final int userId;
  const _MessageBoxes(
      {required this.scrollController,
      required this.messages,
      required this.userId});

  @override
  State<_MessageBoxes> createState() => _MessageBoxesState();
}

class _MessageBoxesState extends State<_MessageBoxes> {
  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _messageBox(Map<String, dynamic> message, int sender) {
    MainAxisAlignment alignment = MainAxisAlignment.start;
    bool isMine = false;
    if (sender == widget.userId) {
      alignment = MainAxisAlignment.end;
      isMine = true;
    }

    DateTime timestamp = DateTime.parse(message["timestamp"]);
    int difference = DateTime.now().difference(timestamp).inDays;
    DateFormat dateFormat = DateFormat('HH:mm');
    if (difference >= 1) {
      dateFormat = DateFormat('yy.MM.dd HH:mm');
    }

    Widget time() {
      return Text(
        dateFormat.format(timestamp),
        style: const TextStyle(fontSize: 10),
      );
    }

    Widget messageContent(Color color) {
      return Container(
        padding: const EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message["content"],
          overflow: TextOverflow.visible,
          softWrap: true,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    Widget messageLine() {
      List<Widget> children = [
        messageContent(Colors.grey[300] ?? Colors.grey),
        time()
      ];
      if (isMine) {
        children = [time(), messageContent(Colors.amber[400] ?? Colors.amber)];
      }
      return Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      width: double.infinity,
      // alignment: alignment,
      child: messageLine(),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      height: MediaQuery.of(context).size.height,
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 2,
      //       blurRadius: 5,
      //       offset: const Offset(0, 3), // 그림자의 위치 조정
      //     ),
      //   ],
      // ),
      child: ListView.builder(
        shrinkWrap: true,
        controller: widget.scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> message = widget.messages[index];

          return _messageBox(message, message["userId"]);
        },
      ),
    );
  }
}
