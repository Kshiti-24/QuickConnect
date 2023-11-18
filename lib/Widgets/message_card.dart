import 'package:chatterbox/Models/messages.dart';
import 'package:chatterbox/Network/APIs.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Messages message;
  const MessageCard({Key? key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    // bool isMe = APIs.user.uid == widget.message.fromId;
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
    // InkWell(
    //   onLongPress: () {
    //     // _showBottomSheet(isMe);
    //   },
    //   child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    // if (widget.message.read.isEmpty) {
    //   APIs.updateMessageReadStatus(widget.message);
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
              padding: EdgeInsets.all(widget.message.type == Type.image
                  ? size.width * .03
                  : size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.height * .01),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 245, 255),
                  border: Border.all(color: Colors.lightBlue),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              )
              // widget.message.type == Type.text
              //     ?
              //     //show text
              //     Text(
              //         widget.message.msg,
              //         style: const TextStyle(fontSize: 15, color: Colors.black87),
              //       )
              // :
              //show image
              // ClipRRect(
              //     borderRadius: BorderRadius.circular(15),
              //     child: CachedNetworkImage(
              //       imageUrl: widget.message.msg,
              //       placeholder: (context, url) => const Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: CircularProgressIndicator(strokeWidth: 2),
              //       ),
              //       errorWidget: (context, url, error) =>
              //           const Icon(Icons.image, size: 70),
              //     ),
              //   ),
              ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: size.width * .04),
          child: Text(
              // MyDateUtil.getFormattedTime(
              //     context: context, time: widget.message.sent),
              // style: const TextStyle(fontSize: 13, color: Colors.black54),
              "12:00 PM"),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: size.width * .04),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
                // MyDateUtil.getFormattedTime(
                //     context: context, time: widget.message.sent),
                // style: const TextStyle(fontSize: 13, color: Colors.black54),
                "12:00 PM"),
          ],
        ),

        //message content
        Flexible(
          child: Container(
              padding: EdgeInsets.all(widget.message.type == Type.image
                  ? size.width * .03
                  : size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.height * .01),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 255, 176),
                  border: Border.all(color: Colors.lightGreen),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              )
              // widget.message.type == Type.text
              //     ?
              //     //show text
              //     Text(
              //         widget.message.msg,
              //         style: const TextStyle(fontSize: 15, color: Colors.black87),
              //       )
              //     :
              //     //show image
              //     ClipRRect(
              //         borderRadius: BorderRadius.circular(15),
              //         child: CachedNetworkImage(
              //           imageUrl: widget.message.msg,
              //           placeholder: (context, url) => const Padding(
              //             padding: EdgeInsets.all(8.0),
              //             child: CircularProgressIndicator(strokeWidth: 2),
              //           ),
              //           errorWidget: (context, url, error) =>
              //               const Icon(Icons.image, size: 70),
              //         ),
              //       ),
              ),
        ),
      ],
    );
  }
}
