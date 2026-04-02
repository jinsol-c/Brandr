import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/diagnosis_provider.dart';
import '../theme/app_theme.dart';
import '../models/question.dart';
import '../widgets/radar_chart_widget.dart';
import '../utils/export_helper.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey _globalKey = GlobalKey(); // For RepaintBoundary

  void _openConsultation() async {
    // 임시 카카오 오픈채팅 링크 (오픈채팅/챗봇)
    final url = Uri.parse('https://open.kakao.com/o/smsWBkoi');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다. 카카오톡이 설정되어 있는지 확인해주세요.')));
      }
    }
  }

  void _saveToGallery() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이미지를 저장 중입니다...')));
    final success = await ExportHelper.saveToGallery(_globalKey);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장되었어요! 📸 갤러리를 확인해주세요.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이미지 저장에 실패했어요. 잠시 후 시도해주세요.')));
    }
  }

  void _share() async {
    await ExportHelper.shareResult(_globalKey);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiagnosisProvider>(context);
    final theme = Theme.of(context);
    
    final totalScore = provider.calculateTotalScore();
    final scaledScores = provider.calculateScaledScores();
    final brandType = provider.getBrandType();
    final brandColor = provider.getBrandColor();
    final weakest = provider.getWeakestCategory();
    
    // Action Plan text based on weakest category
    String weakSummary = '';
    List<String> actions = [];
    switch (weakest) {
      case Category.identity:
        weakSummary = '고객이 사장님 브랜드를 설명 못 해요';
        actions = ['브랜드를 한 문장으로 정의하기', '경쟁 브랜드 3개와 나의 차이점 목록 작성', '브랜드가 절대 하지 않을 것 3가지 정의'];
        break;
      case Category.target:
        weakSummary = '모든 사람한테 팔려고 하고 있어요';
        actions = ['실제 구매 고객 5명 직접 인터뷰', '타겟이 가장 많이 쓰는 SNS 1개 집중', '고객 페르소나 1장짜리 문서 만들기'];
        break;
      case Category.visual:
        weakSummary = '첫인상에서 지고 있어요';
        actions = ['대표 컬러 1개와 폰트 1개만 정하기', '모든 SNS 프로필 사진·커버 통일', '브랜드 가이드라인 1페이지 만들기'];
        break;
      case Category.trust:
        weakSummary = '온라인에서 검색하면 안 나와요';
        actions = ['고객 후기 3개 받아 SNS에 올리기', '네이버 플레이스 또는 구글 비즈니스 등록', '가격표를 브랜드 포지션에 맞게 재정비'];
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 결과'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
             Navigator.pushNamedAndRemoveUntil(context, '/brand_info', (route) => false);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: _saveToGallery),
          IconButton(icon: const Icon(Icons.share), onPressed: _share),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // RepaintBoundary for social share card
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [brandColor, brandColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      provider.brandName != null ? '${provider.brandName}님의 브랜드는' : '나의 브랜드는',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        brandType,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '$totalScore',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const Text('종합 점수', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 32),
                    
                    // Radar chart
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: RadarChartWidget(scaledScores: scaledScores),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'BRANDR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Text summary
            Text(
              '취약 영역 집중 분석',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          '${weakest.name} 영역이 가장 약해요!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      weakSummary,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      '맞춤 액션 플랜 3가지',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(actions.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text('${index + 1}', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(actions[index], style: const TextStyle(fontSize: 15, height: 1.4))),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),

            OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(color: AppTheme.accentColor),
              ),
              child: const Text(
                '다시 진단하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _openConsultation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                '브랜다 1:1 코칭 문의',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
