import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildMessages extends StatelessWidget {
  const BuildMessages({Key? key, required this.uid, required this.partnerUid})
      : super(key: key);

  final String uid;
  final String partnerUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .doc(partnerUid)
          .collection('messages')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView(
              reverse: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final data = document.data()! as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 1, bottom: 1),
                  child: Align(
                      alignment: (data['message_type'] == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (data['message_type'] == "receiver"
                                ? Colors.grey.shade200
                                : Colors.lightGreen[300]),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(data['message']))),
                );
              }).toList(),
            ),
          );
        } else {
          return Expanded(child: Container());
        }
      },
    );
  }
}
