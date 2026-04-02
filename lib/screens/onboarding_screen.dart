import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': '5분이면 내 브랜드의\n문제가 보입니다',
      'subtitle': '막막했던 브랜딩, 자가진단으로 시작하세요.',
    },
    {
      'title': '4개 영역 15문항으로\n정확하게 진단',
      'subtitle': '정체성, 고객, 첫인상, 신뢰감 영역을 분석합니다.',
    },
    {
      'title': '전문가의\n맞춤 액션 플랜까지',
      'subtitle': '진단 결과에 맞는 다음 스텝을 제안해 드립니다.',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/brand_info');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            index == 0 ? Icons.search : index == 1 ? Icons.bar_chart : Icons.check_circle_outline,
                            size: 80,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _slides[index]['title']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _slides[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? theme.primaryColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300), 
                      curve: Curves.easeInOut
                    );
                  } else {
                    _completeOnboarding();
                  }
                },
                child: Text(_currentPage < _slides.length - 1 ? '다음' : '지금 바로 진단하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
