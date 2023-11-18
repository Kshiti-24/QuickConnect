import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/Models/chat_user.dart';
import 'package:chatterbox/Models/messages.dart';
import 'package:chatterbox/Network/APIs.dart';
import 'package:chatterbox/Widgets/message_card.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({Key? key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, statusBarColor: Colors.white));
  }

  List<Messages> list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  // stream: list,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      // if some or all data is loaded
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // log("\nData : ${jsonEncode(data![0].data())}");
                        list = data
                                ?.map((e) => Messages.fromJson(e.data()))
                                .toList() ??
                            [];
                        // log("\n List : ${list[0]}");
                        if (list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: list.length,
                              // _isSearching ? _searchList.length : list.length,
                              padding: EdgeInsets.only(top: size.height * 0.01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: list[index],
                                );
                                // return Text("Name : ${list[index]}");
                              });
                        } else {
                          return const Center(
                            child: Text(
                              'Say Hii! 👋',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  }),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: Row(
          children: [
            //back button
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black54)),

            //user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(size.height * .03),
              child: CachedNetworkImage(
                width: size.height * .05,
                height: size.height * .05,
                // imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),

            //for adding some space
            const SizedBox(width: 10),

            //user name & last seen time
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Text(widget.user.name,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),

                //for adding some space
                const SizedBox(height: 2),

                //last seen time of user
                // Text(
                //     list.isNotEmpty
                //         ? list[0].isOnline
                //             ? 'Online'
                //             : MyDateUtil.getLastActiveTime(
                //                 context: context,
                //                 lastActive: list[0].lastActive)
                //         : MyDateUtil.getLastActiveTime(
                //             context: context,
                //             lastActive: widget.user.lastActive),
                //     style:
                //         const TextStyle(fontSize: 13, color: Colors.black54)),
                Text("Last seen not available",
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            )
          ],
        ));
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * .01, horizontal: size.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        // FocusScope.of(context).unfocus();
                        // setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        // final ImagePicker picker = ImagePicker();
                        //
                        // // Picking multiple images
                        // final List<XFile> images =
                        // await picker.pickMultiImage(imageQuality: 70);
                        //
                        // // uploading & sending image one by one
                        // for (var i in images) {
                        //   log('Image Path: ${i.path}');
                        //   setState(() => _isUploading = true);
                        //   await APIs.sendChatImage(widget.user, File(i.path));
                        //   setState(() => _isUploading = false);
                        // }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        // final ImagePicker picker = ImagePicker();
                        //
                        // // Pick an image
                        // final XFile? image = await picker.pickImage(
                        //     source: ImageSource.camera, imageQuality: 70);
                        // if (image != null) {
                        //   log('Image Path: ${image.path}');
                        //   setState(() => _isUploading = true);
                        //
                        //   await APIs.sendChatImage(
                        //       widget.user, File(image.path));
                        //   setState(() => _isUploading = false);
                        // }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  SizedBox(width: size.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                //   if (_list.isEmpty) {
                //     //on first message (add user to my_user collection of chat user)
                //     APIs.sendFirstMessage(
                //         widget.user, _textController.text, Type.text);
                //   } else {
                //     //simply send message
                log("\nMessage : ${_textController.text}");
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                // }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
