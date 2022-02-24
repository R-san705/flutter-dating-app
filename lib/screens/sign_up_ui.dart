import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/providers/auth_service.dart';
import 'package:newtype_chatapp/screens/email_check.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

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
                            UserCredential _userCredential = await authService
                                .createUserWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);
                            User? _user = _userCredential.user;
                            if (_user != null) {
                              _user.sendEmailVerification();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailCheck(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        from: 1),
                                  ));
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
                        child: const Text('新規登録'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
