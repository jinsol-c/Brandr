import 'package:flutter/material.dart';

enum Category { identity, target, visual, trust }

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.identity:
        return '정체성';
      case Category.target:
        return '고객';
      case Category.visual:
        return '첫인상';
      case Category.trust:
        return '신뢰감';
    }
  }

  String get description {
    switch (this) {
      case Category.identity:
        return '우리 브랜드만의 다움이 있나요?';
      case Category.target:
        return '누구의 문제를 해결하는 브랜드인가요?';
      case Category.visual:
        return '어디서 봐도 같은 브랜드로 보이나요?';
      case Category.trust:
        return '처음 보는 고객도 믿고 살 수 있나요?';
    }
  }

  Color get color {
    switch (this) {
      case Category.identity:
        return const Color(0xFF4A7C59); // Sage Green
      case Category.target:
        return const Color(0xFF2E5FA3); // Royal Blue
      case Category.visual:
        return const Color(0xFFB8860B); // Gold
      case Category.trust:
        return const Color(0xFF3D5A99); // Indigo
    }
  }
}

class Question {
  final int id;
  final String text;
  final Category category;
  final String intent;

  Question({
    required this.id,
    required this.text,
    required this.category,
    required this.intent,
  });
}

final List<Question> allQuestions = [
  // 정체성 (Identity)
  Question(id: 1, text: '우리 브랜드를 한 문장으로 설명할 수 있다', category: Category.identity, intent: '브랜드 포지셔닝 명확성'),
  Question(id: 2, text: '경쟁 브랜드와 우리가 다른 점을 구체적으로 말할 수 있다', category: Category.identity, intent: '차별화 포인트 존재 여부'),
  Question(id: 3, text: '10년 후에도 지키고 싶은 브랜드 가치관이 있다', category: Category.identity, intent: '브랜드 지속가능성·철학'),
  Question(id: 4, text: '브랜드 이름·슬로건에 우리만의 의미가 담겨 있다', category: Category.identity, intent: '네이밍 전략 완성도'),
  
  // 고객 (Target)
  Question(id: 5, text: '주요 고객을 나이·성별·직업·취향까지 구체적으로 그릴 수 있다', category: Category.target, intent: '페르소나 구체성'),
  Question(id: 6, text: '고객이 우리 브랜드를 선택하는 이유를 정확히 알고 있다', category: Category.target, intent: '구매 동기 파악'),
  Question(id: 7, text: '타겟 고객이 실제로 돈을 쓰는 사람인지 검증한 적 있다', category: Category.target, intent: '타겟 유효성 검증'),
  Question(id: 8, text: '타겟 고객이 주로 사용하는 SNS·커뮤니티를 알고 거기에 있다', category: Category.target, intent: '채널 정합성'),
  
  // 첫인상 (Visual)
  Question(id: 9, text: '로고·대표 컬러·폰트가 명확하게 정해져 있다', category: Category.visual, intent: '비주얼 아이덴티티 완성도'),
  Question(id: 10, text: 'SNS·명함·패키지·간판이 같은 느낌을 준다', category: Category.visual, intent: '브랜드 일관성'),
  Question(id: 11, text: '처음 보는 사람도 우리 브랜드 게시물을 바로 알아본다', category: Category.visual, intent: '브랜드 인식률'),
  Question(id: 12, text: '브랜드 비주얼이 타겟 고객의 감성과 잘 맞는다', category: Category.visual, intent: '비주얼-타겟 정합성'),
  
  // 신뢰감 (Trust)
  Question(id: 13, text: '실제 구매 후기·사용 사례가 온라인에 남아 있다', category: Category.trust, intent: '사회적 증거 보유'),
  Question(id: 14, text: '검색엔진에서 브랜드 이름을 검색하면 바로 나온다', category: Category.trust, intent: '온라인 존재감'),
  Question(id: 15, text: '우리 브랜드의 가격이 포지션과 일치한다고 느낀다', category: Category.trust, intent: '가격-브랜드 정합성'),
];
