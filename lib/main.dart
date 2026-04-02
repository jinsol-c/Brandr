import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/diagnosis_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/brand_info_screen.dart';
import 'screens/diagnosis_screen.dart';
import 'screens/result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiagnosisProvider()..loadState()),
      ],
      child: const BrandrApp(),
    ),
  );
}

class BrandrApp extends StatelessWidget {
  const BrandrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brandr',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/brand_info': (context) => const BrandInfoScreen(),
        '/diagnosis': (context) => const DiagnosisScreen(),
        '/result': (context) => const ResultScreen(),
      },
      builder: (context, child) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 927;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 927 : double.infinity,
                  ),
                  child: child!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}