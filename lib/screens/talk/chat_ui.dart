import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newtype_chatapp/models/friends_model.dart';
import 'package:newtype_chatapp/widgets/buildfriends.dart';
import 'package:newtype_chatapp/widgets/styled_button.dart';
import 'package:provider/provider.dart';

class ChatUi extends StatelessWidget {
  final String uid;
  final _friendIdController = TextEditingController();
  final DateFormat outputFormat = DateFormat('HH:mm');
  ChatUi({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FriendsModel(uid)..fetchMyFriend())
      ],
      child: Scaffold(
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
                      backgroundColor: Colors.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.lightGreen[300],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
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
                            child: TextField(
                              controller: _friendIdController,
                              decoration: const InputDecoration(
                                  hintText: "名前から友達を追加",
                                  hintStyle: TextStyle(color: Colors.green),
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('name',
                                      isEqualTo: _friendIdController.text)
                                  .limit(1)
                                  .get()
                                  .then((QuerySnapshot snapshot) {
                                for (var doc in snapshot.docs) {
                                  if (doc.id == uid) {
                                    displayMyself(context, doc.id);
                                  } else {
                                    addFriend(context, doc.id);
                                  }
                                }
                              });
                            },
                            icon: const Icon(Icons.search, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            BuildFriends(uid: uid),
          ],
        ),
      ),
    );
  }

  Future<void> displayMyself(BuildContext context, String friendUid) async {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'あなたのアカウントです',
                style: TextStyle(fontSize: 24),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendUid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> friendData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: friendData['imageURL1'] != null
                                  ? NetworkImage(friendData['imageURL1']!)
                                  : null,
                              backgroundColor: Colors.grey,
                              radius: 25,
                            ),
                            title: Text(friendData['name']),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                StyledButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '戻る',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ]);
        });
  }

  Future<void> addFriend(BuildContext context, String friendUid) async {
    CollectionReference friendCol = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends');

    await friendCol
        .where('friendUid', isEqualTo: friendUid)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 0) {
        showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text(
                    '友達追加',
                    style: TextStyle(fontSize: 24),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(friendUid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> friendData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: friendData['imageURL1'] !=
                                          null
                                      ? NetworkImage(friendData['imageURL1']!)
                                      : null,
                                  backgroundColor: Colors.grey,
                                  radius: 25,
                                ),
                                title: Text(friendData['name']),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    StyledButton(
                      onPressed: () async {
                        DateTime t = DateTime.now();

                        DocumentReference friendDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('friends')
                            .doc(friendUid);
                        DocumentReference partnerFriendDoc = FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(friendUid)
                            .collection('friends')
                            .doc(uid);

                        await friendDoc.set({
                          'recent_message': 'マッチしました',
                          'sentAt': t.millisecondsSinceEpoch.toString(),
                          'sentAt2': outputFormat.format(DateTime.now()),
                          'sentBy': '',
                          'friendUid': friendUid,
                        });
                        await partnerFriendDoc.set({
                          'recent_message': 'マッチしました',
                          'sentAt': t.millisecondsSinceEpoch.toString(),
                          'sentAt2': outputFormat.format(DateTime.now()),
                          'sentBy': '',
                          'friendUid': uid,
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(
                        '追加',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ]);
            });
      } else {
        showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text(
                    '友達登録済みです',
                    style: TextStyle(fontSize: 24),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(friendUid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> friendData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: friendData['imageURL1'] !=
                                          null
                                      ? NetworkImage(friendData['imageURL1']!)
                                      : null,
                                  backgroundColor: Colors.grey,
                                  radius: 25,
                                ),
                                title: Text(friendData['name']),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    StyledButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '戻る',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ]);
            });
      }
    });
  }
}
