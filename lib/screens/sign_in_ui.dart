import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';
import 'package:newtype_chatapp/screens/register_ui.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key, required this.login, required this.loginState})
      : super(key: key);
  final void Function(String email, String password) login;
  final ApplicationLoginState loginState;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.green,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    labelText: "メールアドレス",
                    labelStyle: TextStyle(color: Colors.green)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                cursorColor: Colors.green,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: "パスワード（8～20文字）",
                  labelStyle: TextStyle(color: Colors.green),
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
                        onPressed: () async {
                          login(
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        child: const Text('ログイン'))),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
            height: 60,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, //ボタンの背景色
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
                child: const Text('新規登録はこちらから'))),
      ),
    );
  }
}
