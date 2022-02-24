import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/providers/auth_service.dart';
import 'package:newtype_chatapp/screens/sign_in_ui.dart';
import 'package:provider/provider.dart';

class AuthStateCheckWidget extends StatelessWidget {
  final Widget widget;
  const AuthStateCheckWidget({Key? key, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserAttributes?>(
      stream: authService.userAttributes,
      builder: (context, AsyncSnapshot<UserAttributes?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserAttributes? userAttributes = snapshot.data;
          return userAttributes == null ? SignIn() : widget;
        } else if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
