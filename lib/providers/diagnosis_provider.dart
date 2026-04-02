import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/question.dart';

class DiagnosisProvider with ChangeNotifier {
  Map<int, int> _answers = {};
  int _currentIndex = 0;
  String? _brandName;
  String? _industry;
  bool _isCompleted = false;

  Map<int, int> get answers => _answers;
  int get currentIndex => _currentIndex;
  String? get brandName => _brandName;
  String? get industry => _industry;
  bool get isCompleted => _isCompleted;
  
  Question get currentQuestion => allQuestions[_currentIndex];
  double get progress => (_currentIndex) / allQuestions.length;

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _brandName = prefs.getString('brandName');
    _industry = prefs.getString('industry');
    _currentIndex = prefs.getInt('currentIndex') ?? 0;
    _isCompleted = prefs.getBool('isCompleted') ?? false;
    
    final answersString = prefs.getString('answers');
    if (answersString != null) {
      try {
        final decodedMap = jsonDecode(answersString) as Map<String, dynamic>;
        _answers = decodedMap.map((key, value) => MapEntry(int.parse(key), value as int));
      } catch (e) {
        _answers = {};
      }
    }
    
    // Ensure index bounds
    if (_currentIndex >= allQuestions.length) {
      _currentIndex = allQuestions.length - 1;
    }
    
    notifyListeners();
  }

  Future<void> setBrandInfo(String name, String ind) async {
    _brandName = name.trim().isEmpty ? null : name.trim();
    _industry = ind;
    final prefs = await SharedPreferences.getInstance();
    if (_brandName != null) {
      prefs.setString('brandName', _brandName!);
    } else {
      prefs.remove('brandName');
    }
    prefs.setString('industry', _industry!);
    notifyListeners();
  }

  Future<void> answerQuestion(int qId, int score) async {
    _answers[qId] = score;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('answers', jsonEncode(_answers.map((key, value) => MapEntry(key.toString(), value))));
    
    if (_currentIndex < allQuestions.length - 1) {
      _currentIndex++;
      prefs.setInt('currentIndex', _currentIndex);
    } else {
      _isCompleted = true;
      prefs.setBool('isCompleted', true);
    }
    notifyListeners();
  }

  Future<void> goBack() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('currentIndex', _currentIndex);
      // Optional: don't clear the answer, let it stay pre-selected if they return
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _answers.clear();
    _currentIndex = 0;
    _isCompleted = false;
    _brandName = null;
    _industry = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('brandName');
    await prefs.remove('industry');
    await prefs.remove('answers');
    await prefs.remove('currentIndex');
    await prefs.remove('isCompleted');
    notifyListeners();
  }

  // --- Analytics & Scoring ---
  Map<Category, int> calculateRawScores() {
    Map<Category, int> rawScores = {
      Category.identity: 0,
      Category.target: 0,
      Category.visual: 0,
      Category.trust: 0,
    };
    for (var q in allQuestions) {
      if (_answers.containsKey(q.id)) {
        rawScores[q.category] = (rawScores[q.category] ?? 0) + _answers[q.id]!;
      }
    }
    return rawScores;
  }

  Map<Category, int> calculateScaledScores() {
    final rawScores = calculateRawScores();
    return {
      Category.identity: ((rawScores[Category.identity] ?? 0) / 20 * 25).round(),
      Category.target: ((rawScores[Category.target] ?? 0) / 20 * 25).round(),
      Category.visual: ((rawScores[Category.visual] ?? 0) / 20 * 25).round(),
      Category.trust: ((rawScores[Category.trust] ?? 0) / 15 * 25).round(),
    };
  }

  int calculateTotalScore() {
    final rawScores = calculateRawScores();
    int totalRaw = rawScores.values.fold(0, (sum, score) => sum + score);
    if (totalRaw < 15) return 0;
    int totalScore = ((totalRaw - 15) / 60 * 100).round();
    return totalScore.clamp(0, 100);
  }

  String getBrandType() {
    int score = calculateTotalScore();
    if (score <= 39) return '씨앗 브랜드 🌱';
    if (score <= 59) return '성장 브랜드 🌿';
    if (score <= 79) return '혼재 브랜드 🌳';
    return '완성 브랜드 👑';
  }
  
  String getBrandTypeDescription() {
    int score = calculateTotalScore();
    if (score <= 39) return '제품엔 자신 있는데, 왜 안 팔리는지 모르는 상태예요';
    if (score <= 59) return '뭔가 되고 있는데, 아직 일관성이 없어요';
    if (score <= 79) return '잘하는 것도 있고 구멍도 있어요. 딱 거기서 막힌 상태예요';
    return '브랜드가 혼자 일하고 있어요. 사장님 없이도요';
  }
  
  Color getBrandColor() {
    int score = calculateTotalScore();
    if (score <= 39) return const Color(0xFF4A7C59); // Sage Green
    if (score <= 59) return const Color(0xFF2A7886); // Teal Blue
    if (score <= 79) return const Color(0xFF3D5A99); // Indigo
    return const Color(0xFF1A1A2E); // Deep Navy
  }

  Category getWeakestCategory() {
    final scaled = calculateScaledScores();
    Category weakest = Category.identity;
    int minScore = 26; // max is 25
    
    // Ordered by priority: Identity > Target > Visual > Trust
    for (var cat in [Category.identity, Category.target, Category.visual, Category.trust]) {
      if (scaled[cat]! < minScore) {
        minScore = scaled[cat]!;
        weakest = cat;
      }
    }
    return weakest;
  }
}
