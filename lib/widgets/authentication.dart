import 'package:flutter/material.dart';
import 'package:newtype_chatapp/enums/app_state.dart';
import 'package:newtype_chatapp/screens/email_check.dart';
import 'package:newtype_chatapp/screens/home/home_ui.dart';
import 'package:newtype_chatapp/screens/sign_in_ui.dart';
import 'package:newtype_chatapp/widgets/styled_button.dart';

class Authentication extends StatelessWidget {
  const Authentication({
    Key? key,
    required this.loginState,
    required this.signInWithEmailAndPassword,
    required this.registerAccount,
    required this.sendEmailVerification,
    required this.signOut,
  }) : super(key: key);

  final ApplicationLoginState loginState;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function(
    void Function(Exception e) error,
  ) sendEmailVerification;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedIn:
        return const Home();
      case ApplicationLoginState.loggedOut:
        return SignIn(
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
          loginState: loginState,
        );
      case ApplicationLoginState.notEmailVerified:
        return EmailCheck(
          sendEmail: () {
            sendEmailVerification((e) =>
                _showErrorDialog(context, 'Failed to email verification', e));
          },
          loginState: loginState,
        );
      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
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
