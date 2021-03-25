import 'package:emoji_picker_flutter/category_icons.dart';
import 'package:emoji_picker_flutter/config.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:bubble/bubble.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
// import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:myknott/Views/Services/Services.dart';

class ChatScreen extends StatefulWidget {
  final String notaryId;
  final String chatRoom;
  const ChatScreen({Key key, this.notaryId, @required this.chatRoom})
      : super(key: key);
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
  // int i = 0;
  bool hasData = false;

  int pageNumber = 0;
  getMessages(String chatroom) async {
    var messages = await notaryServices.getAllMessages(
        widget.notaryId, pageNumber, chatroom);
    print(
      "Page Count " + messages['pageNumber'].toString(),
    );
    if (messages['chatMessageCount'] == messageList.length) {
      setState(() {
        hasData = true;
      });
    }
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
    pageNumber = pageNumber + 1;
    setState(() {
      isloading = false;
      // pageNumber += 1;
    });
  }

  loadmoreMessage() async {
    print(pageNumber);
    var messages = await notaryServices.getAllMessages(
        widget.notaryId, pageNumber, widget.chatRoom);
    print("Page Count " + messages['pageNumber'].toString());
    if (messages['chatMessageCount'] == messageList.length) {
      setState(() {
        hasData = true;
      });
    }
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
    setState(() {
      pageNumber = pageNumber + 1;
    });

    print(messageList.length);
  }

  saveMessageToMessageList(message) {
    messageList.insert(0, {
      "sentAt": "2021-03-24T14:38:00.074Z",
      "seenByNotary": false,
      "seenByCustomer": false,
      "_id": "605b4ec86f1bf80015330011",
      "message": message,
      "sentBy": {
        "_id": "60280100a063a42fb456c252",
        "firstName": "Hemant",
        "lastName": "Saini",
        "phoneNumber": "6350312240",
        "phoneCountryCode": "+1",
        "email": "newuser@gmail.com",
        "userImageURL":
            "https://mynotarybucket1.s3.us-east-2.amazonaws.com/31.jpeg"
      },
      "sentByModel": "Notary",
      "chatroom": "603768d8c54c430015c9bdbc",
      "__v": 0
    });
    setState(() {});
  }

  handleNotificationClick(RemoteMessage message) async {
    // For handling new message notification
    if (message.data['type'] == 0 || message.data['type'] == "0") {
      getMessages(message.data['chatroom']);
    } else {
      print("type 1 action is triggered");
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.any((element) {
      print("new message");
      handleNotificationClick(element);
      return false;
    });
    getMessages(widget.chatRoom);
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
            color: Color(0xFFF2F2F2),
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
                        saveMessageToMessageList(message);
                        messageController.clear();
                        await NotaryServices().sendMessage(
                          message: message,
                          notaryId: widget.notaryId,
                          chatRoom: widget.chatRoom,
                        );
                        setState(() {});
                        // await getMessages();
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
          ? LazyLoadScrollView(
              isLoading: hasData,
              onEndOfPage: loadmoreMessage,
              child: ListView.builder(
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
              ),
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
    padding: const EdgeInsets.only(left: 2.0, top: 6.0, bottom: 2.0),
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
    padding: const EdgeInsets.only(right: 5.0, top: 6.0, bottom: 8),
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
