// import 'package:ansvel/referralsystem/screens/home_page.dart';
import 'package:ansvel/referralsystem/screens/refhomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ansvel/referralsystem/provider/auth_provider.dart';
import 'package:ansvel/referralsystem/provider/ref_provider.dart';
import 'package:ansvel/referralsystem/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RefProvider()),
      ],
      child: const MaterialApp(
        home: RefHomePage(),
      ),
    );
  }
}
