import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';
import 'package:newtype_chatapp/providers/application_state_provider.dart';
import 'package:newtype_chatapp/screens/email_check.dart';
import 'package:newtype_chatapp/widgets/styled_button.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationStateProvider>(
        builder: (context, appState, child) {
      return _Register(
        loginState: appState.loginState,
        registerAccount: appState.registerAccount,
        sendEmailVerification: appState.sendEmailVerification,
      );
    });
  }
}

class _Register extends StatelessWidget {
  _Register({
    Key? key,
    required this.loginState,
    required this.registerAccount,
    required this.sendEmailVerification,
  }) : super(key: key);
  final ApplicationLoginState loginState;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function(
    void Function(Exception e) error,
  ) sendEmailVerification;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.green,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                          registerAccount(
                              _emailController.text,
                              _passwordController.text,
                              (e) => _showErrorDialog(
                                  context, 'Failed to sign in', e));
                          switch (loginState) {
                            case ApplicationLoginState.notEmailVerified:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmailCheck(
                                          sendEmail: () {
                                            sendEmailVerification((e) =>
                                                _showErrorDialog(
                                                    context,
                                                    'Failed to email verification',
                                                    e));
                                          },
                                          loginState: loginState,
                                        )),
                              );
                              break;
                            default:
                              null;
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
