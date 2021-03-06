import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';
import 'package:newtype_chatapp/providers/application_state_provider.dart';
import 'package:newtype_chatapp/providers/logged_in_page_model.dart';
import 'package:newtype_chatapp/providers/profile_provider.dart';
import 'package:newtype_chatapp/screens/settings/settings_ui.dart';
import 'package:newtype_chatapp/screens/splash.dart';
import 'package:provider/provider.dart';

import '../profile/mypage_ui.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationStateProvider>(
        builder: (context, appState, child) {
      if (appState.loginState == ApplicationLoginState.loggedIn) {
        return _LoggedIn(uid: appState.uid!);
      } else {
        return const Splash();
      }
    });
  }
}

class _LoggedIn extends StatelessWidget {
  final String uid;
  const _LoggedIn({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(uid)..fetchMyUser()),
        ChangeNotifierProvider(create: (_) => LoggedInPageModel(uid)),
      ],
      child: Consumer2<ProfileProvider, LoggedInPageModel>(builder:
          (BuildContext context, ProfileProvider model1,
              LoggedInPageModel model2, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: CircleAvatar(
                backgroundImage: model1.myProfile != null
                    ? NetworkImage(model1.myProfile!.imageURL1!)
                    : null,
                backgroundColor: Colors.grey,
                radius: 25,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage(uid: uid)),
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
            title: const Center(child: Text('????????????')),
          ),
          body: Center(
              child: model2.widgetOptions.elementAt(model2.selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: (model2.selectedIndex == 0)
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                label: '????????????',
              ),
              BottomNavigationBarItem(
                icon: (model2.selectedIndex == 1)
                    ? const Icon(Icons.textsms)
                    : const Icon(Icons.textsms_outlined),
                label: '?????????',
              ),
              BottomNavigationBarItem(
                icon: (model2.selectedIndex == 2)
                    ? const Icon(Icons.analytics)
                    : const Icon(Icons.analytics_outlined),
                label: 'Discovery',
              ),
            ],
            currentIndex: model2.selectedIndex,
            selectedItemColor: Colors.green,
            onTap: model2.onItemTapped,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }),
    );
  }
}
