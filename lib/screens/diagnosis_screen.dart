import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diagnosis_provider.dart';
import '../models/question.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  bool _isLoading = false;

  void _onAnswered(int score) async {
    final provider = Provider.of<DiagnosisProvider>(context, listen: false);
    final isLastQuestion = provider.currentIndex == allQuestions.length - 1;

    await provider.answerQuestion(provider.currentQuestion.id, score);

    if (isLastQuestion) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(
                '당신의 브랜드를\n분석하고 있습니다...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      );
    }

    final provider = Provider.of<DiagnosisProvider>(context);
    final question = provider.currentQuestion;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BRANDR'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (provider.currentIndex + 1) / allQuestions.length,
              backgroundColor: Colors.grey[300],
              color: theme.primaryColor,
              minHeight: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            question.category.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: question.category.color,
                        ),
                        Text(
                          '${provider.currentIndex + 1} / ${allQuestions.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          question.text,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(height: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        int score = index + 1;
                        bool isSelected = provider.answers[question.id] == score;
                        return GestureDetector(
                          onTap: () => _onAnswered(score),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? theme.primaryColor : Colors.white,
                              border: Border.all(
                                color: isSelected ? theme.primaryColor : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$score',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('전혀 아니다', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        Text('보통', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        Text('매우 그렇다', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (provider.currentIndex > 0)
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('이전 문항으로'),
                        onPressed: () => provider.goBack(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
