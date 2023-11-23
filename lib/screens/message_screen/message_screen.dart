import 'package:nars/api/auth_service.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/enumerables/message_status.dart';
import 'package:nars/enumerables/message_type.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/chat/chat_message.dart';
import 'package:nars/models/chat/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    Key? key,
    required this.appointment,
    required this.chatRoom,
  }) : super(key: key);

  final String chatRoom;
  final Appointment appointment;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool _isLoading = false;
  FirebaseDatabase databaseFirebase = new FirebaseDatabase();
  TextEditingController messageTextController = TextEditingController();

  dynamic _user;

  Stream? chatMessagesStream;

  @override
  void initState() {
    super.initState();
  }

  Widget ChatMessageList() {
    Appointment _appointment = widget.appointment;
    final flavor = Provider.of<Flavor>(context);
    return StreamBuilder(
        stream: databaseFirebase.getConversationMessages(widget.chatRoom),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final user = Provider.of<AuthService>(context).currentUser!;
          _user = user;
          print("SNAPSHOT");
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.active) {
            var data = snapshot.data!;
            debugPrint('data: $data');
            print(data.docs);
            // return ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: data.docs.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     print('Docs:');
            //     print(data.docs[index]);
            //     return Text(data.docs[index]['message']);
            //   },
            // );
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic message = data.docs[index];
                // dynamic nextMessage;
                // if (index == data.docs.length - 1) {
                //   nextMessage = data.docs[index + 1];
                // }

                debugPrint("message: ${message['message']}");
                // debugPrint("sender: ${message['sender']}");
                // debugPrint("username: ${user.name}");
                // bool isPrev = (index == data.docs.length - 1
                //     ? true
                //     : (message.sender == nextMessage.sender));
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: message['sender'] == user.name
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        // if (isPrev) const SizedBox(width: defaultPadding * 2),
                        if (!(message['sender'] == user.name) &&
                            (index == data.docs.length - 1 ? true : false)) ...[
                          CachedNetworkImage(
                            key: UniqueKey(),
                            imageUrl: flavor == Flavor.Patient
                                ? _appointment.practitionerProfilePicture!
                                : _appointment.patientProfilePicture!,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 12,
                              backgroundImage: imageProvider,
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: kBackgroundColor,
                              child: const Icon(
                                Icons.error,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: defaultPadding / 2),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding * 0.75,
                              vertical: defaultPadding / 2),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(
                                message['sender'] == user.name ? 1 : 0.25),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              // bottomLeft: isPrev
                              //     ? Radius.circular(15)
                              //     : Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Text(
                            message['messageType'] == 'MessageType.Text'
                                ? message['message']
                                : '',
                            style: TextStyle(
                                color: message['sender'] == user.name
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                      // height: isPrev ? 3 : defaultPadding,
                    ),
                  ],
                );
              },
            );
          } else {
            return CardContainer(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text('Loading..'),
            );
          }
        });
  }

  ChatMessage? _chatMessage;
  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;

    sendMessage() {
      setState(() => _submitted = true);
      final isValid = _formKey.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (isValid!) {
        setState(() => _isLoading = true);
        _formKey.currentState?.save();

        Map<String, String> a = {
          "messageType": _chatMessage!.messageType.toString(),
          "dateTime": _chatMessage!.dateTime.toString(),
          "messageStatus": _chatMessage!.messageStatus.toString(),
          "message": _chatMessage!.text!,
          "sender": _user.name
        };
        databaseFirebase.addConversationMessage(
            widget.appointment.id.toString(), a);
        messageTextController.text = '';
      }
    }

    Appointment _appointment = widget.appointment;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Responsive.isDesktop(context)
          ? PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding / 2,
                  horizontal: size.width * 0.30,
                ),
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(
                      color: Colors.white,
                    ),
                    CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: flavor == Flavor.Patient
                          ? _appointment.practitionerProfilePicture!
                          : _appointment.patientProfilePicture!,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: kBackgroundColor,
                        child: const Icon(
                          Icons.error,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding * 0.75),
                    Text(
                      flavor == Flavor.Patient
                          ? 'Dr. ' + _appointment.practitionerName!
                          : _appointment.patientName!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
              preferredSize: Size(
                size.width,
                56,
              ),
            )
          : AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
              leading: const BackButton(
                color: Colors.white,
              ),
              title: Row(
                children: [
                  CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: flavor == Flavor.Patient
                        ? _appointment.practitionerProfilePicture!
                        : _appointment.patientProfilePicture!,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: kBackgroundColor,
                      child: const Icon(
                        Icons.error,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: defaultPadding * 0.75),
                  Text(
                    flavor == Flavor.Patient
                        ? 'Dr. ' + _appointment.practitionerName!
                        : _appointment.patientName!,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam),
                ),
                const SizedBox(width: defaultPadding * 0.5),
              ],
            ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context)
                        ? size.width * 0.30
                        : defaultPadding,
                    defaultPadding,
                    Responsive.isDesktop(context)
                        ? size.width * 0.30
                        : defaultPadding,
                    0),
                child: ChatMessageList()),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context)
                    ? size.width * 0.30
                    : defaultPadding,
                vertical: defaultPadding * 0.5),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              // boxShadow: [
              //   BoxShadow(
              //     offset: const Offset(0, 4),
              //     blurRadius: 32,
              //     color: Colors.black.withOpacity(0.1),
              //   )
              // ],
            ),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {},
                  icon: const Icon(Icons.image, color: Colors.white),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 0.75),
                    // height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        // Icon(
                        //   Icons.sentiment_satisfied_alt_outlined,
                        //   color: Theme.of(context)
                        //       .textTheme
                        //       .bodyText1!
                        //       .color!
                        //       .withOpacity(0.64),
                        // ),
                        // const SizedBox(width: defaultPadding / 4),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            child: TextFormField(
                              controller: messageTextController,
                              onSaved: (value) => setState(() {
                                _chatMessage = ChatMessage(
                                    messageType: MessageType.Text,
                                    messageStatus: MessageStatus.Viewed,
                                    sender: flavor.name,
                                    dateTime: DateTime.now(),
                                    text: value);
                                // print(_chatMessage);
                              }),
                              decoration: const InputDecoration(
                                hintText: 'Type message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        // Icon(
                        //   Icons.attach_file,
                        //   color: Theme.of(context)
                        //       .textTheme
                        //       .bodyText1!
                        //       .color!
                        //       .withOpacity(0.64),
                        // ),
                        // const SizedBox(width: defaultPadding / 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    // print("CHATMESSAGE");
                    // print(_chatMessage!.text);
                    sendMessage();
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class Message extends StatelessWidget {
//   const Message({
//     Key? key,
//     required this.flavor,
//     required this.message,
//   }) : super(key: key);

//   final Flavor flavor;
//   final ChatMessage message;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment:
//           message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!message.isSender) ...[
//           CachedNetworkImage(
//             key: UniqueKey(),
//             imageUrl: flavor == Flavor.Patient
//                 ? _appointment.practitionerProfilePicture!
//                 : _appointment.patientProfilePicture!,
//             imageBuilder: (context, imageProvider) => CircleAvatar(
//               backgroundImage: imageProvider,
//             ),
//             progressIndicatorBuilder: (context, url, downloadProgress) =>
//                 SizedBox(
//               height: 50,
//               width: 50,
//               child: Center(
//                 child: CircularProgressIndicator(
//                   value: downloadProgress.progress,
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Container(
//               color: kBackgroundColor,
//               child: const Icon(
//                 Icons.error,
//                 color: Colors.redAccent,
//               ),
//             ),
//           ),
//         ],
//         Container(
//           margin: const EdgeInsets.only(top: defaultPadding),
//           padding: const EdgeInsets.symmetric(
//               horizontal: defaultPadding * 0.75, vertical: defaultPadding / 2),
//           decoration: BoxDecoration(
//               color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.25),
//               borderRadius: BorderRadius.circular(30)),
//           child: Text(
//             message.messageType == MessageType.Text ? message.text! : '',
//             style: TextStyle(
//                 color: message.isSender
//                     ? Colors.white
//                     : Theme.of(context).textTheme.bodyText1!.color),
//           ),
//         ),
//       ],
//     );
//   }
// }
