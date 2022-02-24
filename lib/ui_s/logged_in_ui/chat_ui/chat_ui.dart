import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/friends_model.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/chat_ui/talk_page.dart';
import 'package:provider/provider.dart';

class ChatUi extends StatelessWidget {
  final UserAttributes userAttributes;
  const ChatUi({Key? key, required this.userAttributes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FriendsModel(userAttributes)..fetchMyFriend())
      ],
      child: Consumer(
        builder: (context, FriendsModel model1, child) {
          final List<String>? friendsUid = model1.friendsUid;
          return Scaffold(
            body: Column(
              children: [
                Container(
                  height: 75,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.green),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: (friendsUid == null)
                        ? const Center(child: Text('友達がいません'))
                        : ListView.builder(
                            itemCount: friendsUid.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TalkPage(
                                              partnerUid: friendsUid[index],
                                              userAttributes: userAttributes,
                                            )),
                                  );
                                },
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: Text(friendsUid[index]),
                                  subtitle: const Text('こんにちは！'),
                                ),
                              );
                            }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
