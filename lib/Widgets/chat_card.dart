import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/Helpers/date.dart';
import 'package:chatterbox/Models/chat_user.dart';
import 'package:chatterbox/Models/messages.dart';
import 'package:chatterbox/Network/APIs.dart';
import 'package:chatterbox/Screens/chat_screen.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'view_profile_picture.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;

  const ChatCard({Key? key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Messages? _messages;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _messages = list[0];
              }
              return ListTile(
                  // user profile picture
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.height * .03),
                      child: CachedNetworkImage(
                        width: size.height * .055,
                        height: size.height * .055,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),

                  //user name
                  title: Text(widget.user.name),

                  //last message
                  subtitle: Text(
                    _messages != null ? _messages!.msg : widget.user.about,
                    maxLines: 1,
                  ),

                  //last message time
                  trailing: _messages == null
                      ? null
                      : _messages!.read.isEmpty &&
                              _messages!.fromId != APIs.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _messages!.sent),
                              style: const TextStyle(color: Colors.black54),
                            ));
            },
          )),
    );
  }
}
