import 'package:flutter/material.dart';
import 'package:newtype_chatapp/providers/auth_service.dart';
import 'package:newtype_chatapp/screens/sign_in_ui.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
                  try {
                    await authService.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  } catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
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
