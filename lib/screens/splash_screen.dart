import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/diagnosis_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    // PRD: 스플래시 대기 1.5초
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    
    final provider = Provider.of<DiagnosisProvider>(context, listen: false);
    
    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      if (provider.isCompleted) {
        // 이미 진단을 완료했던 유저는 결과 뷰를 복원
        Navigator.pushReplacementNamed(context, '/result');
      } else {
        // 첫 진단이거나, 진행 중이던 유저는 정보 입력 창으로 이동 
        // (정보 입력 창에서 '이어서 하기' 버튼을 노출함)
        Navigator.pushReplacementNamed(context, '/brand_info');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BRANDR',
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 4.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '내 브랜드, 지금 어디 있나요?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
