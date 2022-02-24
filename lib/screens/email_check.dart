import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/ui_s/signup_with_google_ui/input_user_info.dart';

class EmailCheck extends StatefulWidget {
  final String? email;
  final String? password;
  final int? from; //1 → アカウント作成画面から    2 → ログイン画面から
  const EmailCheck({Key? key, this.email, this.password, this.from})
      : super(key: key);

  @override
  State<EmailCheck> createState() => _EmailCheckState();
}

class _EmailCheckState extends State<EmailCheck> {
  final _auth = FirebaseAuth.instance;
  String _noCheckText = '';
  String _sentEmailText = '';
  int _btnClickNum = 0;

  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    _email = widget.email ?? '';
    _password = widget.password ?? '';

    // 前画面から遷移後の初期表示内容
    if (_btnClickNum == 0) {
      if (widget.from == 1) {
        // アカウント作成画面から遷移した時
        _noCheckText = '';
        _sentEmailText = '${widget.email}\nに確認メールを送信しました。';
      } else {
        _noCheckText = 'まだメール確認が完了していません。\n確認メール内のリンクをクリックしてください。';
        _sentEmailText = '';
      }
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: Text(
                  _noCheckText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              Text(_sentEmailText),
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
                      UserCredential _userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );

                      _userCredential.user!.sendEmailVerification();
                      setState(() {
                        _btnClickNum++;
                        _sentEmailText = '${widget.email}\nに確認メールを送信しました。';
                      });
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
                    onPressed: () async {
                      UserCredential _userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );
                      if (_userCredential.user!.emailVerified) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputUserInfo(
                                user: _userCredential.user!,
                              ),
                            ));
                      } else {
                        setState(() {
                          _btnClickNum++;
                          _noCheckText =
                              "まだメール確認が完了していません。\n確認メール内のリンクをクリックしてください。";
                        });
                      }
                    },
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
