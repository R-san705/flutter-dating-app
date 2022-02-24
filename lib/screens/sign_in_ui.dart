import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/providers/auth_service.dart';
import 'package:newtype_chatapp/screens/email_check.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/logged_in_ui.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
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
                controller: passwordController,
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
                          try {
                            User? _user =
                                await authService.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);
                            if (_user != null && _user.emailVerified) {
                              final _userAttributes =
                                  UserAttributes(_user.uid, _user.email);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoggedIn(
                                          userAttributes: _userAttributes,
                                        )),
                              );
                            } else if (_user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmailCheck(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        from: 2)),
                              );
                            }
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
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
                  Navigator.pushNamed(context, 'signup');
                },
                child: const Text('新規登録はこちらから'))),
      ),
    );
  }
}
