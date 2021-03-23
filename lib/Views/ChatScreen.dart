import 'package:emoji_picker_flutter/category_icons.dart';
import 'package:emoji_picker_flutter/config.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myknott/Views/Services/Services.dart';

class ChatScreen extends StatefulWidget {
  final String notaryId;

  const ChatScreen({Key key, this.notaryId}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final NotaryServices notaryServices = NotaryServices();
  TextEditingController messageController = TextEditingController();
  List messageList = [];
  bool isloading = true;
  bool openEmoji = false;
  // bool hasData = true;
  int pageNumber = 0;
  getMessages() async {
    var messages =
        await notaryServices.getAllMessages(widget.notaryId, pageNumber);
    for (var message in messages['chatMessages']) {
      messageList.add(message);
    }
    messageList.sort(
      (a, b) => DateTime.parse(b['sentAt']).compareTo(
        DateTime.parse(
          a['sentAt'],
        ),
      ),
    );
    print(messageList.length);
    setState(() {
      isloading = false;
      // pageNumber++;
    });
  }

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    openEmoji = !openEmoji;
                  }),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red.shade700,
                    child: Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: TextField(
                        controller: messageController,
                        onTap: () {
                          setState(() {
                            openEmoji = false;
                          });
                        },
                        maxLines: 1,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message..."),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (messageController.text.isNotEmpty) {
                        final String message = messageController.text;
                        messageController.clear();
                        await NotaryServices().sendMessage(
                            message: message, notaryId: widget.notaryId);
                        messageList.clear();
                        await getMessages();
                      }
                    },
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.blue.shade800,
                      child: Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          openEmoji
              ? SizedBox(
                  height: 300,
                  child: EmojiPicker(
                    config: Config(
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        // bgColor: Colors.white,
                        indicatorColor: Colors.black,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue.shade800,
                        progressIndicatorColor: Colors.transparent,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        emojiSizeMax: 28,
                        categoryIcons: CategoryIcons(
                            foodIcon: FontAwesomeIcons.appleAlt,
                            travelIcon: Icons.location_pin),
                        horizontalSpacing: 0,
                        verticalSpacing: 0,
                        noRecentsText: "No Recents",
                        noRecentsStyle: const TextStyle(
                            fontSize: 20, color: Colors.black26),
                        buttonMode: ButtonMode.CUPERTINO),
                    onEmojiSelected: (emoji, category) {
                      messageController.text += category.emoji;
                      print(emoji);
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: !isloading
          ? ListView.builder(
              reverse: true,
              itemCount: messageList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return messageList[index]['sentBy']['_id'] == widget.notaryId
                    ? Container(
                        child: rightChild(messageList, index),
                      )
                    : Container(
                        child: leftChild(messageList, index),
                      );
              },
            )
          : Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 17,
                    width: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Please Wait ...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget leftChild(messageList, index) {
  return Padding(
    padding: const EdgeInsets.only(left: 2.0, top: 8.0),
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    messageList[index]['sentBy']['userImageURL'],
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Flexible(
                child: Bubble(
                  elevation: 0.2,
                  color: Colors.grey.shade50,
                  nip: BubbleNip.leftTop,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 3),
                    child: Text(
                      messageList[index]['message'],
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget rightChild(messageList, index) {
  return Padding(
    padding: const EdgeInsets.only(right: 5.0, top: 10.0, bottom: 2),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Bubble(
                  alignment: Alignment.centerRight,
                  nip: BubbleNip.rightTop,
                  color: Colors.blue.shade800,
                  child: Text(
                    messageList[index]['message'],
                    style: TextStyle(
                      fontSize: 16.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
