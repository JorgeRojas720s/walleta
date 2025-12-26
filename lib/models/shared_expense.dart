import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SharedExpense {
  final String? id;
  final String title;
  final double total;
  final double paid;
  final List<String> participants;
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final String? status;
  final DateTime? createdAt;

  SharedExpense({
    this.id,
    required this.title,
    required this.total,
    required this.paid,
    required this.participants,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    this.status,
    this.createdAt,
  });

  factory SharedExpense.fromMap(String id, Map<String, dynamic> map) {
    return SharedExpense(
      id: id,
      title: map['title'],
      total: (map['total'] as num).toDouble(),
      paid: (map['paid'] as num).toDouble(),
      participants: List<String>.from(map['participants']),
      category: map['category'],
      categoryIcon: IconData(
        map['categoryIcon'],
        fontFamily: map['categoryFontFamily'],
      ),
      categoryColor: Color(map['categoryColor']),
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// 👉 Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'total': total,
      'paid': paid,
      'participants': participants,
      'category': category,
      'categoryIcon': categoryIcon.codePoint,
      'categoryFontFamily': categoryIcon.fontFamily,
      'categoryColor': categoryColor.value,
    };
  }
}
