import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/providers/auth_service.dart';
import 'package:newtype_chatapp/screens/sign_in_ui.dart';
import 'package:newtype_chatapp/screens/sign_up_ui.dart';
import 'package:newtype_chatapp/screens/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider<AuthService>(
      create: (_) => AuthService(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
      },
    );
  }
}
