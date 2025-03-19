import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfinance/core/screens/auth/login_screen.dart';
import 'package:myfinance/core/screens/homePage.dart';
import 'package:myfinance/core/services/auth_service.dart';
import 'package:myfinance/core/services/notification_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.initialize();
    } catch (e) {
      print('Error initializing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'MyFinance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: authState.when(
        data: (user) => user != null ? const HomePage() : const LoginScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const LoginScreen(),
      ),
    );
  }
}


