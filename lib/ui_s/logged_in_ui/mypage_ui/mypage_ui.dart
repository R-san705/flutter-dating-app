import 'package:flutter/material.dart';
import 'package:newtype_chatapp/model_s/tomato_structure/age_calc_model.dart';
import 'package:newtype_chatapp/models/profile_model.dart';
import 'package:newtype_chatapp/providers/profile_provider.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/mypage_ui/preview_mypage_ui.dart';
import 'package:provider/provider.dart';

import 'editing_mypage_ui.dart';

class MyPage extends StatelessWidget {
  final String uid;
  const MyPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(uid)..fetchMyUser()),
      ],
      child: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider model2, child) {
        final ProfileModel? myUser = model2.myProfile;
        if (myUser == null) {
          return const Center(child: CircularProgressIndicator());
        }
        var _age = AgeCalcModel().ageCalc(myUser.birth);
        return Scaffold(
          appBar: AppBar(
            title: const Text('マイページ'),
            backgroundColor: Colors.green,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewMyPage(uid: uid)),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: myUser.imageURL1 != null
                          ? NetworkImage(myUser.imageURL1!)
                          : null,
                      radius: 120,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Text(
                    '${myUser.name}, $_age',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final bool? added = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditingMyPage(myUser)),
                                  );
                                  if (added != null && added) {
                                    const snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('プロフィールを編集しました'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }

                                  model2.fetchMyUser();
                                },
                                child: const Icon(
                                  Icons.edit,
                                ),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(55, 55),
                                  primary: Colors.white,
                                  onPrimary: Colors.green,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text('プロフィールの編集'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PreviewMyPage(uid: uid)),
                                  );
                                },
                                child: const Icon(Icons.remove_red_eye),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(55, 55),
                                  primary: Colors.white,
                                  onPrimary: Colors.green,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text('プレビュー'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
