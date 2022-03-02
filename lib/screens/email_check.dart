import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';

class EmailCheck extends StatelessWidget {
  const EmailCheck(
      {Key? key, required this.sendEmail, required this.loginState})
      : super(key: key);
  final void Function() sendEmail;
  final ApplicationLoginState loginState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30.0),
                child: ButtonTheme(
                  minWidth: 200.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                    child: const Text(
                      '確認メールを再送信',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      sendEmail();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, //ボタンの背景色
                    ),
                    child: const Text(
                      'メール確認完了',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
