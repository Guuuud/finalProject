import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/providers/user_provider.dart';
import 'package:secondhand/resources/recommendation.dart';
import 'package:secondhand/responsive/mobile_screen_layout.dart';
import 'package:secondhand/responsive/responsive_layout.dart';
import 'package:secondhand/responsive/web_screen_layout.dart';
import 'package:secondhand/screens/auth/login_screen.dart';
import 'package:secondhand/screens/welcome.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:provider/provider.dart';

// flutter run -d chrome --web-renderer html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///
  // initialise app based on platform- web or mobile
  if (identical(0, 0.0)) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD0SudvoAJJC0noav08JYs8GWwq3mP7LXU",
        appId: "1:410085583:web:f47af29fd3a1a21e6c2c9a",
        messagingSenderId: "410091785583",
        projectId: "instagram-dddae",
        storageBucket: "instagram-dddae.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return LoginPage();
          },
        ),
      ),
    );
  }
}
