import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diagnosis_provider.dart';

class BrandInfoScreen extends StatefulWidget {
  const BrandInfoScreen({super.key});

  @override
  State<BrandInfoScreen> createState() => _BrandInfoScreenState();
}

class _BrandInfoScreenState extends State<BrandInfoScreen> {
  final _nameController = TextEditingController();
  String _selectedIndustry = '뷰티';
  
  final List<String> _industries = [
    '뷰티', 'F&B', '패션', '라이프스타일', '서비스', '기타'
  ];

  void _startDiagnosis() async {
    final provider = Provider.of<DiagnosisProvider>(context, listen: false);
    
    // 브랜드 정보를 세팅하고 새로운 진단을 시작
    await provider.reset();
    await provider.setBrandInfo(_nameController.text, _selectedIndustry);
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/diagnosis');
  }

  void _skip() async {
    final provider = Provider.of<DiagnosisProvider>(context, listen: false);
    await provider.reset();
    await provider.setBrandInfo('', _selectedIndustry);
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/diagnosis');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<DiagnosisProvider>(context, listen: false);

    // EC-01: 이전 진단 진행 상태 확인 (재방문 복원)
    final bool hasInProgress = provider.currentIndex > 0 && !provider.isCompleted;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BRANDR'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '브랜드 정보를\n입력해 주세요',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '더 정확한 맞춤 솔루션을 위해 배정됩니다.',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              
              const Text('브랜드명 (선택)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                maxLength: 20,
                scribbleEnabled: false, // 강제로 핸드라이팅 무시, 무조건 키보드 출력
                decoration: InputDecoration(
                  hintText: '브랜드 이름을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              const Text('업종 선택', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _industries.map((industry) {
                  final isSelected = _selectedIndustry == industry;
                  return ChoiceChip(
                    label: Text(industry),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedIndustry = industry);
                    },
                    selectedColor: theme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),

              const SizedBox(height: 48),
              
              if (hasInProgress)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/diagnosis');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: BorderSide(color: theme.primaryColor),
                    ),
                    child: Text('진행 중인 진단 이어서 하기 (${provider.currentIndex + 1}/15)'),
                  ),
                ),

              ElevatedButton(
                onPressed: _startDiagnosis,
                child: const Text('진단 시작'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _skip,
                  child: const Text('건너뛰기', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
