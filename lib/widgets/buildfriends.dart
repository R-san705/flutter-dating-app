import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/screens/talk/talk_page.dart';

class BuildFriends extends StatelessWidget {
  const BuildFriends({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .orderBy('sentAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  final data = document.data()! as Map<String, dynamic>;
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(document.id)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> friendData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TalkPage(
                                          partnerUid: document.id,
                                          uid: uid,
                                        )),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: friendData['imageURL1'] != null
                                  ? NetworkImage(friendData['imageURL1']!)
                                  : null,
                              backgroundColor: Colors.grey,
                              radius: 25,
                            ),
                            title: Text(friendData['name']),
                            trailing: Column(
                              children: [
                                Text(data['sentAt2'] ?? ''),
                                Badge(
                                  badgeContent: const Text(
                                    '3',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  badgeColor: Colors.lightGreen,
                                ),
                              ],
                            ),
                            subtitle: Text(data['recent_message'] ?? ''),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return Expanded(child: Container());
          }
        });
  }
}
