import 'package:flutter/material.dart';

class SharedExpense {
  final String title;
  final double total;
  final double paid;
  final List<String> participants;
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;

  SharedExpense({
    required this.title,
    required this.total,
    required this.paid,
    required this.participants,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
  });
}
