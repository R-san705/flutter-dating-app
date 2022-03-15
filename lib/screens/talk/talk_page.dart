import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/providers/add_messages.dart';
import 'package:newtype_chatapp/widgets/buildmessages.dart';
import 'package:provider/provider.dart';

class TalkPage extends StatelessWidget {
  TalkPage({Key? key, required this.partnerUid, required this.uid})
      : super(key: key);

  final String uid;
  final String partnerUid;
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddMessages(partnerUid, uid)),
      ],
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(partnerUid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> friendData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Row(
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
                            CircleAvatar(
                              backgroundImage: friendData['imageURL1'] != null
                                  ? NetworkImage(friendData['imageURL1']!)
                                  : null,
                              backgroundColor: Colors.grey,
                              radius: 23,
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
                                    friendData['name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Online",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          ),
          body: Container(
            color: Colors.lightGreen[100],
            child: Column(
              children: [
                BuildMessages(
                  uid: uid,
                  partnerUid: partnerUid,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(
                    top: 2,
                    bottom: 15,
                    right: 15,
                    left: 15,
                  ),
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
                                      controller: _messageController,
                                      decoration: const InputDecoration(
                                          hintText: "メッセージを入力...",
                                          hintStyle:
                                              TextStyle(color: Colors.green),
                                          border: InputBorder.none),
                                    );
                                  },
                                ),
                              ),
                              Consumer<AddMessages>(
                                builder: (context, model, child) {
                                  return IconButton(
                                    onPressed: () async {
                                      await model
                                          .addMessages(_messageController.text);
                                      _messageController.clear();
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
            ),
          )),
    );
  }
}
