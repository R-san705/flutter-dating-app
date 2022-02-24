import 'package:flutter/material.dart';
import 'package:newtype_chatapp/model_s/tomato_structure/add_messages.dart';
import 'package:newtype_chatapp/models/message_model.dart';
import 'package:newtype_chatapp/models/profile_model.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/providers/message_provider.dart';
import 'package:newtype_chatapp/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class TalkPage extends StatelessWidget {
  final UserAttributes userAttributes;
  final String partnerUid;
  const TalkPage(
      {Key? key, required this.partnerUid, required this.userAttributes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MessageProvider(partnerUid, userAttributes),
        ),
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(userAttributes)..fetchMyUser()),
        ChangeNotifierProvider(
            create: (_) => AddMessages(partnerUid, userAttributes)),
      ],
      child: Consumer2<MessageProvider, ProfileProvider>(
        builder:
            (context, MessageProvider model2, ProfileProvider model1, child) {
          final ProfileModel? myUser = model1.userProfile;
          if (myUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<MessageModel>? messages = model2.messages;
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.green,
                flexibleSpace: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 20,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                partnerUid,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Online",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: (messages == null)
                          ? Container()
                          : ListView.builder(
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Align(
                                    alignment: (messages[index].messageType ==
                                            "receiver"
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (messages[index].messageType ==
                                                "receiver"
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      child: Text(messages[index].message),
                                    ),
                                  ),
                                );
                              })),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    height: 61,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35.0),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Colors.grey)
                              ],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(
                                      Icons.face,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {}),
                                Expanded(
                                  child: Consumer<AddMessages>(
                                    builder: (context, model3, child) {
                                      return TextField(
                                        controller: model3.msgController,
                                        decoration: const InputDecoration(
                                            hintText: "メッセージを入力...",
                                            hintStyle:
                                                TextStyle(color: Colors.green),
                                            border: InputBorder.none),
                                        onChanged: (text) {
                                          model3.setMessage(text);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Consumer<AddMessages>(
                                  builder: (context, model3, child) {
                                    return IconButton(
                                      onPressed: () async {
                                        await model3.addMessages();
                                      },
                                      icon: const Icon(Icons.send,
                                          color: Colors.green),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
