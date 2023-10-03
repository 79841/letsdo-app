import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../query/profile_image.dart';

class MessageBoxStyle {
  static const double borderRadius = 8.0;
  static const double profileImageSize = 35.0;
}

class MessageBoxes extends StatefulWidget {
  final ScrollController scrollController;
  final void Function() scrollToBottom;
  final List<Map<String, dynamic>> messages;
  final int userId;
  final int? opponentId;
  const MessageBoxes(
      {super.key,
      required this.scrollController,
      required this.scrollToBottom,
      required this.messages,
      required this.userId,
      required this.opponentId});

  @override
  State<MessageBoxes> createState() => MessageBoxesState();
}

class MessageBoxesState extends State<MessageBoxes> {
  bool showMessages = false;
  @override
  void initState() {
    super.initState();
  }

  void scrollToBottomAndShowMessages() {
    if (showMessages) {
      return;
    }
    widget.scrollToBottom();
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        showMessages = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Timer(const Duration(milliseconds: 300), widget.scrollToBottom);
    // });
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: FutureBuilder<Uint8List>(
        future: fetchProfileImage(widget.opponentId),
        builder: (context, snapshot) {
          Uint8List? opponentProfileImage = snapshot.data;

          ListView messages = ListView.builder(
            // reverse: true,
            shrinkWrap: true,
            controller: widget.scrollController,
            itemCount: widget.messages.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> message = widget.messages[index];
              double verticalMargin = 20.0;

              BorderRadius borderRadius =
                  BorderRadius.circular(MessageBoxStyle.borderRadius);
              bool showProfileImage = true;
              DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

              if (index < widget.messages.length - 1) {
                DateTime currentTime =
                    DateTime.parse(widget.messages[index]["timestamp"]);
                DateTime prevTime =
                    DateTime.parse(widget.messages[index + 1]["timestamp"]);

                String formattedCurentTime = dateFormat.format(currentTime);
                String formattedprevTime = dateFormat.format(prevTime);
                if (formattedCurentTime == formattedprevTime &&
                    widget.messages[index]["user_id"] ==
                        widget.messages[index + 1]["user_id"]) {
                  verticalMargin = 5.0;
                  showProfileImage = false;
                }
              }

              if (index == widget.messages.length - 1 ||
                  (index < widget.messages.length - 1 &&
                      widget.messages[index]["userId"] !=
                          widget.messages[index + 1]["userId"])) {
                if (widget.messages[index]["userId"] == widget.userId) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(MessageBoxStyle.borderRadius),
                    topRight: Radius.circular(MessageBoxStyle.borderRadius),
                    bottomLeft: Radius.circular(MessageBoxStyle.borderRadius),
                  );
                } else {
                  showProfileImage = true;
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(MessageBoxStyle.borderRadius),
                    topRight: Radius.circular(MessageBoxStyle.borderRadius),
                    bottomRight: Radius.circular(MessageBoxStyle.borderRadius),
                  );
                }
              }
              return MessageBox(
                message: message,
                userId: widget.userId,
                opponentProfileImage: opponentProfileImage,
                verticalMargin: verticalMargin,
                borderRadius: borderRadius,
                showProfileImage: showProfileImage,
              );
            },
          );
          scrollToBottomAndShowMessages();
          return showMessages ? messages : const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final Map<String, dynamic> message;
  final int userId;
  final Uint8List? opponentProfileImage;
  final double verticalMargin;
  final BorderRadius borderRadius;
  final bool showProfileImage;
  const MessageBox({
    super.key,
    required this.message,
    required this.userId,
    required this.opponentProfileImage,
    required this.verticalMargin,
    required this.borderRadius,
    required this.showProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment alignment = MainAxisAlignment.start;
    bool isMine = false;
    int senderId = message["userId"];
    if (senderId == userId) {
      alignment = MainAxisAlignment.end;
      isMine = true;
    }

    DateTime timestamp = DateTime.parse(message["timestamp"]);
    int difference = DateTime.now().difference(timestamp).inDays;
    DateFormat dateFormat = DateFormat('HH:mm');
    if (difference >= 1) {
      dateFormat = DateFormat('MM.dd HH:mm');
    }

    Widget opponentProfile() {
      return opponentProfileImage == null
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
              width: MessageBoxStyle.profileImageSize,
              height: MessageBoxStyle.profileImageSize,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(MessageBoxStyle.profileImageSize / 2),
                color: mainGray,
              ),
            )
          : Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
              width: MessageBoxStyle.profileImageSize,
              height: MessageBoxStyle.profileImageSize,
              child: ClipOval(
                child: Image.memory(
                  opponentProfileImage!,
                  fit: BoxFit.cover,
                ),
              ),
            );
    }

    Widget time() {
      return Text(
        dateFormat.format(timestamp),
        style: const TextStyle(fontSize: 10),
      );
    }

    Widget messageContent(Color bgColor, Color textColor) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Text(
          message["content"],
          overflow: TextOverflow.visible,
          softWrap: true,
          style: TextStyle(fontSize: 13, color: textColor),
        ),
      );
    }

    Widget messageLine() {
      List<Widget> children = [
        showProfileImage
            ? opponentProfile()
            : wspace(MessageBoxStyle.profileImageSize + 10.0),
        messageContent(mainWhite, mainBlack),
        wspace(7.0),
        time(),
      ];
      if (isMine) {
        children = [
          time(),
          wspace(7.0),
          messageContent(darkBlue, mainWhite),
        ];
      }
      return Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, verticalMargin),
      padding: EdgeInsets.zero,
      width: double.infinity,
      child: messageLine(),
    );
  }
}

class MessageInputBox extends StatelessWidget {
  final WebSocketChannel channel;
  final void Function() scrollToBottom;
  final ScrollController scrollcontroller;
  const MessageInputBox(
      {required this.channel,
      required this.scrollToBottom,
      required this.scrollcontroller,
      super.key});

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
              child: TextField(
                onTap: () {
                  Timer(const Duration(milliseconds: 500), scrollToBottom);
                },
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
