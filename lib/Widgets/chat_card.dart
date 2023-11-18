import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/Models/chat_user.dart';
import 'package:chatterbox/Screens/chat_screen.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;

  const ChatCard({Key? key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
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
        child: ListTile(
            // user profile picture
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(size.height * .03),
              child: CachedNetworkImage(
                width: size.height * .055,
                height: size.height * .055,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),

            //user name
            title: Text(widget.user.name),

            //last message
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),

            //last message time
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )),
      ),
    );
  }
}
