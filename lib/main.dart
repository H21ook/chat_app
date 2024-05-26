import 'package:chat_app/providers/agora_provider.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/screens/account_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/screens/video_call_screen.dart';
import 'package:chat_app/utils/print.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AgoraProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MainState();
}

class _MainState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AgoraProvider>().init();
    context.read<AuthProvider>().init();
  }

  GoRouter initRouters() {
    final authProvider = Provider.of<AuthProvider>(context);
    return GoRouter(
      refreshListenable: authProvider,
      redirect: (context, state) {
        dPrint("Fullpath: ${state.fullPath}");
        if (authProvider.loading) {
          return "/splash";
        }
        if (authProvider.isLogged) {
          if (state.matchedLocation == "/splash") return "/";
          return null;
        }
        if ("/account" == state.fullPath) {
          return '/login';
        }
        if (state.matchedLocation == "/splash") return "/";
        return null;
      },
      initialLocation: "/splash",
      routes: [
        GoRoute(path: "/", builder: (context, state) => HomeScreen(), routes: [
          GoRoute(
            path: "videocall",
            builder: (context, state) => const VideoCallScreen(),
          ),
          GoRoute(
            path: "account",
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: "login",
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: "register",
            builder: (context, state) => RegisterScreen(),
          ),
          GoRoute(
            path: "splash",
            builder: (context, state) => const SplashScreen(),
          )
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: initRouters(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade400,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ));
  }
}
