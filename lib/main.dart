import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gifts_app/constants/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/controller/custom_users/update_fcm_token_for_app_user/update_fcm_token_for_app_user_cubit.dart';
import 'package:gifts_app/model/sink/local_db.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseAuth.instance.signOut();
  // generateLocalDbData();
  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'amrofficialacc@gmail.com', password: '123456');
  // await FirebaseAuth.instance.signOut();
  // await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: 'G5MfE@example.com', password: '12345678');
  
  runApp(BlocProvider(
    create: (context) => UpdateFcmTokenForAppUserCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFBB86FC),
        scaffoldBackgroundColor: const Color(0xFF121212),
        // accentColor: Color(0xFF03DAC6),
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: const Color(0xFF272727),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          bodyLarge: TextStyle(color: Colors.white54),
          headlineMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF03DAC6),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      themeMode: ThemeMode.dark, // Change to ThemeMode.system for system theme

      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
