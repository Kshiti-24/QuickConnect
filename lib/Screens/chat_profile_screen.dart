import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helpers/date.dart';
import '../Models/chat_user.dart';
import '../main.dart';

class ChatProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ChatProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.name),
        ),
        floatingActionButton: //user about
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined QuickConnect On: ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
                MyDateUtil.getLastMessageTime(
                    context: context,
                    time: widget.user.createdAt,
                    showYear: true),
                style: const TextStyle(color: Colors.black54, fontSize: 15)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // add space
                SizedBox(
                  width: size.width,
                  height: size.height * 0.03,
                ),

                // user profile
                ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * .1),
                  child: CachedNetworkImage(
                    width: size.height * .2,
                    height: size.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image.replaceAll("s96-c", "s400-c"),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                // add space
                SizedBox(
                  width: size.width,
                  height: size.height * 0.03,
                ),

                //for email
                Text(
                  widget.user.email,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                // add space
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(widget.user.about,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
