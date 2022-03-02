import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';
import 'package:newtype_chatapp/providers/application_state_provider.dart';
import 'package:newtype_chatapp/screens/sign_in_ui.dart';
import 'package:newtype_chatapp/widgets/styled_button.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationStateProvider>(
        builder: (context, appState, child) {
      if (appState.loginState == ApplicationLoginState.loggedIn) {
        return _Settings(
          signOut: appState.signOut,
        );
      } else {
        return SignIn(
          login: (email, password) {
            appState.signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
          loginState: appState.loginState,
        );
      }
    });
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({Key? key, required this.signOut}) : super(key: key);
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, //ボタンの背景色
                ),
                onPressed: () async {
                  signOut();
                },
                child: const Text('ログアウト')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, //ボタンの背景色
                ),
                onPressed: () async {},
                child: const Text('アカウントを削除')),
            const Text(''),
          ],
        ),
      ),
    );
  }
}
