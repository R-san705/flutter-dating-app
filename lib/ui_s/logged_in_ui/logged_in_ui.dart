import 'package:flutter/material.dart';
import 'package:newtype_chatapp/model_s/tomato_structure/logged_in_page_model.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/providers/profile_provider.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';

import 'mypage_ui/mypage_ui.dart';

class LoggedIn extends StatelessWidget {
  final UserAttributes userAttributes;
  const LoggedIn({Key? key, required this.userAttributes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(userAttributes)..fetchMyUser()),
        ChangeNotifierProvider(
            create: (_) => LoggedInPageModel(userAttributes)),
      ],
      child: Consumer2<ProfileProvider, LoggedInPageModel>(builder:
          (BuildContext context, ProfileProvider model1,
              LoggedInPageModel model3, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: CircleAvatar(
                backgroundImage: model1.userProfile!.imageURL1 != null
                    ? NetworkImage(model1.userProfile!.imageURL1!)
                    : null,
                backgroundColor: Colors.grey,
                radius: 25,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyPage(userAttributes: userAttributes)),
                );
                model1.fetchMyUser();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
              ),
            ],
            backgroundColor: Colors.green,
            title: const Center(child: Text('タイトル')),
          ),
          body: Center(
              child: model3.widgetOptions.elementAt(model3.selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: (model3.selectedIndex == 0)
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                label: 'スワイプ',
              ),
              BottomNavigationBarItem(
                icon: (model3.selectedIndex == 1)
                    ? const Icon(Icons.textsms)
                    : const Icon(Icons.textsms_outlined),
                label: 'トーク',
              ),
              BottomNavigationBarItem(
                icon: (model3.selectedIndex == 2)
                    ? const Icon(Icons.analytics)
                    : const Icon(Icons.analytics_outlined),
                label: 'Discovery',
              ),
            ],
            currentIndex: model3.selectedIndex,
            selectedItemColor: Colors.green,
            onTap: model3.onItemTapped,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }),
    );
  }
}
