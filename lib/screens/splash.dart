import 'package:flutter/material.dart';
import 'package:newtype_chatapp/providers/application_state_provider.dart';
import 'package:newtype_chatapp/widgets/authentication.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationStateProvider>(
        builder: (context, appState, child) {
      return Authentication(
        loginState: appState.loginState,
        signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
        registerAccount: appState.registerAccount,
        sendEmailVerification: appState.sendEmailVerification,
        signOut: appState.signOut,
      );
    });
  }
}
